import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/bus_repository.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/route_repository.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/school_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../core/enums/app_enums.dart';
import '../../data/models/user/user_model.dart';
import '../../data/models/transport/bus_model.dart';
import '../../data/models/transport/route_model.dart';
import '../../data/models/student/student_model.dart';
import '../../data/models/report/report_model.dart';
import '../../data/models/school/school_model.dart';
import '../../data/models/location/location_model.dart';
import '../../data/models/notification/notification_model.dart';

// Repository Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return MockUserRepository();
});

final busRepositoryProvider = Provider<BusRepository>((ref) {
  return MockBusRepository();
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return MockStudentRepository();
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return MockAttendanceRepository();
});

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return MockRouteRepository();
});

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return MockDriverRepository();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return MockReportRepository();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository();
});

final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  return MockSchoolRepository();
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return MockSubscriptionRepository();
});

// User State Provider
final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(userRepositoryProvider),
    ref.read(currentUserProvider.notifier),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository _userRepository;
  final StateController<UserModel?> _currentUser;

  AuthNotifier(this._userRepository, this._currentUser)
      : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        _currentUser.state = user;
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.error('Invalid credentials');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();

    try {
      await _userRepository.logout();
      _currentUser.state = null;
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> updateProfile(UserModel user) async {
    state = AuthState.loading();

    try {
      final updatedUser = await _userRepository.updateProfile(user);
      _currentUser.state = updatedUser;
      state = AuthState.authenticated(updatedUser);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
    this.error,
  });

  factory AuthState.initial() => AuthState(
    isLoading: false,
    isAuthenticated: false,
  );

  factory AuthState.loading() => AuthState(
    isLoading: true,
    isAuthenticated: false,
  );

  factory AuthState.authenticated(UserModel user) => AuthState(
    isLoading: false,
    isAuthenticated: true,
    user: user,
  );

  factory AuthState.unauthenticated() => AuthState(
    isLoading: false,
    isAuthenticated: false,
  );

  factory AuthState.error(String error) => AuthState(
    isLoading: false,
    isAuthenticated: false,
    error: error,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AuthState &&
              runtimeType == other.runtimeType &&
              isLoading == other.isLoading &&
              isAuthenticated == other.isAuthenticated &&
              user == other.user &&
              error == other.error;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isAuthenticated.hashCode ^
      user.hashCode ^
      error.hashCode;
}

// Bus Providers
final busListProvider = FutureProvider.autoDispose.family<List<BusModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(busRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final busProvider = FutureProvider.autoDispose.family<BusModel?, String>((ref, busId) async {
  final repository = ref.watch(busRepositoryProvider);
  return await repository.getById(busId);
});

final activeBusesProvider = FutureProvider.autoDispose<List<BusModel>>((ref) async {
  final repository = ref.watch(busRepositoryProvider);
  return await repository.getActiveBuses();
});

final busStatusProvider = StateNotifierProvider.family<BusStatusNotifier, BusStatus?, String>((ref, busId) {
  return BusStatusNotifier(ref.read(busRepositoryProvider), busId);
});

class BusStatusNotifier extends StateNotifier<BusStatus?> {
  final BusRepository _repository;
  final String _busId;

  BusStatusNotifier(this._repository, this._busId) : super(null) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final bus = await _repository.getById(_busId);
    state = bus?.status;
  }

  Future<void> updateStatus(BusStatus status) async {
    await _repository.updateBusStatus(_busId, status);
    state = status;
  }
}

// Student Providers
final studentListProvider = FutureProvider.autoDispose.family<List<StudentModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(studentRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final studentProvider = FutureProvider.autoDispose.family<StudentModel?, String>((ref, studentId) async {
  final repository = ref.watch(studentRepositoryProvider);
  return await repository.getById(studentId);
});

final studentsByParentProvider = FutureProvider.autoDispose.family<List<StudentModel>, String>((ref, parentId) async {
  final repository = ref.watch(studentRepositoryProvider);
  return await repository.getStudentsByParent(parentId);
});

final studentsByRouteProvider = FutureProvider.autoDispose.family<List<StudentModel>, String>((ref, routeId) async {
  final repository = ref.watch(studentRepositoryProvider);
  return await repository.getStudentsByRoute(routeId);
});

// Route Providers
final routeListProvider = FutureProvider.autoDispose.family<List<RouteModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(routeRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final routeProvider = FutureProvider.autoDispose.family<RouteModel?, String>((ref, routeId) async {
  final repository = ref.watch(routeRepositoryProvider);
  return await repository.getById(routeId);
});

final activeRoutesProvider = FutureProvider.autoDispose<List<RouteModel>>((ref) async {
  final repository = ref.watch(routeRepositoryProvider);
  return await repository.getActiveRoutes();
});

final routeByDriverProvider = FutureProvider.autoDispose.family<RouteModel?, String>((ref, driverId) async {
  final repository = ref.watch(routeRepositoryProvider);
  return await repository.getRouteByDriver(driverId);
});

// Attendance Providers
final dailyAttendanceProvider = FutureProvider.autoDispose.family<List<AttendanceModel>, DateTime>((ref, date) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return await repository.getAttendanceByDate(date);
});

final studentAttendanceProvider = FutureProvider.autoDispose.family<List<AttendanceModel>, String>((ref, studentId) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return await repository.getAttendanceByStudent(studentId);
});

final dailySummaryProvider = FutureProvider.autoDispose.family<AttendanceSummary, (DateTime, String)>((ref, params) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  final (date, schoolId) = params;
  return await repository.getDailySummary(date, schoolId);
});

