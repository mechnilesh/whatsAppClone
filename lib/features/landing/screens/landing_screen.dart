import 'package:flutter/material.dart';
import 'package:wpclonemn/common/widgets/custom_button.dart';


import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: const Text(
                'Welcome to WhatsApp',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Read our Privacy Policy. Tap "Agree and continue to \n accept the terms of Service."',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: CustomButoon(
                text: 'AGREE AND CONTINUE',
                onPressed: () => navigateToLoginScreen(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
