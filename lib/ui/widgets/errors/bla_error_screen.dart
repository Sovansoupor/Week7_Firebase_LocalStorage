import 'package:flutter/material.dart';

import '../../theme/theme.dart';

const String blablaWifiImagePath = 'assets/images/blabla_wifi.png';

class BlaError extends StatelessWidget {
  const BlaError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: BlaSpacings.m, right: BlaSpacings.m, top: BlaSpacings.s),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              blablaWifiImagePath,
              fit: BoxFit.none, // Adjust image fit to cover the container
            ),
            Text(
              message,
              style: BlaTextStyles.heading.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    ));
  }
}
