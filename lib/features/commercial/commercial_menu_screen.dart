import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../shared/widgets/menu_card.dart';

class ComercialMenuScreen extends StatelessWidget {
  const ComercialMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionService.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surface,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header moderno
              _buildModernHeader(context, user?.name ?? 'Usuario'),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Menu Options
                      _buildMenuOptions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.accentDark,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              // Logout button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _logout(context),
                  tooltip: 'Cerrar Sesión',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Hola,',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            userName,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Text(
              'COMERCIAL',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    final user = SessionService.currentUser;
    final isFidelizacion = user?.isFidelizacion ?? false;

    return Column(
      children: [
        // Si es FIDELIZACIÓN, mostrar dos opciones de informes
        if (isFidelizacion) ...[
          MenuCard(
            title: 'Rellenar Informe Captación',
            subtitle: 'Crear informe de captación de cliente',
            icon: Icons.person_add_outlined,
            onTap: () => Navigator.of(context).pushNamed('/form', arguments: {'tipoInforme': 'CAPTACIÓN'}),
          ),
          const SizedBox(height: 16),
          MenuCard(
            title: 'Rellenar Informe Fidelización',
            subtitle: 'Crear informe de fidelización de cliente',
            icon: Icons.loyalty_outlined,
            onTap: () => Navigator.of(context).pushNamed('/form', arguments: {'tipoInforme': 'FIDELIZACIÓN'}),
          ),
        ] else ...[
          // Si es CAPTACIÓN, mostrar solo una opción
          MenuCard(
            title: 'Rellenar Informe',
            subtitle: 'Crear nuevo informe de cliente',
            icon: Icons.description_outlined,
            onTap: () => Navigator.of(context).pushNamed('/form'),
          ),
        ],
        const SizedBox(height: 16),
        MenuCard(
          title: 'Buscar Cliente',
          subtitle: 'Buscar y editar información de clientes',
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