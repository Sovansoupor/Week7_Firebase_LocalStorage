import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../providers/async_value.dart';
import '../../../providers/ride_pref_provider.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});


  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // Read the RidesPreferencesProvider
    final provider = context.read<RidesPreferencesProvider>();

    // Call the provider's setCurrentPreference method
    provider.setCurrentPreference(newPreference);



    // Navigate to the rides screen (with a bottom-to-top animation)
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(RidesScreen()),
    );
      }

  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider
    final provider = context.watch<RidesPreferencesProvider>();

    // Get the current preference and history preferences
    final currentRidePreference = provider.currentPreference;
    final pastPreferences = provider.pastPreferences;
    
    // Handle the states of pastPreferences
    if (pastPreferences.state == AsyncValueState.loading) {
      return const Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (pastPreferences.state == AsyncValueState.error) {
      return const Center(
        child: Text(
          'No connection. Try later.',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    if (pastPreferences.state == AsyncValueState.success) {
      final preferencesList = pastPreferences.data!.reversed.toList();

      
    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
           SizedBox(height: 100),
              Container(
                margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2.1 Display the Form to input the ride preferences
                    RidePrefForm(
                        initialPreference: currentRidePreference,
                        onSubmit: (newPreference) =>
                            onRidePrefSelected(context, newPreference)),
                    SizedBox(height: BlaSpacings.m),

                    // 2.2 Optionally display a list of past preferences
                    SizedBox(
                      height: 200, // Set a fixed height
                      child: ListView.builder(
                        shrinkWrap: true, // Fix ListView height issue
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: preferencesList.length,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: preferencesList[index],
                          onPressed: () => onRidePrefSelected(
                              context, preferencesList[index]),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

    // Fallback return statement
     return const Center(
      child: Text(
        'Unexpected state.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}