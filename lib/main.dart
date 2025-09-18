import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_theme.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/change_password_screen.dart';
import 'features/commercial/commercial_menu_screen.dart';
import 'features/jefe/jefe_menu_screen.dart';
import 'features/admin/admin_menu_screen.dart';
import 'features/forms/form_screen.dart';
import 'features/clients/search_client_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/admin/add_comercial_screen.dart';
import 'features/auth/test_login_screen.dart';

void main() {
  runApp(const AxafoneCRMApp());
}

class AxafoneCRMApp extends StatelessWidget {
  const AxafoneCRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'AxafoneCRM',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/comercial': (context) => const ComercialMenuScreen(),
            '/jefe': (context) => const JefeMenuScreen(),
            '/admin': (context) => const AdminMenuScreen(),
            '/search-client': (context) => const SearchClientScreen(),
            '/change-password': (context) => const ChangePasswordScreen(),
            '/reports': (context) => const ReportsScreen(),
            '/global-reports': (context) => const ReportsScreen(isGlobal: true),
            '/add-comercial': (context) => const AddComercialScreen(),
            '/test-setup': (context) => const TestLoginScreen(),
          },
          onGenerateRoute: (settings) {
            // Handle dynamic routes
            if (settings.name == '/form') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => FormScreen(
                  isEditMode: args?['isEditMode'] ?? false,
                  clientId: args?['clientId'],
                  tipoInforme: args?['tipoInforme'],
                ),
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
