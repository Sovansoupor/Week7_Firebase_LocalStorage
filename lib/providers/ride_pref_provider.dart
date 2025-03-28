import 'package:flutter/material.dart';

import '../../model/ride/ride_pref.dart';
import '../../repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  final List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;
  late AsyncValue<List<RidePreference>> pastPreferences;

  Future<void> _fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      // 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences from the repository
    pastPreferences = AsyncValue.loading();
    _fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  Future<void> fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();

      // 3- Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
    } catch (error) {
      // 4- Handle error
      pastPreferences = AsyncValue.error(error);
    }

    notifyListeners();
  }

  void _addPreference(RidePreference preference) async {
    // 1- Call the repository to add the preference
    await repository.addPreference(preference);

    // 2- Fetch the updated data from the repository
    await fetchPastPreferences();
  }

  void setCurrentPreference(RidePreference pref) {
    // Process only if the new preference is not equal to the current one
    if (_currentPreference != pref) {
      _currentPreference = pref; //Update the current preference
      _updatePreference(pref); // Update the history (ensure exclusivity)
      notifyListeners();
    }
  }

  void _updatePreference(RidePreference preference) {
    if (pastPreferences.state == AsyncValueState.success) {
      // Remove the preference if it already exists in the history
      pastPreferences.data!.removeWhere((p) => p == preference);

      // Add the new preference to the history
      pastPreferences.data!.add(preference);
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      pastPreferences.state == AsyncValueState.success
          ? pastPreferences.data!.reversed.toList()
          : [];
}
