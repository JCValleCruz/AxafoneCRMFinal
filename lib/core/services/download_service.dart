import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'dart:html' as html;

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

  static String _cleanString(dynamic value) {
    if (value == null) return '';
    String str = value.toString();
    // Remover caracteres problemáticos
    str = str.replaceAll(RegExp(r'[\n\r\t\u0000-\u001F\u007F-\u009F]'), ' ');
    // Limitar longitud para evitar problemas
    if (str.length > 255) {
      str = str.substring(0, 255);
    }
    return str.trim();
  }

  static void downloadXLSX({
    required Map<String, dynamic> data,
    required String filename,
  }) {
    try {
      print('DEBUG DownloadService: Creando reporte completo');

      final excel = Excel.createExcel();
      final sheet = excel['Reporte'];

      // Eliminar la hoja por defecto si existe
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }

      int currentRow = 0;

      // Procesar formularios directamente desde la fila 1
      if (data['data'] != null && data['data'] is List) {
        final formularios = data['data'] as List;
        print('DEBUG DownloadService: Procesando ${formularios.length} formularios');

        if (formularios.isNotEmpty) {
          // Headers de columnas en la fila 1
          final headers = [
            'Cliente', 'CIF', 'Dirección', 'Persona de Contacto', 'Cargo del Contacto',
            '¿Es Decisor?', 'Teléfono de Contacto', 'Email de Contacto', 'Comercial',
            'Tipo de Comercial', 'Fecha de Envío', 'Fin de Permanencia', 'Sedes Actuales',
            'Operador Actual', 'Líneas Móviles', 'Centralita', 'Solo Voz', 'Extensiones',
            'M2M', 'Fibras Actuales', 'Ciberseguridad', 'Registro de Horario',
            'Proveedor Control Horario', 'Licencias Control Horario', 'Fecha Renovación Control Horario',
            'Proveedor Correo', 'Licencias Office', 'Fecha Renovación Office',
            'Mantenimiento Informático', 'Número de Empleados'
          ];

          // Aplicar formato a la primera fila (headers)
          for (int i = 0; i < headers.length && i < 26; i++) {
            final cell = sheet.cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}${currentRow + 1}'));
            cell.value = TextCellValue(headers[i]);

            // Aplicar formato de color a la primera fila
            cell.cellStyle = CellStyle(
              backgroundColorHex: ExcelColor.blue,
              fontColorHex: ExcelColor.white,
              bold: true,
            );
          }
          currentRow += 1;

          // Datos de formularios
          for (final form in formularios) {
            final row = [
              _cleanString(form['cliente']),
              _cleanString(form['cif']),
              _cleanString(form['direccion']),
              _cleanString(form['persona_contacto']),
              _cleanString(form['cargo_contacto']),
              _cleanString(form['contacto_es_decisor']),
              _cleanString(form['telefono_contacto']),
              _cleanString(form['email_contacto']),
              _cleanString(form['comercial_name']),
              _cleanString(form['comercial_tipo']),
              _formatDate(form['created_at']),
              _cleanString(form['fin_permanencia']),
              _cleanString(form['sedes_actuales']),
              _cleanString(form['operador_actual']),
              _cleanString(form['num_lineas_moviles']),
              _cleanString(form['centralita']),
              _cleanString(form['solo_voz']),
              _cleanString(form['extensiones']),
              _cleanString(form['m2m']),
              _cleanString(form['fibras_actuales']),
              _cleanString(form['ciberseguridad']),
              _cleanString(form['registros_horario']),
              _cleanString(form['proveedor_control_horario']),
              _cleanString(form['num_licencias_control_horario']),
              _formatDate(form['fecha_renovacion_control_horario']),
              _cleanString(form['proveedor_correo']),
              _cleanString(form['licencias_office']),
              _formatDate(form['fecha_renovacion_office']),
              _cleanString(form['mantenimiento_informatico']),
              _cleanString(form['numero_empleados'])
            ];

            for (int i = 0; i < row.length && i < 26; i++) {
              final cellValue = row[i].isEmpty ? '--' : row[i];
              sheet.cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}${currentRow + 1}')).value = TextCellValue(cellValue);
            }
            currentRow += 1;
          }
        }
      }

      print('DEBUG DownloadService: Codificando Excel completo...');
      final excelBytes = excel.encode();
      if (excelBytes != null) {
        print('DEBUG DownloadService: Excel codificado, tamaño: ${excelBytes.length} bytes');
        _downloadBytes(Uint8List.fromList(excelBytes), filename, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        print('DEBUG DownloadService: Descarga completada exitosamente');
      } else {
        throw Exception('Error al codificar el archivo Excel');
      }
    } catch (e) {
      print('DEBUG DownloadService: Error creating XLSX: $e');
      rethrow;
    }
  }

  static String _formatDate(dynamic dateValue) {
    if (dateValue == null || dateValue == '') return '';

    try {
      DateTime date;
      if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        date = dateValue;
      } else {
        return dateValue.toString();
      }

      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateValue.toString();
    }
  }

  static void _downloadText(String content, String filename, String mimeType) {
    if (kIsWeb) {
      final blob = html.Blob([content], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop implementation - show a message for now
      if (kDebugMode) {
        print('Download functionality not implemented for mobile platforms');
        print('Filename: $filename');
        print('Content length: ${content.length} characters');
      }
    }
  }

  static void _downloadBytes(Uint8List bytes, String filename, String mimeType) {
    print('DEBUG DownloadService: _downloadBytes iniciado');
    print('DEBUG DownloadService: kIsWeb = $kIsWeb');
    print('DEBUG DownloadService: filename = $filename');
    print('DEBUG DownloadService: bytes.length = ${bytes.length}');
    print('DEBUG DownloadService: mimeType = $mimeType');

    if (kIsWeb) {
      try {
        print('DEBUG DownloadService: Creando blob');
        final blob = html.Blob([bytes], mimeType);
        print('DEBUG DownloadService: Blob creado');

        final url = html.Url.createObjectUrlFromBlob(blob);
        print('DEBUG DownloadService: URL creada: $url');

        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', filename);
        print('DEBUG DownloadService: Anchor element creado, realizando click');

        anchor.click();
        print('DEBUG DownloadService: Click realizado');

        html.Url.revokeObjectUrl(url);
        print('DEBUG DownloadService: URL revocada');
      } catch (e) {
        print('DEBUG DownloadService: Error en descarga web: $e');
        rethrow;
      }
    } else {
      // Mobile/Desktop implementation - show a message for now
      print('DEBUG DownloadService: Plataforma no web detectada');
      if (kDebugMode) {
        print('Download XLSX functionality not implemented for mobile platforms');
        print('Filename: $filename');
        print('File size: ${bytes.length} bytes');
      }
    }
  }
}