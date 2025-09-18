// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Helper function to parse latitude/longitude that can come as String or num
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      print('Error parsing coordinate: $value');
      return null;
    }
  }
  return null;
}

FormSubmission _$FormSubmissionFromJson(Map<String, dynamic> json) =>
    FormSubmission(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      jefeEquipoId: json['jefe_equipo_id'] as int,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      locationAddress: json['location_address'] as String?,
      direccionReal: json['direccion_real'] as String?,
      cliente: json['cliente'] as String?,
      cif: json['cif'] as String?,
      direccion: json['direccion'] as String?,
      personaContacto: json['persona_contacto'] as String?,
      cargoContacto: json['cargo_contacto'] as String?,
      contactoEsDecisor: json['contacto_es_decisor'] as String?,
      telefonoContacto: json['telefono_contacto'] as String?,
      emailContacto: json['email_contacto'] as String?,
      finPermanencia: json['fin_permanencia'] as String?,
      sedesActuales: json['sedes_actuales'] as int?,
      operadorActual: json['operador_actual'] as String?,
      numLineasMoviles: json['num_lineas_moviles'] as int?,
      centralita: json['centralita'] as String?,
      soloVoz: json['solo_voz'] as String?,
      extensiones: json['extensiones'] as int?,
      m2m: json['m2m'] as String?,
      fibrasActuales: json['fibras_actuales'] as String?,
      ciberseguridad: json['ciberseguridad'] as String?,
      registrosHorario: json['registros_horario'] as String?,
      proveedorControlHorario: json['proveedor_control_horario'] as String?,
      numLicenciasControlHorario: json['num_licencias_control_horario'] as int?,
      fechaRenovacionControlHorario: json['fecha_renovacion_control_horario'] as String?,
      proveedorCorreo: json['proveedor_correo'] as String?,
      licenciasOffice: json['licencias_office'] is String ? int.tryParse(json['licencias_office']) : json['licencias_office'] as int?,
      fechaRenovacionOffice: json['fecha_renovacion_office'] as String?,
      mantenimientoInformatico: json['mantenimiento_informatico'] as String?,
      numeroEmpleados: json['numero_empleados'] as int?,
      sedesNuevas: json['sedes_nuevas'] as int?,
      numLineasMovilesNuevas: json['num_lineas_moviles_nuevas'] as int?,
      proveedorMantenimiento: json['proveedor_mantenimiento'] as String?,
      disponeNegocioDigital: json['dispone_negocio_digital'] as String?,
      admiteLlamadaNps: json['admite_llamada_nps'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FormSubmissionToJson(FormSubmission instance) {
  // Convertir boolean a SI/NO para la API
  String boolToString(String? value) {
    if (value == null) return 'NO';
    return value == 'SI' ? 'SI' : 'NO';
  }

  return <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'jefe_equipo_id': instance.jefeEquipoId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'location_address': instance.locationAddress,
    'direccion_real': instance.direccionReal,
    'cliente': instance.cliente,
    'cif': instance.cif,
    'direccion': instance.direccion,
    'persona_contacto': instance.personaContacto,
    'cargo_contacto': instance.cargoContacto,
    'contacto_es_decisor': boolToString(instance.contactoEsDecisor),
    'telefono_contacto': instance.telefonoContacto,
    'email_contacto': instance.emailContacto,
    'fin_permanencia': instance.finPermanencia,
    'sedes_actuales': instance.sedesActuales,
    'operador_actual': instance.operadorActual,
    'num_lineas_moviles': instance.numLineasMoviles,
    'centralita': instance.centralita,
    'solo_voz': boolToString(instance.soloVoz),
    'extensiones': instance.extensiones,
    'm2m': boolToString(instance.m2m),
    'fibras_actuales': boolToString(instance.fibrasActuales),
    'ciberseguridad': boolToString(instance.ciberseguridad),
    'registros_horario': boolToString(instance.registrosHorario),
    'proveedor_control_horario': instance.proveedorControlHorario,
    'num_licencias_control_horario': instance.numLicenciasControlHorario,
    'fecha_renovacion_control_horario': instance.fechaRenovacionControlHorario,
    'proveedor_correo': instance.proveedorCorreo,
    'licencias_office': instance.licenciasOffice,
    'fecha_renovacion_office': instance.fechaRenovacionOffice,
    'mantenimiento_informatico': boolToString(instance.mantenimientoInformatico),
    'numero_empleados': instance.numeroEmpleados,
    'sedes_nuevas': instance.sedesNuevas,
    'num_lineas_moviles_nuevas': instance.numLineasMovilesNuevas,
    'proveedor_mantenimiento': instance.proveedorMantenimiento,
    'dispone_negocio_digital': boolToString(instance.disponeNegocioDigital),
    'admite_llamada_nps': boolToString(instance.admiteLlamadaNps),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
  };
}

ClientSearchResult _$ClientSearchResultFromJson(Map<String, dynamic> json) =>
    ClientSearchResult(
      id: json['id'] as int,
      cliente: json['cliente'] as String,
      cif: json['cif'] as String,
      direccion: json['direccion'] as String,
      personaContacto: json['personaContacto'] as String,
      telefonoContacto: json['telefonoContacto'] as String,
      emailContacto: json['emailContacto'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ClientSearchResultToJson(ClientSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cliente': instance.cliente,
      'cif': instance.cif,
      'direccion': instance.direccion,
      'personaContacto': instance.personaContacto,
      'telefonoContacto': instance.telefonoContacto,
      'emailContacto': instance.emailContacto,
      'createdAt': instance.createdAt.toIso8601String(),
    };