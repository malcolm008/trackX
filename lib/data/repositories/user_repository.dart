import 'dart:async';
import '../models/user/user_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';


abstract class UserRepository extends BaseRepository<UserModel> {
  Future<UserModel?> login(String email, String password);
  Future<void> logout();
  Future<UserModel> updateProfile(UserModel user);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<List<UserModel>> getUsersByType(UserType type);
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> watchCurrentUser();
  Future<List<UserModel>> searchUsers(String query);
  Future<void> updateFcmToken(String userId, String fcmToken);
  Future<void> deleteAccount(String userId);
}

class MockUserRepository implements UserRepository {
  final List<UserModel> _users = [];
  UserModel? _currentUser;

  @override
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _users.firstWhere(
          (user) => user.email == email,
      orElse: () => UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        type: UserType.admin,
      ),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    } else {
      _users.add(user);
    }

    if (_currentUser?.id == user.id) {
      _currentUser = user;
    }

    return user;
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<UserModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredUsers = List<UserModel>.from(_users);

    if (filters != null) {
      if (filters.containsKey('type')) {
        final type = filters['type'] as UserType;
        filteredUsers = filteredUsers.where((user) => user.type == type).toList();
      }

      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredUsers = filteredUsers.where((user) => user.schoolId == schoolId).toList();
      }

      if (filters.containsKey('isActive')) {
        final isActive = filters['isActive'] as bool;
        filteredUsers = filteredUsers.where((user) => user.isActive == isActive).toList();
      }
    }

    return filteredUsers;
  }

  @override
  Future<UserModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.firstWhere((user) => user.id == id);
  }

  @override
  Future<UserModel> create(UserModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.add(item);
    return item;
  }

  @override
  Future<UserModel> update(String id, UserModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = item;
      return item;
    }

    throw RepositoryFailure('User not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _users.length;
    _users.removeWhere((user) => user.id == id);

    return _users.length < initialLength;
  }

  @override
  Stream<List<UserModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_users);
  }

  @override
  Stream<UserModel?> watchById(String id) {
    final user = _users.firstWhere((user) => user.id == id);
    return Stream.value(user);
  }

  @override
  Future<List<UserModel>> getUsersByType(UserType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.where((user) => user.type == type).toList();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Stream<UserModel?> watchCurrentUser() {
    return Stream.value(_currentUser);
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _users.where((user) =>
    user.name.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase()) ||
        (user.phone?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> updateFcmToken(String userId, String fcmToken) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final user = _users.firstWhere((user) => user.id == userId);
    if (user != null) {
      final index = _users.indexOf(user);
      _users[index] = user.copyWith(fcmToken: fcmToken);
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((user) => user.id == userId);

    if (_currentUser?.id == userId) {
      _currentUser = null;
    }
  }
}