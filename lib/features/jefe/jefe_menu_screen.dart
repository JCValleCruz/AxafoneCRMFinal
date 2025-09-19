import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../shared/widgets/menu_card.dart';

class JefeMenuScreen extends StatelessWidget {
  const JefeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Menú Jefe de Equipo'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, user?.name ?? 'Usuario'),

            const SizedBox(height: 32),

            // Menu Options
            _buildMenuOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido,',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Jefe de Equipo',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        // Search Client
        MenuCard(
          title: 'Buscar Cliente',
          subtitle: 'Buscar y editar información de clientes',
          icon: Icons.search_outlined,
          onTap: () => Navigator.of(context).pushNamed('/search-client'),
        ),
        const SizedBox(height: 16),

        // Download Reports
        MenuCard(
          title: 'Descargar Informes',
          subtitle: 'Generar y descargar reportes del equipo',
          icon: Icons.download_outlined,
          accentColor: AppColors.info,
          onTap: () => Navigator.of(context).pushNamed('/reports'),
        ),
        const SizedBox(height: 16),

        // Add Commercial
        MenuCard(
          title: 'Agregar Comercial',
          subtitle: 'Añadir nuevo comercial al equipo',
          icon: Icons.person_add_outlined,
          accentColor: AppColors.success,
          onTap: () => Navigator.of(context).pushNamed('/add-comercial'),
        ),
        const SizedBox(height: 16),


        // Change Password
        MenuCard(
          title: 'Cambiar Contraseña',
          subtitle: 'Actualizar su contraseña de acceso',
          icon: Icons.lock_outline,
          onTap: () => Navigator.of(context).pushNamed('/change-password'),
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro de que desea cerrar sesión?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await SessionService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}