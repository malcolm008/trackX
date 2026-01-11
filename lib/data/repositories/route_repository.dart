import 'dart:async';
import '../models/transport/route_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class RouteRepository extends BaseRepository<RouteModel> {
  Future<List<RouteModel>> getRoutesBySchool(String schoolId);
  Future<List<RouteModel>> getActiveRoutes();
  Future<void> updateRouteStatus(String routeId, RouteStatus status);
  Future<void> addStop(String routeId, RouteStop stop);
  Future<void> removeStop(String routeId, String stopId);
  Future<void> updateStopOrder(String routeId, List<RouteStop> stops);
  Future<RouteModel?> getRouteByDriver(String driverId);
  Future<List<RouteModel>> searchRoutes(String query);
  Future<void> assignDriver(String routeId, String driverId);
  Future<void> unassignDriver(String routeId);
  Future<void> assignBus(String routeId, String busId);
}

class MockRouteRepository implements RouteRepository {
  final List<RouteModel> _routes = [];

  @override
  Future<List<RouteModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredRoutes = List<RouteModel>.from(_routes);

    if (filters != null) {
      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredRoutes = filteredRoutes.where((route) => route.schoolId == schoolId).toList();
      }

      if (filters.containsKey('status')) {
        final status = filters['status'] as RouteStatus;
        filteredRoutes = filteredRoutes.where((route) => route.status == status).toList();
      }

      if (filters.containsKey('driverId')) {
        final driverId = filters['driverId'] as String;
        filteredRoutes = filteredRoutes.where((route) => route.driverId == driverId).toList();
      }

      if (filters.containsKey('busId')) {
        final busId = filters['busId'] as String;
        filteredRoutes = filteredRoutes.where((route) => route.busId == busId).toList();
      }

      if (filters.containsKey('isActiveToday')) {
        final isActiveToday = filters['isActiveToday'] as bool;
        filteredRoutes = filteredRoutes.where((route) => route.isActiveToday == isActiveToday).toList();
      }
    }

    return filteredRoutes;
  }

  @override
  Future<RouteModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _routes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<RouteModel> create(RouteModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _routes.add(item);
    return item;
  }

  @override
  Future<RouteModel> update(String id, RouteModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _routes.indexWhere((route) => route.id == id);
    if (index != -1) {
      _routes[index] = item;
      return item;
    }

    throw RepositoryFailure('Route not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _routes.length;
    _routes.removeWhere((route) => route.id == id);

    return _routes.length < initialLength;
  }

  @override
  Stream<List<RouteModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_routes);
  }

  @override
  Stream<RouteModel?> watchById(String id) {
    try {
      final route = _routes.firstWhere((route) => route.id == id);
      return Stream.value(route);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<RouteModel>> getRoutesBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _routes.where((route) => route.schoolId == schoolId).toList();
  }

  @override
  Future<List<RouteModel>> getActiveRoutes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _routes.where((route) => route.status == RouteStatus.active).toList();
  }

  @override
  Future<void> updateRouteStatus(String routeId, RouteStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      _routes[index] = route.copyWith(status: status);
    }
  }

  @override
  Future<void> addStop(String routeId, RouteStop stop) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      final updatedStops = [...route.stops, stop];
      _routes[index] = route.copyWith(stops: updatedStops);
    }
  }

  @override
  Future<void> removeStop(String routeId, String stopId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      final updatedStops = route.stops.where((stop) => stop.id != stopId).toList();
      _routes[index] = route.copyWith(stops: updatedStops);
    }
  }

  @override
  Future<void> updateStopOrder(String routeId, List<RouteStop> stops) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      _routes[index] = route.copyWith(stops: stops);
    }
  }

  @override
  Future<RouteModel?> getRouteByDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _routes.firstWhere((route) => route.driverId == driverId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<RouteModel>> searchRoutes(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _routes.where((route) =>
    route.name.toLowerCase().contains(query.toLowerCase()) ||
        (route.driverId?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (route.busId?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> assignDriver(String routeId, String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      _routes[index] = route.copyWith(driverId: driverId);
    }
  }

  @override
  Future<void> unassignDriver(String routeId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      _routes[index] = route.copyWith(driverId: null);
    }
  }

  @override
  Future<void> assignBus(String routeId, String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final route = _routes.firstWhere((route) => route.id == routeId);
    if (route != null) {
      final index = _routes.indexOf(route);
      _routes[index] = route.copyWith(busId: busId);
    }
  }
}