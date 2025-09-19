import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

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

  /// Convierte coordenadas en una dirección legible usando geocoding reverso
  static Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      print('🗺️ Obteniendo dirección para: lat=$latitude, lng=$longitude');

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

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

        final address = parts.isNotEmpty ? parts.join(', ') : 'Ubicación desconocida';
        print('✅ Dirección obtenida: $address');
        return address;
      }

      print('❌ No se encontraron placemarks');
      return null;
    } catch (e) {
      print('❌ Error en geocoding reverso: $e');
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