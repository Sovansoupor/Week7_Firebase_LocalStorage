import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import '../../../providers/ride_pref_provider.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
// ignore: must_be_immutable
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  RideFilter currentFilter = RideFilter();

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // Read the RidesPreferencesProvider
    final provider = context.read<RidesPreferencesProvider>();
    // Call the provider's setCurrentPreference method
    provider.setCurrentPreference(newPreference);
  }

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    // Open a modal to edit the ride preferences
    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null && context.mounted) {
      // Update the current preference using the provider
      onRidePrefSelected(context, newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider
    final provider = context.watch<RidesPreferencesProvider>();

    // Get the current preference
    final currentPreference = provider.currentPreference;

    // Get the list of available rides based on the current preference
    final matchingRides = currentPreference != null
        ? RidesService.instance.getRidesFor(currentPreference, RideFilter())
        : <Ride>[];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            currentPreference != null
                ? RidePrefBar(
                    ridePreference: currentPreference,
                    onBackPressed: () => Navigator.of(context).pop(),
                    onPreferencePressed: () {
                      onPreferencePressed(context, currentPreference);
                    },
                    onFilterPressed: onFilterPressed,
                  )
                : const SizedBox.shrink(),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
