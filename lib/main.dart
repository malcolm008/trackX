import 'package:bustracker_007/presentation/features/admin/screens/live_map_screen.dart';
import 'package:bustracker_007/presentation/features/admin/screens/settings_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/live_map_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/settings_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:bustracker_007/presentation/features/auth/screens/login_screen.dart';
import 'package:bustracker_007/presentation/features/admin/auth/admin_login_screen.dart';
import 'package:bustracker_007/core/theme/app_theme.dart';
import 'package:bustracker_007/core/utils/platform_helper.dart';

void main() {
  runApp(const TrackX());
}

class TrackX extends StatelessWidget {
  const TrackX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: PlatformHelper.isAdminPanel
          ? const AdminLoginScreen() // Web/Desktop shows admin login
          : const LoginScreen(), // Mobile shows regular login
    );
  }
}