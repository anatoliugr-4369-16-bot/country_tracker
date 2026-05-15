import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../core/constants.dart';

class ApiService {
  Future<List<Country>> fetchAllCountries() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.apiBaseUrl}${AppConstants.allCountriesEndpoint}',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load countries. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
