import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/session_service.dart';
import '../../shared/widgets/form_field_wrapper.dart';

class AddComercialScreen extends StatefulWidget {
  const AddComercialScreen({super.key});

  @override
  State<AddComercialScreen> createState() => _AddComercialScreenState();
}

class _AddComercialScreenState extends State<AddComercialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String _selectedTipo = 'CAPTACION';
  int? _selectedBossId;

  final List<Map<String, dynamic>> _bosses = [
    {'id': 1, 'name': 'Jorge Campos Postigo'},
    {'id': 2, 'name': 'Antonio Asensio García de la Rosa'},
    {'id': 3, 'name': 'Francisco Javier Castro Palacios'},
    {'id': 4, 'name': 'David Martín Contento'},
    {'id': 5, 'name': 'Juan Antonio Prieto Lancha'},
    {'id': 6, 'name': 'Antonio Sánchez Jiménez'},
  ];

  @override
  void initState() {
    super.initState();
    final user = SessionService.currentUser;
    if (user?.isJefeEquipo == true) {
      _selectedBossId = user!.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _createComercial() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService.createUser(
        email: _emailController.text.trim(),
        password: 'pass123', // Default password
        name: _nameController.text.trim(),
        role: 'COMERCIAL',
        tipo: _selectedTipo,
        bossId: _selectedBossId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comercial creado correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear comercial: $e'),
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
    final user = SessionService.currentUser;
    final isAdmin = user?.isAdministrador ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agregar Comercial'),
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

              // Form
              _buildForm(isAdmin),

              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
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
            Icons.person_add_outlined,
            size: 48,
            color: AppColors.success,
          ),
          const SizedBox(height: 16),
          Text(
            'Nuevo Comercial',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete los datos para crear un nuevo comercial en el sistema',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isAdmin) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Name
            FormFieldWrapper(
              label: 'Nombre Completo',
              required: true,
              child: TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            // Email
            FormFieldWrapper(
              label: 'Correo Electrónico',
              required: true,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'correo@empresa.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo es requerido';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            // Tipo
            FormFieldWrapper(
              label: 'Tipo de Comercial',
              required: true,
              child: DropdownButtonFormField<String>(
                value: _selectedTipo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'CAPTACION',
                    child: Text('Captación'),
                  ),
                  DropdownMenuItem(
                    value: 'FIDELIZACION',
                    child: Text('Fidelización'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTipo = value!;
                  });
                },
              ),
            ),

            if (isAdmin) ...[
              const SizedBox(height: 16),

              // Boss Selection (only for admins)
              FormFieldWrapper(
                label: 'Jefe de Equipo',
                required: true,
                child: DropdownButtonFormField<int>(
                  value: _selectedBossId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.supervisor_account_outlined),
                  ),
                  hint: const Text('Seleccione un jefe de equipo'),
                  items: _bosses.map((boss) {
                    return DropdownMenuItem<int>(
                      value: boss['id'],
                      child: Text(boss['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBossId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un jefe de equipo';
                    }
                    return null;
                  },
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Password Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'La contraseña inicial será "pass123". El usuario deberá cambiarla en su primer acceso.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createComercial,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Crear Comercial',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}