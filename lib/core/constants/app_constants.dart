import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'TrackX';
  static const String appVersion = '1.0.0';

  static const String baseUrl = 'https://api.trackX.com';
  static const int apiTimeout = 30000;

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String schoolKey = 'school_data';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';

  static const double defaultMapZoom = 15.0;
  static const int lacationUpdateInterval = 10000;
  static const int notificationDuration = 5;

  static const int minPasswordLength = 10;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  static const int maxEmailLength = 100;

  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  static const String defaultCountryCode = '+255';
  static const String defaultCurrency = 'USD';
  static const String defaultLanguage = 'en';

  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double geofenceRadius = 100.0;

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String users = '/users';
  static const String profile = '/users/profile';
  static const String changePassword = '/users/change-password';

  static const String schools = '/schools';
  static const String schoolSubscription = '/schools/subscription';

  static const String buses = '/buses';
  static const String busStatus = '/buses/status';
  static const String busLocation = '/buses/location';

  static const String drivers = '/drivers';
  static const String driverAssign = '/drivers/assign';

  static const String routes = '/routes';
  static const String routeStops = '/routes/stops';
  static const String routeAssign = '/routes/assign';

  static const String students = '/students';
  static const String studentAssign = '/students/assign';
  static const String studentAttendance = '/students/attendance';

  static const String parents = '/parents';
  static const String parentStudents = '/parents/students';

  static const String attendance = '/attendance';
  static const String attendanceDaily = '/attendance/daily';
  static const String attendanceMark = '/attendace/mark';

  static const String reports = '/reports';
  static const String reportStatus = '/reports/status';

  static const String notifications = '/notifications';
  static const String notificationsRead = '/notifications/read';
  static const String notificationsSend = '/notifications/send';

  static const String locationUpdate = '/location/update';
  static const String locationHistory = '/location/history';
  static const String geofences = '/geofences';

  static const String analytics = '/analytics';
  static const String analyticsDaily = '/analytics/daily';
  static const String analyticsMonthly = '/analytics/monthly';

  static const String subscriptions = '/subscriptions';
  static const String subscriptionsRenew = '/subscriptions/renew';
  static const String subscriptionsCancel = '/subscriptions/cancel';
}

class AssetPaths {
  static const String images = 'assets/images/';
  static const String icons = 'assets/icons/';
  static const String animations = 'assets/animations/';
  static const String fonts = 'assets/fonts/';

  static const String logo = '${images}logo.png';
  static const String logoLight = '${images}logo_light.png';
  static const String logoDark = '${images}logo_dark.png';
  static const String placeholder = '${images}placeholder.png';
  static const String busDefault = '${images}bus_default.png';
  static const String driverDefault = '${images}driver_default.png';
  static const String studentDefault = '${images}student_default.png';
  static const String schoolDefault = '${images}school_default.png';
  static const String mapMarker = '${images}map_marker.png';
  static const String mapBus = '${images}map_bus.png';

  static const String icHome = '${icons}home.svg';
  static const String icBus = '${icons}bus.svg';
  static const String icRoute = '${icons}route.svg';
  static const String icStudent = '${icons}student.svg';
  static const String icDriver = '${icons}driver.svg';
  static const String icParent = '${icons}parent.svg';
  static const String icSchool = '${icons}school.svg';
  static const String icMap = '${icons}map.svg';
  static const String icNotification = '${icons}notification.svg';
  static const String icProfile = '${icons}profile.svg';
  static const String icSettings = '${icons}settings.svg';
  static const String icAnalytics = '${icons}analytics.svg';
  static const String icAttendance = '${icons}attendance.svg';
  static const String icReport = '${icons}report.svg';
  static const String icSubscription = '${icons}subscription.svg';
  static const String icLive = '${icons}live.svg';

  static const String animLoading = '${animations}loading.json';
  static const String animSuccess = '${animations}success.json';
  static const String animError = '${animations}error.json';
  static const String animEmpty = '${animations}empty.json';
  static const String animBus = '${animations}bus.json';
  static const String animLocation = '${animations}location.json';
}