final todayAttendanceProvider = FutureProvider.autoDispose.family<AttendanceModel?, String>((ref, studentId) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return await repository.getTodayAttendance(studentId);
});

// Driver Providers
final driverListProvider = FutureProvider.autoDispose.family<List<DriverModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(driverRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final driverProvider = FutureProvider.autoDispose.family<DriverModel?, String>((ref, driverId) async {
  final repository = ref.watch(driverRepositoryProvider);
  return await repository.getById(driverId);
});

final availableDriversProvider = FutureProvider.autoDispose<List<DriverModel>>((ref) async {
  final repository = ref.watch(driverRepositoryProvider);
  return await repository.getAvailableDrivers();
});

final driverByUserProvider = FutureProvider.autoDispose.family<DriverModel?, String>((ref, userId) async {
  final repository = ref.watch(driverRepositoryProvider);
  return await repository.getDriverByUserId(userId);
});

// Report Providers
final reportListProvider = FutureProvider.autoDispose.family<List<ReportModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(reportRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final pendingReportsProvider = FutureProvider.autoDispose<List<ReportModel>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return await repository.getPendingReports();
});

final driverReportsProvider = FutureProvider.autoDispose.family<List<ReportModel>, String>((ref, driverId) async {
  final repository = ref.watch(reportRepositoryProvider);
  return await repository.getReportsByDriver(driverId);
});

// Location Providers
final busLocationProvider = StreamProvider.autoDispose.family<LocationModel?, String>((ref, busId) {
  final repository = ref.watch(locationRepositoryProvider);
  return repository.watchBusLocation(busId);
});

final currentLocationProvider = StateProvider<LocationModel?>((ref) => null);

final geofenceListProvider = FutureProvider.autoDispose.family<List<GeofenceModel>, String>((ref, schoolId) async {
  final repository = ref.watch(locationRepositoryProvider);
  return await repository.getGeofencesBySchool(schoolId);
});

// Notification Providers
final userNotificationsProvider = FutureProvider.autoDispose.family<List<NotificationModel>, String>((ref, userId) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getNotificationsByUser(userId);
});

final unreadNotificationsCountProvider = FutureProvider.autoDispose.family<int, String>((ref, userId) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getUnreadCount(userId);
});

// School Providers
final schoolListProvider = FutureProvider.autoDispose.family<List<SchoolModel>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(schoolRepositoryProvider);
  return await repository.getAll(filters: filters);
});

final schoolProvider = FutureProvider.autoDispose.family<SchoolModel?, String>((ref, schoolId) async {
  final repository = ref.watch(schoolRepositoryProvider);
  return await repository.getById(schoolId);
});

final activeSchoolsProvider = FutureProvider.autoDispose<List<SchoolModel>>((ref) async {
  final repository = ref.watch(schoolRepositoryProvider);
  return await repository.getActiveSchools();
});

// Subscription Providers
final subscriptionProvider = FutureProvider.autoDispose.family<SubscriptionModel?, String>((ref, schoolId) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.getActiveSubscription(schoolId);
});

