import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<bool> requestLocationPermission() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      if (!await Geolocator.isLocationServiceEnabled()) {
        return false;
      }

      // Solicitar permisos
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Los permisos están denegados permanentemente, no podemos solicitar permisos
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  static String formatCoordinates(Position position) {
    return 'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
  }

  static Future<String?> getLocationString() async {
    final position = await getCurrentLocation();
    if (position != null) {
      return formatCoordinates(position);
    }
    return null;
  }

  /// Convierte coordenadas en una dirección legible usando OpenStreetMap (para web)
  static Future<String?> _getAddressFromOSM(double latitude, double longitude) async {
    try {
      print('🌐 Intentando geocoding con OpenStreetMap...');
      final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'AxafoneCRM-Flutter/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🗺️ Respuesta OSM: ${data}');

        if (data['display_name'] != null) {
          final displayName = data['display_name'] as String;
          print('✅ Dirección OSM obtenida: $displayName');

          // Simplificar la dirección para que sea más legible
          final parts = displayName.split(', ');
          if (parts.length >= 3) {
            // Tomar los primeros 3-4 elementos más relevantes
            final relevantParts = parts.take(4).toList();
            final simplifiedAddress = relevantParts.join(', ');
            print('✅ Dirección simplificada: $simplifiedAddress');
            return simplifiedAddress;
          }

          return displayName;
        }
      }

      print('❌ OSM no devolvió datos válidos');
      return null;
    } catch (e) {
      print('❌ Error en geocoding OSM: $e');
      return null;
    }
  }

  /// Convierte coordenadas en una dirección legible usando geocoding reverso
  static Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      print('🗺️ Obteniendo dirección para: lat=$latitude, lng=$longitude');

      // Primero intentar con geocoding nativo
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        print('📍 Placemarks encontrados: ${placemarks.length}');

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          print('🏷️ Placemark: ${placemark.toString()}');

          // Construir dirección legible
          final parts = <String>[];

          if (placemark.street != null && placemark.street!.isNotEmpty) {
            parts.add(placemark.street!);
          }
          if (placemark.subThoroughfare != null && placemark.subThoroughfare!.isNotEmpty) {
            parts.add(placemark.subThoroughfare!);
          }
          if (placemark.locality != null && placemark.locality!.isNotEmpty) {
            parts.add(placemark.locality!);
          }
          if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
            parts.add(placemark.administrativeArea!);
          }

          final address = parts.isNotEmpty ? parts.join(', ') : null;
          if (address != null && address.isNotEmpty) {
            print('✅ Dirección nativa obtenida: $address');
            return address;
          }
        }
      } catch (e) {
        print('⚠️ Geocoding nativo falló: $e, intentando con OSM...');
      }

      // Si el geocoding nativo falla, usar OpenStreetMap
      final osmAddress = await _getAddressFromOSM(latitude, longitude);
      if (osmAddress != null) {
        return osmAddress;
      }

      print('❌ Todos los métodos de geocoding fallaron');
      return null;
    } catch (e) {
      print('❌ Error general en geocoding: $e');
      return null;
    }
  }

  /// Obtiene la posición actual y la convierte a dirección legible
  static Future<String?> getCurrentAddress() async {
    try {
      final position = await getCurrentLocation();
      if (position != null) {
        return await getAddressFromCoordinates(position.latitude, position.longitude);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo dirección actual: $e');
      return null;
    }
  }
}