import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../shared/models/user.dart';
import '../../shared/models/form_submission.dart';
import 'session_service.dart';

class ApiService {
  static const String baseUrl = 'https://axafonecrm.vercel.app/api';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Authentication
  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        return LoginResponse(
          success: false,
          error: data['error'] ?? 'Error de autenticación',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        error: 'Error de conexión: $e',
      );
    }
  }

  // Users
  static Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<User>> getTeamMembers(int bossId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$bossId/team'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener equipo');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
    String? tipo,
    int? bossId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'role': role,
          'tipo': tipo,
          'bossId': bossId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al crear usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/password'),
        headers: _headers,
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Error al cambiar contraseña');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Forms
  static Future<Map<String, dynamic>> submitForm(FormSubmission form) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forms'),
        headers: _headers,
        body: jsonEncode(form.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al enviar formulario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<ClientSearchResult>> searchClients({
    String? cif,
    String? companyName,
  }) async {
    try {
      final queryParams = <String, String>{};

      // Si hay CIF, usar búsqueda por CIF
      if (cif != null && cif.isNotEmpty) {
        queryParams['cif'] = cif;
      }

      // Si hay nombre de empresa, usar búsqueda general
      if (companyName != null && companyName.isNotEmpty) {
        queryParams['search'] = companyName;
      }

      // Agregar requesterId para obtener datos completos si el usuario está autenticado
      final currentUser = SessionService.currentUser;
      if (currentUser != null) {
        queryParams['requesterId'] = currentUser.id.toString();
      }

      final uri = Uri.parse('$baseUrl/forms').replace(
        queryParameters: queryParams,
      );

      print('Realizando búsqueda en: $uri');

      final response = await http.get(uri, headers: _headers);

      print('Status code: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Número de resultados: ${data.length}');

        final results = <ClientSearchResult>[];
        for (int i = 0; i < data.length; i++) {
          try {
            final result = _convertToClientSearchResult(data[i]);
            results.add(result);
          } catch (e) {
            print('Error procesando item $i: $e');
            print('Item problemático: ${data[i]}');
            // Continuar con el siguiente item en lugar de fallar todo
          }
        }
        print('Resultados procesados exitosamente: ${results.length}');
        return results;
      } else {
        throw Exception('Error en la búsqueda: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error completo en searchClients: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Helper para convertir la respuesta de la API al modelo ClientSearchResult
  static ClientSearchResult _convertToClientSearchResult(Map<String, dynamic> json) {
    // Debug: imprimir la estructura JSON recibida
    print('JSON recibido del servidor: $json');

    // Filtrar campos problemáticos de ubicación si existen
    final filteredJson = Map<String, dynamic>.from(json);
    filteredJson.removeWhere((key, value) =>
      key == 'latitude' ||
      key == 'longitude' ||
      key == 'location_address' ||
      key == 'direccion_real'
    );

    return ClientSearchResult(
      id: filteredJson['id'] as int,
      cliente: filteredJson['cliente'] ?? filteredJson['razonSocial'] ?? '',
      cif: filteredJson['cif'] ?? '',
      direccion: filteredJson['direccion'] ?? '',
      personaContacto: filteredJson['persona_contacto'] ?? '',
      telefonoContacto: filteredJson['telefono_contacto'] ?? filteredJson['telefono'] ?? '',
      emailContacto: filteredJson['email_contacto'] ?? filteredJson['email'] ?? '',
      createdAt: filteredJson['created_at'] != null
        ? DateTime.parse(filteredJson['created_at'])
        : DateTime.now(),
    );
  }

  static Future<FormSubmission> getFormById(String formId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forms/$formId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('API response JSON antes de limpiar: $jsonData');

        // LIMPIAR DATOS PROBLEMÁTICOS INMEDIATAMENTE
        final cleanedData = _cleanLocationData(jsonData);
        print('API response JSON después de limpiar: $cleanedData');

        final formSubmission = FormSubmission.fromJson(cleanedData);
        print('Parsed FormSubmission - cliente: ${formSubmission.cliente}, cif: ${formSubmission.cif}');
        return formSubmission;
      } else {
        throw Exception('Error al obtener formulario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error completo en getFormById: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Helper para limpiar datos de ubicación problemáticos
  static Map<String, dynamic> _cleanLocationData(Map<String, dynamic> data) {
    final cleaned = Map<String, dynamic>.from(data);

    // En WEB, limpiar TODOS los campos de ubicación para evitar problemas
    if (kIsWeb) {
      print('🌐 PLATAFORMA WEB: Limpiando TODOS los campos de ubicación');
      const webLocationFields = [
        'latitude',
        'longitude',
        'location_address',
        'direccion_real'
      ];

      for (final field in webLocationFields) {
        if (cleaned[field] != null) {
          print('🧹 Removiendo $field en web: ${cleaned[field]}');
          cleaned[field] = null;
        }
      }
    } else {
      // En MÓVIL, solo limpiar valores específicamente problemáticos
      print('📱 PLATAFORMA MÓVIL: Limpieza selectiva de campos de ubicación');
      const locationFields = [
        'latitude',
        'longitude',
        'location_address',
        'direccion_real'
      ];

      for (final field in locationFields) {
        if (cleaned[field] != null) {
          final value = cleaned[field].toString();
          print('Verificando campo $field: $value');

          // Limpiar valores problemáticos específicos
          if (value.contains('33.00000000') ||
              value.contains('Lat:') ||
              value.contains('Lng:') ||
              value == '33.0' ||
              value == '33') {
            print('Removiendo $field problemático: $value');
            cleaned[field] = null;
          }
        }
      }
    }

    return cleaned;
  }

  // Reports
  static Future<Map<String, dynamic>> getReports({
    int? jefeEquipoId,
    int? comercialId,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (jefeEquipoId != null) queryParams['jefeEquipoId'] = jefeEquipoId.toString();
      if (comercialId != null) queryParams['comercialId'] = comercialId.toString();
      if (fechaInicio != null) queryParams['fechaInicio'] = fechaInicio;
      if (fechaFin != null) queryParams['fechaFin'] = fechaFin;

      final uri = Uri.parse('$baseUrl/reports').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener reportes');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}