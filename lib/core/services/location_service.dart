import 'package:geolocator/geolocator.dart';
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
}