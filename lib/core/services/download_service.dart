import 'dart:convert';
import 'package:flutter/foundation.dart';

class DownloadService {
  static void downloadCSV({
    required List<Map<String, dynamic>> data,
    required String filename,
  }) {
    if (data.isEmpty) return;

    // Crear encabezados CSV
    final headers = data.first.keys.toList();
    final csvContent = StringBuffer();

    // Agregar encabezados
    csvContent.writeln(headers.map((h) => '"$h"').join(','));

    // Agregar filas de datos
    for (final row in data) {
      final values = headers.map((header) {
        final value = row[header]?.toString() ?? '';
        // Escapar comillas dobles
        final escapedValue = value.replaceAll('"', '""');
        return '"$escapedValue"';
      }).join(',');
      csvContent.writeln(values);
    }

    _downloadText(csvContent.toString(), filename, 'text/csv');
  }

  static void downloadJSON({
    required Map<String, dynamic> data,
    required String filename,
  }) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    _downloadText(jsonString, filename, 'application/json');
  }

  static void _downloadText(String content, String filename, String mimeType) {
    // Mobile/Desktop implementation - show a message for now
    if (kDebugMode) {
      print('Download functionality not implemented for mobile platforms');
      print('Filename: $filename');
      print('Content length: ${content.length} characters');
    }
  }
}