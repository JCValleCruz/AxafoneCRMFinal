class JsonHelpers {
  // Convierte int/bool a bool (para campos de base de datos TINYINT)
  static bool parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  // Convierte diferentes formatos de fecha
  static DateTime parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    throw ArgumentError('Invalid date format: $value');
  }

  // Convierte nullable int
  static int? parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}