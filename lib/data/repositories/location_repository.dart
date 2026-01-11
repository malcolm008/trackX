import 'dart:async';
import '../models/location/location_model.dart';
import 'base_repository.dart';

abstract class LocationRepository extends BaseRepository<LocationModel> {
  Future<void> startTracking(String busId, String driverId);
  Future<void> stopTracking(String busId);
  Stream<LocationModel?> watchBusLocation(String busId);
  Future<List<LocationModel>> getBusLocationHistory(String busId, DateTime start, DateTime end);
  Future<void> setGeofence(GeofenceModel geofence);
  Future<void> removeGeofence(String geofenceId);
  Future<List<GeofenceModel>> getGeofencesByBus(String busId);
  Future<List<GeofenceModel>> getGeofencesBySchool(String schoolId);
  Future<void> updateCurrentLocation(double lat, double lng, {String? busId, String? driverId});
  Future<LocationModel?> getLastKnownLocation(String busId);
}

class MockLocationRepository implements LocationRepository {
  final List<LocationModel> _locations = [];
  final List<GeofenceModel> _geofences = [];
  final Map<String, StreamController<LocationModel>> _locationStreams = {};

  @override
  Future<List<LocationModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredLocations = List<LocationModel>.from(_locations);

    if (filters != null) {
      if (filters.containsKey('busId')) {
        final busId = filters['busId'] as String;
        filteredLocations = filteredLocations.where((loc) => loc.busId == busId).toList();
      }

      if (filters.containsKey('driverId')) {
        final driverId = filters['driverId'] as String;
        filteredLocations = filteredLocations.where((loc) => loc.driverId == driverId).toList();
      }

      if (filters.containsKey('routeId')) {
        final routeId = filters['routeId'] as String;
        filteredLocations = filteredLocations.where((loc) => loc.routeId == routeId).toList();
      }

      if (filters.containsKey('startDate') && filters.containsKey('endDate')) {
        final start = filters['startDate'] as DateTime;
        final end = filters['endDate'] as DateTime;
        filteredLocations = filteredLocations.where((loc) =>
        loc.timestamp.isAfter(start) && loc.timestamp.isBefore(end)
        ).toList();
      }
    }

    return filteredLocations;
  }

  @override
  Future<LocationModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _locations.firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LocationModel> create(LocationModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _locations.add(item);

    // Add to stream if tracking
    if (item.busId != null && _locationStreams.containsKey(item.busId!)) {
      _locationStreams[item.busId!]!.add(item);
    }

    return item;
  }

  @override
  Future<LocationModel> update(String id, LocationModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _locations.indexWhere((loc) => loc.id == id);
    if (index != -1) {
      _locations[index] = item;
      return item;
    }

    throw RepositoryFailure('Location not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _locations.length;
    _locations.removeWhere((loc) => loc.id == id);

    return _locations.length < initialLength;
  }

  @override
  Stream<List<LocationModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_locations);
  }

  @override
  Stream<LocationModel?> watchById(String id) {
    try {
      final location = _locations.firstWhere((loc) => loc.id == id);
      return Stream.value(location);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<void> startTracking(String busId, String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_locationStreams.containsKey(busId)) {
      _locationStreams[busId] = StreamController<LocationModel>.broadcast();
    }

    // Start sending mock location updates
    _startMockTracking(busId, driverId);
  }

  void _startMockTracking(String busId, String driverId) {
    // This would be replaced with real GPS tracking
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_locationStreams.containsKey(busId)) {
        timer.cancel();
        return;
      }

      final location = LocationModel(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        latitude: 37.7749 + (DateTime.now().second % 100) * 0.001,
        longitude: -122.4194 + (DateTime.now().second % 100) * 0.001,
        timestamp: DateTime.now(),
        busId: busId,
        driverId: driverId,
        speed: 30.0 + (DateTime.now().second % 20),
        heading: (DateTime.now().second % 360).toDouble(),
        accuracy: 5.0,
        isMoving: true,
      );

      await create(location);
    });
  }

  @override
  Future<void> stopTracking(String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _locationStreams[busId]?.close();
    _locationStreams.remove(busId);
  }

  @override
  Stream<LocationModel?> watchBusLocation(String busId) {
    if (!_locationStreams.containsKey(busId)) {
      startTracking(busId, '');
    }

    return _locationStreams[busId]?.stream ?? const Stream.empty();
  }

  @override
  Future<List<LocationModel>> getBusLocationHistory(String busId, DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _locations.where((loc) =>
    loc.busId == busId &&
        loc.timestamp.isAfter(start) &&
        loc.timestamp.isBefore(end)
    ).toList();
  }

  @override
  Future<void> setGeofence(GeofenceModel geofence) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _geofences.indexWhere((g) => g.id == geofence.id);
    if (index != -1) {
      _geofences[index] = geofence;
    } else {
      _geofences.add(geofence);
    }
  }

  @override
  Future<void> removeGeofence(String geofenceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _geofences.removeWhere((g) => g.id == geofenceId);
  }

  @override
  Future<List<GeofenceModel>> getGeofencesByBus(String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _geofences.where((g) => g.busId == busId).toList();
  }

  @override
  Future<List<GeofenceModel>> getGeofencesBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _geofences.where((g) => g.schoolId == schoolId).toList();
  }

  @override
  Future<void> updateCurrentLocation(double lat, double lng, {String? busId, String? driverId}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final location = LocationModel(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      busId: busId,
      driverId: driverId,
      accuracy: 10.0,
      isMoving: true,
    );

    await create(location);
  }

  @override
  Future<LocationModel?> getLastKnownLocation(String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final busLocations = _locations.where((loc) => loc.busId == busId).toList();
    if (busLocations.isEmpty) return null;

    busLocations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return busLocations.first;
  }
}