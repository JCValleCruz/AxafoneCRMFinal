import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/location_service.dart';
import '../../shared/models/form_submission.dart';
import '../../shared/widgets/form_field_wrapper.dart';

class FormScreen extends StatefulWidget {
  final bool isEditMode;
  final String? clientId;
  final String? tipoInforme; // 'CAPTACION' o 'FIDELIZACION'

  const FormScreen({
    super.key,
    this.isEditMode = false,
    this.clientId,
    this.tipoInforme,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isLoading = false;

  // Form Controllers
  final _clienteController = TextEditingController();
  final _cifController = TextEditingController();
  final _direccionController = TextEditingController();
  final _personaContactoController = TextEditingController();
  final _cargoContactoController = TextEditingController();
  final _telefonoContactoController = TextEditingController();
  final _emailContactoController = TextEditingController();
  final _direccionRealController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  // Business data controllers
  final _finPermanenciaController = TextEditingController();
  final _sedesActualesController = TextEditingController();
  final _operadorActualController = TextEditingController();
  final _numLineasMovilesController = TextEditingController();
  final _centralizaController = TextEditingController();
  final _extensionesController = TextEditingController();
  final _numeroEmpleadosController = TextEditingController();

  // Service controllers
  final _proveedorControlHorarioController = TextEditingController();
  final _numLicenciasControlHorarioController = TextEditingController();
  final _fechaRenovacionControlHorarioController = TextEditingController();
  final _proveedorCorreoController = TextEditingController();
  final _licenciasOfficeController = TextEditingController();
  final _fechaRenovacionOfficeController = TextEditingController();

  // Fidelización specific controllers
  final _sedesNuevasController = TextEditingController();
  final _numLineasMovilesNuevasController = TextEditingController();
  final _proveedorMantenimientoController = TextEditingController();

  // Form state
  String _contactoEsDecisor = 'SI';
  String _soloVoz = 'NO';
  String _m2m = 'NO';
  String _fibrasActuales = 'NO';
  String _ciberseguridad = 'NO';
  String _registrosHorario = 'NO';
  String _mantenimientoInformatico = 'NO';
  String _disponeNegocioDigital = 'NO';
  String _admiteLlamadaNps = 'SI';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    print('FormScreen initState: isEditMode=${widget.isEditMode}, clientId=${widget.clientId}');
    if (widget.clientId != null) {
      print('Loading form data for clientId: ${widget.clientId}');
      _loadFormData();
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
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
      if (picked != null && mounted) {
        controller.text = '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir el calendario'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        _latitudController.text = position.latitude.toString();
        _longitudController.text = position.longitude.toString();
        _direccionRealController.text = LocationService.formatCoordinates(position);
      }
    } catch (e) {
      // Error al obtener ubicación - continuar sin coordenadas
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener la ubicación actual'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _clienteController.dispose();
    _cifController.dispose();
    _direccionController.dispose();
    _personaContactoController.dispose();
    _cargoContactoController.dispose();
    _telefonoContactoController.dispose();
    _emailContactoController.dispose();
    _direccionRealController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _finPermanenciaController.dispose();
    _sedesActualesController.dispose();
    _operadorActualController.dispose();
    _numLineasMovilesController.dispose();
    _centralizaController.dispose();
    _extensionesController.dispose();
    _numeroEmpleadosController.dispose();
    _proveedorControlHorarioController.dispose();
    _numLicenciasControlHorarioController.dispose();
    _fechaRenovacionControlHorarioController.dispose();
    _proveedorCorreoController.dispose();
    _licenciasOfficeController.dispose();
    _fechaRenovacionOfficeController.dispose();
    _sedesNuevasController.dispose();
    _numLineasMovilesNuevasController.dispose();
    _proveedorMantenimientoController.dispose();
  }

  Future<void> _loadFormData() async {
    if (widget.clientId == null) return;
    print('_loadFormData called with clientId: ${widget.clientId}');

    setState(() => _isLoading = true);

    try {
      print('Calling ApiService.getFormById with: ${widget.clientId}');
      final form = await ApiService.getFormById(widget.clientId!);
      print('Form data received: ${form.cliente}, CIF: ${form.cif}');
      _populateForm(form);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: $e'),
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

  void _populateForm(FormSubmission form) {
    print('_populateForm called with form data: ${form.cliente}');
    // Datos básicos del cliente
    _clienteController.text = form.cliente ?? '';
    _cifController.text = form.cif ?? '';
    _direccionController.text = form.direccion ?? '';
    _personaContactoController.text = form.personaContacto ?? '';
    _cargoContactoController.text = form.cargoContacto ?? '';
    _telefonoContactoController.text = form.telefonoContacto ?? '';
    _emailContactoController.text = form.emailContacto ?? '';
    _direccionRealController.text = form.direccionReal ?? '';
    _latitudController.text = form.latitude?.toString() ?? '';
    _longitudController.text = form.longitude?.toString() ?? '';

    // Datos comerciales
    _finPermanenciaController.text = form.finPermanencia ?? '';
    _sedesActualesController.text = form.sedesActuales?.toString() ?? '';
    _operadorActualController.text = form.operadorActual ?? '';
    _numLineasMovilesController.text = form.numLineasMoviles?.toString() ?? '';
    _centralizaController.text = form.centralita ?? '';
    _extensionesController.text = form.extensiones?.toString() ?? '';
    _numeroEmpleadosController.text = form.numeroEmpleados?.toString() ?? '';

    // Servicios
    _proveedorControlHorarioController.text = form.proveedorControlHorario ?? '';
    _numLicenciasControlHorarioController.text = form.numLicenciasControlHorario?.toString() ?? '';
    _fechaRenovacionControlHorarioController.text = form.fechaRenovacionControlHorario ?? '';
    _proveedorCorreoController.text = form.proveedorCorreo ?? '';
    _licenciasOfficeController.text = form.licenciasOffice?.toString() ?? '';
    _fechaRenovacionOfficeController.text = form.fechaRenovacionOffice ?? '';

    // Campos específicos fidelización
    _sedesNuevasController.text = form.sedesNuevas?.toString() ?? '';
    _numLineasMovilesNuevasController.text = form.numLineasMovilesNuevas?.toString() ?? '';
    _proveedorMantenimientoController.text = form.proveedorMantenimiento ?? '';

    setState(() {
      _contactoEsDecisor = form.contactoEsDecisor ?? 'NO';
      _soloVoz = form.soloVoz ?? 'NO';
      _m2m = form.m2m ?? 'NO';
      _fibrasActuales = form.fibrasActuales ?? 'NO';
      _ciberseguridad = form.ciberseguridad ?? 'NO';
      _registrosHorario = form.registrosHorario ?? 'NO';
      _mantenimientoInformatico = form.mantenimientoInformatico ?? 'NO';
      _disponeNegocioDigital = form.disponeNegocioDigital ?? 'NO';
      _admiteLlamadaNps = form.admiteLlamadaNps ?? 'SI';
    });
    print('_populateForm completed. Cliente field: ${_clienteController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surface,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildModernAppBar(context),
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              else ...[
                _buildProgressIndicator(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildClientDataStep(),
                      _buildContactDataStep(),
                      _buildBusinessDataStep(),
                      _buildServicesDataStep(),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.accentDark,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditMode
                      ? 'Editar Informe'
                      : widget.tipoInforme == 'CAPTACIÓN'
                          ? 'Informe Captación'
                          : widget.tipoInforme == 'FIDELIZACIÓN'
                              ? 'Informe Fidelización'
                              : 'Nuevo Informe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paso ${_currentStep + 1} de $_totalSteps',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [AppColors.primary, AppColors.accentDark],
                          )
                        : null,
                    color: isActive ? null : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isActive ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso del formulario',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentStep + 1}/$_totalSteps',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientDataStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos del Cliente',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            FormFieldWrapper(
              label: 'Nombre de la Empresa',
              required: true,
              child: TextFormField(
                controller: _clienteController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el nombre de la empresa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            FormFieldWrapper(
              label: 'CIF',
              required: true,
              child: TextFormField(
                controller: _cifController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el CIF de la empresa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            FormFieldWrapper(
              label: 'Dirección',
              required: true,
              child: TextFormField(
                controller: _direccionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Ingrese la dirección de la empresa',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),

            // Campo dirección real ocultado - se llena automáticamente con GPS
          ],
        ),
      ),
    );
  }

  Widget _buildContactDataStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos de Contacto',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          FormFieldWrapper(
            label: 'Persona de Contacto',
            required: true,
            child: TextFormField(
              controller: _personaContactoController,
              decoration: const InputDecoration(
                hintText: 'Nombre de la persona de contacto',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Cargo del Contacto',
            required: true,
            child: TextFormField(
              controller: _cargoContactoController,
              decoration: const InputDecoration(
                hintText: 'Cargo de la persona de contacto',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: '¿El contacto es decisor?',
            required: true,
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Sí'),
                    value: 'SI',
                    groupValue: _contactoEsDecisor,
                    onChanged: (value) {
                      setState(() {
                        _contactoEsDecisor = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('No'),
                    value: 'NO',
                    groupValue: _contactoEsDecisor,
                    onChanged: (value) {
                      setState(() {
                        _contactoEsDecisor = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Teléfono de Contacto',
            required: true,
            child: TextFormField(
              controller: _telefonoContactoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Número de teléfono',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Email de Contacto',
            required: true,
            child: TextFormField(
              controller: _emailContactoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'correo@empresa.com',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Ingrese un email válido';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDataStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos Comerciales',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          FormFieldWrapper(
            label: 'Fin de Permanencia',
            child: TextFormField(
              controller: _finPermanenciaController,
              decoration: const InputDecoration(
                hintText: 'DD/MM/AAAA',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Número de Sedes Actuales',
            child: TextFormField(
              controller: _sedesActualesController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Número de sedes',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Operador Actual',
            child: TextFormField(
              controller: _operadorActualController,
              decoration: const InputDecoration(
                hintText: 'Nombre del operador actual',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Número de Líneas Móviles',
            child: TextFormField(
              controller: _numLineasMovilesController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Número de líneas móviles',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Centralita',
            child: TextFormField(
              controller: _centralizaController,
              decoration: const InputDecoration(
                hintText: 'Información sobre centralita',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: '¿Solo voz?',
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Sí'),
                    value: 'SI',
                    groupValue: _soloVoz,
                    onChanged: (value) {
                      setState(() {
                        _soloVoz = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('No'),
                    value: 'NO',
                    groupValue: _soloVoz,
                    onChanged: (value) {
                      setState(() {
                        _soloVoz = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Número de Empleados',
            child: TextFormField(
              controller: _numeroEmpleadosController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Número total de empleados',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesDataStep() {
    final user = SessionService.currentUser;

    // Lógica corregida:
    // 1. Modo edición (búsqueda cliente) -> SIEMPRE vista fidelización (datos completos)
    // 2. Modo creación -> depende del tipo de informe especificado
    // 3. Si no se especifica tipo -> depende del tipo de usuario
    final showFidelizacionFields = widget.isEditMode ||  // Búsqueda cliente = vista completa
        widget.tipoInforme == 'FIDELIZACIÓN' ||           // Informe fidelización explícito
        (widget.tipoInforme == null && user?.isFidelizacion == true); // Usuario fidelización sin especificar tipo

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servicios y Tecnología',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          _buildSwitchField(
            'M2M (Machine to Machine)',
            _m2m,
            (value) => setState(() => _m2m = value),
          ),

          _buildSwitchField(
            'Fibras Actuales',
            _fibrasActuales,
            (value) => setState(() => _fibrasActuales = value),
          ),

          _buildSwitchField(
            'Ciberseguridad',
            _ciberseguridad,
            (value) => setState(() => _ciberseguridad = value),
          ),

          _buildSwitchField(
            'Registros de Horario',
            _registrosHorario,
            (value) => setState(() => _registrosHorario = value),
          ),

          if (_registrosHorario == 'SI') ...[
            const SizedBox(height: 16),
            FormFieldWrapper(
              label: 'Proveedor Control Horario',
              child: TextFormField(
                controller: _proveedorControlHorarioController,
                decoration: const InputDecoration(
                  hintText: 'Nombre del proveedor',
                ),
              ),
            ),
            const SizedBox(height: 16),
            FormFieldWrapper(
              label: 'Fecha Renovación Control Horario',
              child: TextFormField(
                controller: _fechaRenovacionControlHorarioController,
                decoration: const InputDecoration(
                  hintText: 'DD/MM/AAAA',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _fechaRenovacionControlHorarioController),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Licencias Control Horario - FUERA del checkbox de Registros de Horario
          FormFieldWrapper(
            label: 'Licencias Control Horario',
            child: TextFormField(
              controller: _numLicenciasControlHorarioController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Número de licencias',
              ),
            ),
          ),

          _buildSwitchField(
            'Mantenimiento Informático',
            _mantenimientoInformatico,
            (value) => setState(() => _mantenimientoInformatico = value),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Proveedor de Correo',
            child: TextFormField(
              controller: _proveedorCorreoController,
              decoration: const InputDecoration(
                hintText: 'Gmail, Outlook, etc.',
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormFieldWrapper(
            label: 'Licencias Office',
            child: TextFormField(
              controller: _licenciasOfficeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Número de licencias Office',
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to show/hide date field
              },
            ),
          ),


          // Campos específicos para FIDELIZACIÓN
          if (showFidelizacionFields) ...[
            const SizedBox(height: 24),
            Text(
              'Datos Específicos - Fidelización',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 16),

            FormFieldWrapper(
              label: 'Sedes Nuevas',
              child: TextFormField(
                controller: _sedesNuevasController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'Número de sedes nuevas',
                ),
              ),
            ),

            const SizedBox(height: 16),

            FormFieldWrapper(
              label: 'Proveedor de Mantenimiento',
              child: TextFormField(
                controller: _proveedorMantenimientoController,
                decoration: const InputDecoration(
                  hintText: 'Nombre del proveedor',
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildSwitchField(
              'Dispone Negocio Digital',
              _disponeNegocioDigital,
              (value) => setState(() => _disponeNegocioDigital = value),
            ),

            _buildSwitchField(
              'Admite Llamada NPS',
              _admiteLlamadaNps,
              (value) => setState(() => _admiteLlamadaNps = value),
            ),
          ],

          // Fecha Renovación Office - ÚLTIMO CAMPO del formulario
          const SizedBox(height: 24),

          FormFieldWrapper(
            label: 'Fecha Renovación Licencias Office',
            child: TextFormField(
              controller: _fechaRenovacionOfficeController,
              decoration: const InputDecoration(
                hintText: 'DD/MM/AAAA',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _fechaRenovacionOfficeController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchField(String label, String value, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: 'SI',
                groupValue: value,
                onChanged: (val) => onChanged(val!),
              ),
              const Text('Sí'),
              const SizedBox(width: 16),
              Radio<String>(
                value: 'NO',
                groupValue: value,
                onChanged: (val) => onChanged(val!),
              ),
              const Text('No'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Anterior'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep < _totalSteps - 1 ? _nextStep : _submitForm,
              child: Text(
                _currentStep < _totalSteps - 1 ? 'Siguiente' : 'Guardar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _formKey.currentState?.validate() ?? false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = SessionService.currentUser!;

      final formSubmission = FormSubmission(
        userId: user.id,
        jefeEquipoId: user.bossId ?? user.id,
        latitude: _latitudController.text.isEmpty ? null : double.tryParse(_latitudController.text),
        longitude: _longitudController.text.isEmpty ? null : double.tryParse(_longitudController.text),
        locationAddress: _direccionRealController.text.isEmpty ? null : _direccionRealController.text,
        cliente: _clienteController.text,
        cif: _cifController.text,
        direccion: _direccionController.text,
        personaContacto: _personaContactoController.text,
        cargoContacto: _cargoContactoController.text,
        contactoEsDecisor: _contactoEsDecisor,
        telefonoContacto: _telefonoContactoController.text,
        emailContacto: _emailContactoController.text,
        direccionReal: _direccionRealController.text.isEmpty ? null : _direccionRealController.text,
        finPermanencia: _finPermanenciaController.text.isEmpty ? null : _finPermanenciaController.text,
        sedesActuales: _sedesActualesController.text.isEmpty ? null : int.tryParse(_sedesActualesController.text),
        operadorActual: _operadorActualController.text.isEmpty ? null : _operadorActualController.text,
        numLineasMoviles: _numLineasMovilesController.text.isEmpty ? null : int.tryParse(_numLineasMovilesController.text),
        centralita: _centralizaController.text.isEmpty ? null : _centralizaController.text,
        soloVoz: _soloVoz,
        numeroEmpleados: _numeroEmpleadosController.text.isEmpty ? null : int.tryParse(_numeroEmpleadosController.text),
        m2m: _m2m,
        fibrasActuales: _fibrasActuales,
        ciberseguridad: _ciberseguridad,
        registrosHorario: _registrosHorario,
        proveedorControlHorario: _proveedorControlHorarioController.text.isEmpty ? null : _proveedorControlHorarioController.text,
        numLicenciasControlHorario: _numLicenciasControlHorarioController.text.isEmpty ? null : int.tryParse(_numLicenciasControlHorarioController.text),
        fechaRenovacionControlHorario: _fechaRenovacionControlHorarioController.text.isEmpty ? null : _fechaRenovacionControlHorarioController.text,
        mantenimientoInformatico: _mantenimientoInformatico,
        proveedorCorreo: _proveedorCorreoController.text.isEmpty ? null : _proveedorCorreoController.text,
        licenciasOffice: _licenciasOfficeController.text.isEmpty ? null : int.tryParse(_licenciasOfficeController.text),
        fechaRenovacionOffice: _fechaRenovacionOfficeController.text.isEmpty ? null : _fechaRenovacionOfficeController.text,
        sedesNuevas: _sedesNuevasController.text.isEmpty ? null : int.tryParse(_sedesNuevasController.text),
        proveedorMantenimiento: _proveedorMantenimientoController.text.isEmpty ? null : _proveedorMantenimientoController.text,
        disponeNegocioDigital: _disponeNegocioDigital,
        admiteLlamadaNps: _admiteLlamadaNps,
      );

      await ApiService.submitForm(formSubmission);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formulario guardado correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
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
}