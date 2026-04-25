import 'package:flutter/material.dart';
import '../presentation/widgets/main_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String scan = '/scan';
  static const String edukasi = '/edukasi';
  static const String profil = '/profil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainShell());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }
}