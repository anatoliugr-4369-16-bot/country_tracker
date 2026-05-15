import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/country.dart';
import '../services/api_service.dart';
import '../core/constants.dart';

class CountryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  List<Map<String, dynamic>> _favorites = []; // Store favorites with notes

  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String? _selectedRegion;

  // Getters
  List<Country> get countries => _filteredCountries;
  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedRegion => _selectedRegion;

  // Load countries from API (READ)
  Future<void> fetchCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allCountries = await _apiService.fetchAllCountries();
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(AppConstants.favoritesKey);
    if (favoritesJson != null) {
      List<dynamic> list = jsonDecode(favoritesJson);
      _favorites = list.map((item) => Map<String, dynamic>.from(item)).toList();
      notifyListeners();
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.favoritesKey, jsonEncode(_favorites));
  }

  // CREATE: Add to favorites with optional note
  Future<void> addToFavorites(Country country, {String note = ''}) async {
    if (!isFavorite(country.cca2)) {
      _favorites.add({
        'countryCode': country.cca2,
        'name': country.name,
        'flagUrl': country.flagUrl,
        'note': note,
      });
      await _saveFavorites();
      notifyListeners();
    }
  }

  // UPDATE: Edit note for a favorite country
  Future<void> updateNote(String countryCode, String newNote) async {
    final index = _favorites.indexWhere(
      (fav) => fav['countryCode'] == countryCode,
    );
    if (index != -1) {
      _favorites[index]['note'] = newNote;
      await _saveFavorites();
      notifyListeners();
    }
  }

  // DELETE: Remove from favorites
  Future<void> removeFromFavorites(String countryCode) async {
    _favorites.removeWhere((fav) => fav['countryCode'] == countryCode);
    await _saveFavorites();
    notifyListeners();
  }

  // Check if a country is favorite
  bool isFavorite(String countryCode) {
    return _favorites.any((fav) => fav['countryCode'] == countryCode);
  }

  // Get favorite data (including note)
  Map<String, dynamic>? getFavorite(String countryCode) {
    try {
      return _favorites.firstWhere((fav) => fav['countryCode'] == countryCode);
    } catch (e) {
      return null;
    }
  }

  // Search & Filter logic
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void updateRegionFilter(String? region) {
    _selectedRegion = region;
    _applyFilters();
  }

  void _applyFilters() {
    List<Country> result = _allCountries;

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((c) => c.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    if (_selectedRegion != null && _selectedRegion != 'All') {
      result = result.where((c) => c.region == _selectedRegion).toList();
    }

    _filteredCountries = result;
    notifyListeners();
  }

  // Get available regions for filter chips
  List<String> get availableRegions {
    final regions = _allCountries.map((c) => c.region).toSet().toList();
    regions.sort();
    return ['All', ...regions];
  }
}
