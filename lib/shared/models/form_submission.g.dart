// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormSubmission _$FormSubmissionFromJson(Map<String, dynamic> json) =>
    FormSubmission(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      jefeEquipoId: (json['jefe_equipo_id'] as num).toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
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
      sedesActuales: (json['sedes_actuales'] as num?)?.toInt(),
      operadorActual: json['operador_actual'] as String?,
      numLineasMoviles: (json['num_lineas_moviles'] as num?)?.toInt(),
      centralita: json['centralita'] as String?,
      soloVoz: json['solo_voz'] as String?,
      extensiones: (json['extensiones'] as num?)?.toInt(),
      m2m: json['m2m'] as String?,
      fibrasActuales: json['fibras_actuales'] as String?,
      ciberseguridad: json['ciberseguridad'] as String?,
      registrosHorario: json['registros_horario'] as String?,
      proveedorControlHorario: json['proveedor_control_horario'] as String?,
      numLicenciasControlHorario:
          (json['num_licencias_control_horario'] as num?)?.toInt(),
      fechaRenovacionControlHorario:
          json['fecha_renovacion_control_horario'] as String?,
      proveedorCorreo: json['proveedor_correo'] as String?,
      licenciasOffice: (json['licencias_office'] as num?)?.toInt(),
      fechaRenovacionOffice: json['fecha_renovacion_office'] as String?,
      mantenimientoInformatico: json['mantenimiento_informatico'] as String?,
      numeroEmpleados: (json['numero_empleados'] as num?)?.toInt(),
      sedesNuevas: (json['sedes_nuevas'] as num?)?.toInt(),
      numLineasMovilesNuevas: (json['num_lineas_moviles_nuevas'] as num?)
          ?.toInt(),
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

Map<String, dynamic> _$FormSubmissionToJson(
  FormSubmission instance,
) => <String, dynamic>{
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
  'contacto_es_decisor': instance.contactoEsDecisor,
  'telefono_contacto': instance.telefonoContacto,
  'email_contacto': instance.emailContacto,
  'fin_permanencia': instance.finPermanencia,
  'sedes_actuales': instance.sedesActuales,
  'operador_actual': instance.operadorActual,
  'num_lineas_moviles': instance.numLineasMoviles,
  'centralita': instance.centralita,
  'solo_voz': instance.soloVoz,
  'extensiones': instance.extensiones,
  'm2m': instance.m2m,
  'fibras_actuales': instance.fibrasActuales,
  'ciberseguridad': instance.ciberseguridad,
  'registros_horario': instance.registrosHorario,
  'proveedor_control_horario': instance.proveedorControlHorario,
  'num_licencias_control_horario': instance.numLicenciasControlHorario,
  'fecha_renovacion_control_horario': instance.fechaRenovacionControlHorario,
  'proveedor_correo': instance.proveedorCorreo,
  'licencias_office': instance.licenciasOffice,
  'fecha_renovacion_office': instance.fechaRenovacionOffice,
  'mantenimiento_informatico': instance.mantenimientoInformatico,
  'numero_empleados': instance.numeroEmpleados,
  'sedes_nuevas': instance.sedesNuevas,
  'num_lineas_moviles_nuevas': instance.numLineasMovilesNuevas,
  'proveedor_mantenimiento': instance.proveedorMantenimiento,
  'dispone_negocio_digital': instance.disponeNegocioDigital,
  'admite_llamada_nps': instance.admiteLlamadaNps,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

ClientSearchResult _$ClientSearchResultFromJson(Map<String, dynamic> json) =>
    ClientSearchResult(
      id: (json['id'] as num).toInt(),
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
