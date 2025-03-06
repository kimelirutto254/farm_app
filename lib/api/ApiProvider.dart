import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/model/Notification.dart';
import 'package:ifms/model/checklist.dart';
import 'package:ifms/model/crops.dart';
import 'package:ifms/model/farmers.dart';
// Importing provider package

class FarmersProvider extends ChangeNotifier {
  List<Farmer> initialFarmers = []; // Stores only 10 farmers initially
  List<Farmer> searchedFarmers = []; // Stores search results
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  // Getters
  List<Farmer> get farmers => initialFarmers;
  bool get isLoading => _isLoading;

  // --------------------------------
  // FETCH INITIAL 10 FARMERS
  // --------------------------------
  Future<void> fetchInitialFarmers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _callApi.getData(
        'getFarmers?limit=10',
      ); // Fetch 10 farmers only

      if (response != 'failed') {
        final List<dynamic> data = json.decode(response.body);
        initialFarmers = data.map((json) => Farmer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (error) {
      print('Error fetching farmers: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------
  // SEARCH FARMERS FROM API
  // --------------------------------
  Future<void> searchFarmers(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _callApi.getData(
        'searchFarmers?query=$query',
      ); // Search API call

      if (response != 'failed') {
        final List<dynamic> data = json.decode(response.body);
        searchedFarmers = data.map((json) => Farmer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search farmers');
      }
    } catch (error) {
      print('Error searching farmers: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class ChecklistProvider with ChangeNotifier {
  List<Checklist> checklist = [];
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  // Getters
  List<Checklist> get stakes => checklist;
  bool get isLoading => _isLoading;

  // -------------------------------
  // FETCH STAKES USING CallApi
  // -------------------------------
  Future<void> fetchchecklist() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API to get stakes
      final response = await _callApi.getData(
        'getRequirements',
      ); // The API endpoint to fetch stakes

      if (response != 'failed') {
        final List<dynamic> data = json.decode(response.body);
        checklist = data.map((json) => Checklist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load checklist');
      }
    } catch (error) {
      print('Error fetching checklist: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class RecentInspectionsProvider with ChangeNotifier {
  List<Farmer> farmers = [];
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  // Getters
  List<Farmer> get stakes => farmers;
  bool get isLoading => _isLoading;

  // -------------------------------
  // FETCH STAKES USING CallApi
  // -------------------------------
  Future<void> fetchrecentinspections() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API to get stakes
      final response = await _callApi.getData(
        'getRecentInspections',
      ); // The API endpoint to fetch stakes

      if (response != 'failed') {
        final List<dynamic> data = json.decode(response.body);
        farmers = data.map((json) => Farmer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stakes');
      }
    } catch (error) {
      print('Error fetching stakes: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class NotificationsProvider with ChangeNotifier {
  List<NotificationModel> notifications = [];
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  // Getters
  bool get isLoading => _isLoading;

  // -------------------------------
  // FETCH STAKES USING CallApi
  // -------------------------------
  Future<void> fetchnotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API
      final response = await _callApi.getData('getInspectorNotifications');

      if (response != 'failed') {
        final Map<String, dynamic> data = json.decode(
          response.body,
        ); // Decode as Map

        if (data.containsKey('data')) {
          final List<dynamic> notificationsList = data['data'];
          notifications =
              notificationsList
                  .map((json) => NotificationModel.fromJson(json))
                  .toList();
        } else {
          throw Exception('Invalid API response: Missing notifications key');
        }
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class CropsProvider with ChangeNotifier {
  List<Crop> crops = [];
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  // Getter for loading state
  bool get isLoading => _isLoading;

  // -------------------------------
  // FETCH CROPS USING CallApi
  // -------------------------------
  Future<List<Crop>> fetchCrops(int growerId) async {
    _isLoading = true;
    notifyListeners();

    List<Crop> fetchedCrops = [];

    try {
      // Call the API
      final response = await _callApi.getData('crops', id: growerId);

      if (response != 'failed') {
        // Decode the response as a List, not a Map
        final List<dynamic> cropsList = json.decode(response.body);

        // Map the List<dynamic> to a List<Crop>
        fetchedCrops = cropsList.map((json) => Crop.fromJson(json)).toList();

        // Update provider state
        crops = fetchedCrops;
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (error) {
      print('Error fetching crops: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return fetchedCrops; // ✅ Return the list of crops
  }
}

class FarmerViewProvider with ChangeNotifier {
  Farmer? farmer;
  bool _isLoading = false;

  final CallApi _callApi = CallApi();

  Farmer? get farmerData => farmer;
  bool get isLoading => _isLoading;

  Future<Farmer?> fetchfarmer(int grower_id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _callApi.getData('getFarmer', id: grower_id);

      if (response != 'failed') {
        final data = json.decode(response.body);
        print(data);

        if (data is Map<String, dynamic>) {
          farmer = Farmer.fromJson(data);
          return farmer; // Return the fetched farmer
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load farmer data');
      }
    } catch (error) {
      print('Error fetching farmer data: $error');
      return null; // Return null in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
