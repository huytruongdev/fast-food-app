import 'package:flutter/material.dart';
import 'package:fast_food_app/Service/auth_service.dart';

AuthService authService = AuthService();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                authService.logout(context);
              },
              child: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
