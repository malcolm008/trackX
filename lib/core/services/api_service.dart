import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/web/school/school_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/track_x/api';
  static const Duration timeout = Duration(seconds: 10);

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<School>> getSchools({
    String? search,
    String? status,
    String? subscription,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'get_schools',
        'search': search ?? '',
        'status': status ?? 'all',
        'subscription': subscription ?? 'all',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> schoolsData = data['schools'];
          return schoolsData.map((json) => School.fromJson(json)).toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load schools: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<SchoolStats> getSchoolStats() async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'get_stats',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return SchoolStats.fromJson(data['stats']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<School> addSchool(School school) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'add_school',
        'school': jsonEncode(school.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return School.fromJson(data['school']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to add school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateSchool(School school) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'update_school',
        'school': jsonEncode(school.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to update school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteSchool(String schoolId) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'delete_school',
        'school_id': schoolId,
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to delete school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  void dispose() {
    client.close();
  }
}