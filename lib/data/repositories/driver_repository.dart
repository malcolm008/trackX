import 'dart:async';
import '../models/transport/bus_model.dart';
import 'base_repository.dart';

abstract class DriverRepository extends BaseRepository<DriverModel> {
  Future<List<DriverModel>> getAvailableDrivers();
  Future<void> assignBus(String driverId, String busId);
  Future<void> removeBusAssignment(String driverId);
  Future<List<DriverModel>> getDriversBySchool(String schoolId);
  Future<List<DriverModel>> searchDrivers(String query);
  Future<void> updateDriverStatus(String driverId, bool isAvailable);
  Future<DriverModel?> getDriverByUserId(String userId);
  Future<void> updateDriverLocation(String driverId, double lat, double lng);
}

class MockDriverRepository implements DriverRepository {
  final List<DriverModel> _drivers = [];

  @override
  Future<List<DriverModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredDrivers = List<DriverModel>.from(_drivers);

    if (filters != null) {
      if (filters.containsKey('isAvailable')) {
        final isAvailable = filters['isAvailable'] as bool;
        filteredDrivers = filteredDrivers.where((driver) => driver.isAvailable == isAvailable).toList();
      }

      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredDrivers = filteredDrivers.where((driver) => driver.isAvailable).toList();
      }
    }

    return filteredDrivers;
  }

  @override
  Future<DriverModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _drivers.firstWhere((driver) => driver.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DriverModel> create(DriverModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _drivers.add(item);
    return item;
  }

  @override
  Future<DriverModel> update(String id, DriverModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _drivers.indexWhere((driver) => driver.id == id);
    if (index != -1) {
      _drivers[index] = item;
      return item;
    }

    throw RepositoryFailure('Driver not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _drivers.length;
    _drivers.removeWhere((driver) => driver.id == id);

    return _drivers.length < initialLength;
  }

  @override
  Stream<List<DriverModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_drivers);
  }

  @override
  Stream<DriverModel?> watchById(String id) {
    try {
      final driver = _drivers.firstWhere((driver) => driver.id == id);
      return Stream.value(driver);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<DriverModel>> getAvailableDrivers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _drivers.where((driver) => driver.isAvailable).toList();
  }

  @override
  Future<void> assignBus(String driverId, String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final driver = _drivers.firstWhere((driver) => driver.id == driverId);
    if (driver != null) {
      final index = _drivers.indexOf(driver);
      _drivers[index] = driver.copyWith(assignedBusId: busId);
    }
  }

  @override
  Future<void> removeBusAssignment(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final driver = _drivers.firstWhere((driver) => driver.id == driverId);
    if (driver != null) {
      final index = _drivers.indexOf(driver);
      _drivers[index] = driver.copyWith(assignedBusId: null);
    }
  }

  @override
  Future<List<DriverModel>> getDriversBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _drivers.where((driver) => driver.isAvailable).toList();
  }

  @override
  Future<List<DriverModel>> searchDrivers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _drivers.where((driver) =>
    driver.name.toLowerCase().contains(query.toLowerCase()) ||
        driver.phone.toLowerCase().contains(query.toLowerCase()) ||
        (driver.email?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (driver.licenseNumber?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> updateDriverStatus(String driverId, bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final driver = _drivers.firstWhere((driver) => driver.id == driverId);
    if (driver != null) {
      final index = _drivers.indexOf(driver);
      _drivers[index] = driver.copyWith(isAvailable: isAvailable);
    }
  }

  @override
  Future<DriverModel?> getDriverByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _drivers.firstWhere((driver) => driver.userId == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateDriverLocation(String driverId, double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final driver = _drivers.firstWhere((driver) => driver.id == driverId);
    if (driver != null) {
      final index = _drivers.indexOf(driver);
      _drivers[index] = driver.copyWith(
        currentLat: lat,
        currentLng: lng,
      );
    }
  }
}