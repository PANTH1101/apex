import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));

    // Wait for AuthController to finish its async onInit (checkAuthStatus)
    // It was already triggered in onInit(), we just need its result
    final authController = Get.find<AuthController>();

    // Give it up to 8 seconds total to finish (5s timeout is inside checkAuthStatus)
    // If it's already done, this resolves immediately
    bool isLoggedIn = false;
    try {
      isLoggedIn = await authController.checkAuthStatus().timeout(
        const Duration(seconds: 8),
        onTimeout: () => false,
      );
    } catch (_) {
      isLoggedIn = false;
    }

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'APEX',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Event Management',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
