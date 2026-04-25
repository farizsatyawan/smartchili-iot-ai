import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 NEW

import 'config/theme.dart';
import 'config/routes.dart';

import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/sensor_provider.dart';
import 'presentation/providers/scan_provider.dart';
import 'presentation/providers/auth_provider.dart';

import 'presentation/widgets/main_shell.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/input_kebun_screen.dart'; // 🔥 NEW

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SmartChiliFarmApp());
}

class SmartChiliFarmApp extends StatelessWidget {
  const SmartChiliFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'SmartChili Farm',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            onGenerateRoute: AppRoutes.generateRoute,

            // 🔐 Auth Gate
            home: const AuthChecker(),
          );
        },
      ),
    );
  }
}

/// 🔐 AUTH CHECKER (UPDATED 🔥)
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 🔄 Loading auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Belum login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // ✅ Sudah login → cek Firestore
        final user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snap) {

            // 🔄 Loading Firestore
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 🔥 USER BARU (belum ada alamat kebun)
            if (!snap.hasData || !snap.data!.exists) {
              return const InputKebunScreen();
            }

            // 🔥 USER SUDAH LENGKAP
            return const MainShell();
          },
        );
      },
    );
  }
}