final expiringSubscriptionsProvider = FutureProvider.autoDispose.family<List<SubscriptionModel>, int>((ref, days) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.getExpiringSubscriptions(days);
});

// Utility Providers
final loadingProvider = StateProvider<bool>((ref) => false);

final errorProvider = StateProvider<String?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected Item Providers (for UI state)
final selectedBusProvider = StateProvider<BusModel?>((ref) => null);
final selectedStudentProvider = StateProvider<StudentModel?>((ref) => null);
final selectedRouteProvider = StateProvider<RouteModel?>((ref) => null);
final selectedDriverProvider = StateProvider<DriverModel?>((ref) => null);
final selectedSchoolProvider = StateProvider<SchoolModel?>((ref) => null);

// Form State Providers
final busFormStateProvider = StateNotifierProvider<BusFormNotifier, BusModel?>((ref) {
  return BusFormNotifier();
});

class BusFormNotifier extends StateNotifier<BusModel?> {
  BusFormNotifier() : super(null);

  void initialize(BusModel? bus) {
    state = bus;
  }

  void updateField(String field, dynamic value) {
    if (state != null) {
      state = state!.copyWith();
      // Update specific field
    }
  }

  void clear() {
    state = null;
  }
}

// Similar form providers for other entities
final studentFormStateProvider = StateNotifierProvider<StudentFormNotifier, StudentModel?>((ref) {
  return StudentFormNotifier();
});

class StudentFormNotifier extends StateNotifier<StudentModel?> {
  StudentFormNotifier() : super(null);

  void initialize(StudentModel? student) {
    state = student;
  }

  void clear() {
    state = null;
  }
}

final routeFormStateProvider = StateNotifierProvider<RouteFormNotifier, RouteModel?>((ref) {
  return RouteFormNotifier();
});

class RouteFormNotifier extends StateNotifier<RouteModel?> {
  RouteFormNotifier() : super(null);

  void initialize(RouteModel? route) {
    state = route;
  }

  void clear() {
    state = null;
  }
}

// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.light);

  void toggleTheme() {
    state = state == AppTheme.light ? AppTheme.dark : AppTheme.light;
  }

  void setTheme(AppTheme theme) {
    state = theme;
  }
}

enum AppTheme { light, dark }

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');

  void setLanguage(String language) {
    state = language;
  }
}

// Filter Providers
final busFilterProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final studentFilterProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final routeFilterProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// Refresh Providers
final refreshTriggerProvider = StateProvider<int>((ref) => 0);

void refreshAll(WidgetRef ref) {
  ref.read(refreshTriggerProvider.notifier).state++;
}

// Permission Providers
final userPermissionsProvider = Provider<List<String>>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.permissions ?? [];
});

final canManageBusesProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  return user.type == UserType.admin ||
      user.type == UserType.schoolManager;
});

final canManageStudentsProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  return user.type == UserType.admin ||
      user.type == UserType.schoolManager ||
      user.type == UserType.parent;
});

final canViewLiveTrackingProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  return true; // All user types can view tracking
});

// Analytics Providers
final dailyAnalyticsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, schoolId) async {
  // This would fetch real analytics data
  await Future.delayed(const Duration(seconds: 1));

  return {
    'date': DateTime.now(),
    'totalTrips': 42,
    'totalDistance': 450.5,
    'onTimeTrips': 38,
    'delayedTrips': 4,
    'averageSpeed': 45.2,
    'fuelConsumed': 120.5,
    'maintenanceAlerts': 2,
    'totalStudents': 450,
    'attendancePercentage': 98.5,
    'driverRating': 4.7,
    'parentSatisfaction': 4.5,
  };
});

final monthlyAnalyticsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, schoolId) async {
  // This would fetch real analytics data
  await Future.delayed(const Duration(seconds: 2));

  return {
    'month': DateTime.now().month,
    'year': DateTime.now().year,
    'totalTrips': 1200,
    'totalDistance': 12500.5,
    'onTimePercentage': 92.5,
    'averageAttendance': 97.8,
    'totalFuelConsumed': 3500.2,
    'maintenanceCost': 2500.0,
    'driverPerformance': 4.6,
    'parentSatisfaction': 4.4,
    'revenue': 15000.0,
    'expenses': 8500.0,
  };
});