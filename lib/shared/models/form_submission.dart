import 'package:json_annotation/json_annotation.dart';

part 'form_submission.g.dart';

@JsonSerializable()
class FormSubmission {
  final int? id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'jefe_equipo_id')
  final int jefeEquipoId;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'location_address')
  final String? locationAddress;
  @JsonKey(name: 'direccion_real')
  final String? direccionReal;

  // Datos del cliente
  final String? cliente;
  final String? cif;
  final String? direccion;
  @JsonKey(name: 'persona_contacto')
  final String? personaContacto;
  @JsonKey(name: 'cargo_contacto')
  final String? cargoContacto;
  @JsonKey(name: 'contacto_es_decisor')
  final String? contactoEsDecisor;
  @JsonKey(name: 'telefono_contacto')
  final String? telefonoContacto;
  @JsonKey(name: 'email_contacto')
  final String? emailContacto;

  // Datos comerciales
  @JsonKey(name: 'fin_permanencia')
  final String? finPermanencia;
  @JsonKey(name: 'sedes_actuales')
  final int? sedesActuales;
  @JsonKey(name: 'operador_actual')
  final String? operadorActual;
  @JsonKey(name: 'num_lineas_moviles')
  final int? numLineasMoviles;
  final String? centralita;
  @JsonKey(name: 'solo_voz')
  final String? soloVoz;
  final int? extensiones;
  final String? m2m;
  @JsonKey(name: 'fibras_actuales')
  final String? fibrasActuales;
  final String? ciberseguridad;
  @JsonKey(name: 'registros_horario')
  final String? registrosHorario;
  @JsonKey(name: 'proveedor_control_horario')
  final String? proveedorControlHorario;
  @JsonKey(name: 'num_licencias_control_horario')
  final int? numLicenciasControlHorario;
  @JsonKey(name: 'fecha_renovacion_control_horario')
  final String? fechaRenovacionControlHorario;
  @JsonKey(name: 'proveedor_correo')
  final String? proveedorCorreo;
  @JsonKey(name: 'licencias_office')
  final int? licenciasOffice;
  @JsonKey(name: 'fecha_renovacion_office')
  final String? fechaRenovacionOffice;
  @JsonKey(name: 'mantenimiento_informatico')
  final String? mantenimientoInformatico;
  @JsonKey(name: 'numero_empleados')
  final int? numeroEmpleados;

  // Campos específicos para FIDELIZACIÓN
  @JsonKey(name: 'sedes_nuevas')
  final int? sedesNuevas;
  @JsonKey(name: 'num_lineas_moviles_nuevas')
  final int? numLineasMovilesNuevas;
  @JsonKey(name: 'proveedor_mantenimiento')
  final String? proveedorMantenimiento;
  @JsonKey(name: 'dispone_negocio_digital')
  final String? disponeNegocioDigital;
  @JsonKey(name: 'admite_llamada_nps')
  final String? admiteLlamadaNps;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const FormSubmission({
    this.id,
    required this.userId,
    required this.jefeEquipoId,
    this.latitude,
    this.longitude,
    this.locationAddress,
    this.direccionReal,
    this.cliente,
    this.cif,
    this.direccion,
    this.personaContacto,
    this.cargoContacto,
    this.contactoEsDecisor,
    this.telefonoContacto,
    this.emailContacto,
    this.finPermanencia,
    this.sedesActuales,
    this.operadorActual,
    this.numLineasMoviles,
    this.centralita,
    this.soloVoz,
    this.extensiones,
    this.m2m,
    this.fibrasActuales,
    this.ciberseguridad,
    this.registrosHorario,
    this.proveedorControlHorario,
    this.numLicenciasControlHorario,
    this.fechaRenovacionControlHorario,
    this.proveedorCorreo,
    this.licenciasOffice,
    this.fechaRenovacionOffice,
    this.mantenimientoInformatico,
    this.numeroEmpleados,
    this.sedesNuevas,
    this.numLineasMovilesNuevas,
    this.proveedorMantenimiento,
    this.disponeNegocioDigital,
    this.admiteLlamadaNps,
    this.createdAt,
    this.updatedAt,
  });

  factory FormSubmission.fromJson(Map<String, dynamic> json) => _$FormSubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$FormSubmissionToJson(this);
}

@JsonSerializable()
class ClientSearchResult {
  final int id;
  final String cliente;
  final String cif;
  final String direccion;
  final String personaContacto;
  final String telefonoContacto;
  final String emailContacto;
  final DateTime createdAt;

  const ClientSearchResult({
    required this.id,
    required this.cliente,
    required this.cif,
    required this.direccion,
    required this.personaContacto,
    required this.telefonoContacto,
    required this.emailContacto,
    required this.createdAt,
  });

  factory ClientSearchResult.fromJson(Map<String, dynamic> json) => _$ClientSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$ClientSearchResultToJson(this);
}