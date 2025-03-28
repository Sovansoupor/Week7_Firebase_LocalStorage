import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/ride/ride_pref.dart';
import '../../dto/ride_pref_dto.dart';
import '../ride_preferences_repository.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Get the string list from the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    // Convert the string list to a list of RidePreferences using map()
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addPastPreference(RidePreference preference) async {
    // 1. Call getPastPreferences to get the current list
    final prefs = await SharedPreferences.getInstance();
    final preferences = await getPastPreferences();

    // 2. Add the new preference to the list
    preferences.add(preference);

    // 3. Save the new list as a string list
    await prefs.setStringList(
      _preferencesKey,
      preferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final preferences = await getPastPreferences();

    preferences.add(preference);

    await prefs.setStringList(
      _preferencesKey,
      preferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }
}