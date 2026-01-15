import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart'; // Ensure HomeScreen class is defined here
import 'name_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserProvider>().loadUser(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan Loading yang proper
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = context.watch<UserProvider>();
        if (user.name == null) {
          return const NameScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
