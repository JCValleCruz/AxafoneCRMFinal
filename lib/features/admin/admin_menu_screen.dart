import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../shared/widgets/menu_card.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Panel de Administración'),
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

            // Admin Operations Section
            _buildSectionTitle(context, 'Operaciones de Administración'),
            const SizedBox(height: 16),
            _buildAdminOptions(context),

            const SizedBox(height: 32),

            // User Management Section
            _buildSectionTitle(context, 'Gestión de Usuarios'),
            const SizedBox(height: 16),
            _buildUserManagementOptions(context),

            const SizedBox(height: 32),

            // Reports Section
            _buildSectionTitle(context, 'Reportes y Análisis'),
            const SizedBox(height: 16),
            _buildReportsOptions(context),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.accent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrador',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Acceso completo al sistema',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildAdminOptions(BuildContext context) {
    return Column(
      children: [
        MenuCard(
          title: 'Buscar Cliente',
          subtitle: 'Buscar y editar información de cualquier cliente',
          icon: Icons.search_outlined,
          onTap: () => Navigator.of(context).pushNamed('/search-client'),
        ),
        const SizedBox(height: 16),
        MenuCard(
          title: 'Cambiar Contraseña',
          subtitle: 'Actualizar su contraseña de acceso',
          icon: Icons.lock_outline,
          onTap: () => Navigator.of(context).pushNamed('/change-password'),
        ),
      ],
    );
  }

  Widget _buildUserManagementOptions(BuildContext context) {
    return Column(
      children: [
        MenuCard(
          title: 'Agregar Jefe de Equipo',
          subtitle: 'Crear nuevo jefe de equipo en el sistema',
          icon: Icons.supervisor_account_outlined,
          accentColor: AppColors.accent,
          onTap: () => Navigator.of(context).pushNamed('/add-jefe-equipo'),
        ),
        const SizedBox(height: 16),
        MenuCard(
          title: 'Agregar Comercial',
          subtitle: 'Añadir nuevo comercial a cualquier equipo',
          icon: Icons.person_add_outlined,
          accentColor: AppColors.success,
          onTap: () => Navigator.of(context).pushNamed('/add-comercial'),
        ),
      ],
    );
  }

  Widget _buildReportsOptions(BuildContext context) {
    return Column(
      children: [
        MenuCard(
          title: 'Informes Globales',
          subtitle: 'Descargar reportes de todos los equipos',
          icon: Icons.download_outlined,
          accentColor: AppColors.warning,
          onTap: () => Navigator.of(context).pushNamed('/global-reports'),
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