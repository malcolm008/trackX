import 'dart:async';
import '../models/transport/bus_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class BusRepository extends BaseRepository<BusModel> {
  Future<List<BusModel>> getBusesBySchool(String schoolId);
  Future<List<BusModel>> getBusesByStatus(BusStatus status);
  Future<void> updateBusLocation(String busId, double lat, double lng);
  Future<List<BusModel>> getActiveBuses();
  Future<BusModel?> getBusByDriver(String driverId);
  Future<void> updateBusStatus(String busId, BusStatus status);
  Future<List<BusModel>> searchBuses(String query);
  Future<void> assignDriver(String busId, String driverId);
  Future<void> unassignDriver(String busId);
}

class MockBusRepository implements BusRepository {
  final List<BusModel> _buses = [];

  @override
  Future<List<BusModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredBuses = List<BusModel>.from(_buses);

    if (filters != null) {
      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredBuses = filteredBuses.where((bus) => bus.schoolId == schoolId).toList();
      }

      if (filters.containsKey('status')) {
        final status = filters['status'] as BusStatus;
        filteredBuses = filteredBuses.where((bus) => bus.status == status).toList();
      }

      if (filters.containsKey('driverId')) {
        final driverId = filters['driverId'] as String;
        filteredBuses = filteredBuses.where((bus) => bus.driverId == driverId).toList();
      }
    }

    return filteredBuses;
  }

  @override
  Future<BusModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _buses.firstWhere((bus) => bus.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BusModel> create(BusModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _buses.add(item);
    return item;
  }

  @override
  Future<BusModel> update(String id, BusModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _buses.indexWhere((bus) => bus.id == id);
    if (index != -1) {
      _buses[index] = item;
      return item;
    }

    throw RepositoryFailure('Bus not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _buses.length;
    _buses.removeWhere((bus) => bus.id == id);

    return _buses.length < initialLength;
  }

  @override
  Stream<List<BusModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_buses);
  }

  @override
  Stream<BusModel?> watchById(String id) {
    try {
      final bus = _buses.firstWhere((bus) => bus.id == id);
      return Stream.value(bus);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<BusModel>> getBusesBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buses.where((bus) => bus.schoolId == schoolId).toList();
  }

  @override
  Future<List<BusModel>> getBusesByStatus(BusStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buses.where((bus) => bus.status == status).toList();
  }

  @override
  Future<void> updateBusLocation(String busId, double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final bus = _buses.firstWhere((bus) => bus.id == busId);
    if (bus != null) {
      final index = _buses.indexOf(bus);
      _buses[index] = bus.copyWith(
        currentLat: lat,
        currentLng: lng,
      );
    }
  }

  @override
  Future<List<BusModel>> getActiveBuses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _buses.where((bus) => bus.status == BusStatus.active).toList();
  }

  @override
  Future<BusModel?> getBusByDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _buses.firstWhere((bus) => bus.driverId == driverId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateBusStatus(String busId, BusStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final bus = _buses.firstWhere((bus) => bus.id == busId);
    if (bus != null) {
      final index = _buses.indexOf(bus);
      _buses[index] = bus.copyWith(status: status);
    }
  }

  @override
  Future<List<BusModel>> searchBuses(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _buses.where((bus) =>
    bus.plateNumber.toLowerCase().contains(query.toLowerCase()) ||
        bus.model.toLowerCase().contains(query.toLowerCase()) ||
        (bus.driverId?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> assignDriver(String busId, String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final bus = _buses.firstWhere((bus) => bus.id == busId);
    if (bus != null) {
      final index = _buses.indexOf(bus);
      _buses[index] = bus.copyWith(driverId: driverId);
    }
  }

  @override
  Future<void> unassignDriver(String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final bus = _buses.firstWhere((bus) => bus.id == busId);
    if (bus != null) {
      final index = _buses.indexOf(bus);
      _buses[index] = bus.copyWith(driverId: null);
    }
  }
}