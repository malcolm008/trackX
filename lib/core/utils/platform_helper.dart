import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class PlatformHelper {
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isDesktop => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  static bool get isWeb => kIsWeb;

  static bool get isAdminPanel => isWeb || isDesktop;

  static bool get isMobileApp => isMobile;

  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}