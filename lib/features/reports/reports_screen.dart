import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/download_service.dart';
import '../../shared/widgets/form_field_wrapper.dart';
import '../../shared/models/user.dart';

class ReportsScreen extends StatefulWidget {
  final bool isGlobal;

  const ReportsScreen({
    super.key,
    this.isGlobal = false,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingTeam = false;
  Map<String, dynamic>? _reportData;
  List<User> _teamMembers = [];
  User? _selectedComercial;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _loadTeamMembers();
  }

  void _initializeDates() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    _startDateController.text = _formatDate(firstDayOfMonth);
    _endDateController.text = _formatDate(lastDayOfMonth);
  }

  Future<void> _loadTeamMembers() async {
    if (widget.isGlobal) return; // No cargar equipo para reportes globales

    final user = SessionService.currentUser;
    if (user == null || !user.isJefeEquipo) return;

    setState(() => _isLoadingTeam = true);

    try {
      final members = await ApiService.getTeamMembers(user.id);
      setState(() {
        _teamMembers = members;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar equipo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingTeam = false);
      }
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final initialDate = _parseDate(controller.text) ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      controller.text = _formatDate(date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Handle parse error
    }
    return null;
  }

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = SessionService.currentUser!;

      // Determinar parámetros según el rol
      int? jefeEquipoId;
      int? comercialId;

      if (widget.isGlobal) {
        // Para administradores: sin filtros específicos (todos los datos)
      } else if (user.isJefeEquipo) {
        jefeEquipoId = user.id;
      } else if (user.isComercial) {
        comercialId = user.id;
      }

      // Si hay un comercial seleccionado, usar su ID
      if (_selectedComercial != null) {
        comercialId = _selectedComercial!.id;
      }

      print('DEBUG: Llamando a ApiService.getReports con:');
      print('DEBUG: jefeEquipoId: $jefeEquipoId');
      print('DEBUG: comercialId: $comercialId');
      print('DEBUG: fechaInicio: ${_startDateController.text}');
      print('DEBUG: fechaFin: ${_endDateController.text}');

      final data = await ApiService.getReports(
        jefeEquipoId: jefeEquipoId,
        comercialId: comercialId,
        fechaInicio: _startDateController.text, // DD/MM/YYYY format
        fechaFin: _endDateController.text,      // DD/MM/YYYY format
      );

      print('DEBUG: Respuesta de ApiService.getReports: $data');

      setState(() {
        _reportData = data;
      });

      // Descargar automáticamente
      _downloadReport();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar reporte: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isGlobal ? 'Informes Globales' : 'Informes del Equipo'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32),

              // Date Range Form
              _buildDateRangeForm(),

              const SizedBox(height: 32),

              // Generate Button
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            widget.isGlobal ? Icons.analytics_outlined : Icons.assessment_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isGlobal ? 'Reportes Globales' : 'Reportes del Equipo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isGlobal
                ? 'Seleccione un rango de fechas y descargue los reportes de todos los equipos'
                : 'Seleccione un rango de fechas y descargue los reportes de su equipo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeForm() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rango de Fechas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Start Date
            FormFieldWrapper(
              label: 'Fecha de Inicio',
              required: true,
              child: GestureDetector(
                onTap: () => _selectDate(_startDateController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      hintText: 'Seleccione fecha de inicio',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione la fecha de inicio';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // End Date
            FormFieldWrapper(
              label: 'Fecha de Fin',
              required: true,
              child: GestureDetector(
                onTap: () => _selectDate(_endDateController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      hintText: 'Seleccione fecha de fin',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione la fecha de fin';
                      }

                      final startDate = _parseDate(_startDateController.text);
                      final endDate = _parseDate(value);

                      if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
                        return 'La fecha de fin debe ser posterior a la de inicio';
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),

            // Commercial Filter (only for team leaders)
            if (!widget.isGlobal && _teamMembers.isNotEmpty) ...[
              const SizedBox(height: 16),
              FormFieldWrapper(
                label: 'Filtrar por Comercial',
                required: false,
                child: DropdownButtonFormField<User>(
                  value: _selectedComercial,
                  decoration: const InputDecoration(
                    hintText: 'Todos los comerciales',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: [
                    const DropdownMenuItem<User>(
                      value: null,
                      child: Text('Todos los comerciales'),
                    ),
                    ..._teamMembers.map((comercial) {
                      return DropdownMenuItem<User>(
                        value: comercial,
                        child: Text(comercial.name),
                      );
                    }),
                  ],
                  onChanged: (User? value) {
                    setState(() {
                      _selectedComercial = value;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _generateReport,
        icon: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.download_outlined),
        label: Text(_isLoading ? 'Generando...' : 'Generar y Descargar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _downloadReport() {
    if (_reportData != null) {
      try {
        final user = SessionService.currentUser!;
        final teamName = widget.isGlobal ? 'Global' : user.name.replaceAll(' ', '_');
        final dateRange = '${_startDateController.text.replaceAll('/', '-')}_${_endDateController.text.replaceAll('/', '-')}';
        final timestamp = DateTime.now().millisecondsSinceEpoch;

        final filename = 'Reporte_${teamName}_${dateRange}_$timestamp.xlsx';

        // Verificar que los datos no estén vacíos
        if (_reportData!.isEmpty) {
          throw Exception('Los datos del reporte están vacíos');
        }

        // Descargar como XLSX
        DownloadService.downloadXLSX(
          data: _reportData!,
          filename: filename,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reporte descargado: $filename'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debe generar un reporte'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }
}