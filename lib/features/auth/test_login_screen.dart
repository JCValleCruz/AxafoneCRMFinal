import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/app_colors.dart';

class TestLoginScreen extends StatefulWidget {
  const TestLoginScreen({super.key});

  @override
  State<TestLoginScreen> createState() => _TestLoginScreenState();
}

class _TestLoginScreenState extends State<TestLoginScreen> {
  bool _isCreatingUser = false;
  String? _message;

  Future<void> _createTestUser() async {
    setState(() {
      _isCreatingUser = true;
      _message = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://axafonecrm.vercel.app/api/create-test-user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      final data = jsonDecode(response.body);
      print('Create user response: $data');

      setState(() {
        if (data['success']) {
          _message = 'Usuario de prueba creado correctamente:\nEmail: nchat@axafone.com\nPassword: pass123';
        } else {
          _message = 'Error: ${data['message'] ?? 'Error desconocido'}';
        }
      });
    } catch (e) {
      setState(() {
        _message = 'Error de conexión: $e';
      });
    } finally {
      setState(() {
        _isCreatingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Test de Configuración'),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configuración Inicial',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crear Usuario de Prueba',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esto creará un usuario administrador para probar el login:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Email: nchat@axafone.com\n• Password: pass123\n• Rol: ADMINISTRADOR',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isCreatingUser ? null : _createTestUser,
                      child: _isCreatingUser
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Crear Usuario de Prueba'),
                    ),
                  ],
                ),
              ),
            ),

            if (_message != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _message!.contains('Error')
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _message!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _message!.contains('Error')
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                ),
              ),
            ],

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Ir al Login'),
            ),
          ],
        ),
      ),
    );
  }
}