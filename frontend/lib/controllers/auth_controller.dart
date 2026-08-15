import 'dart:async';

import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final loggedIn = await _authService.isLoggedIn().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      if (loggedIn) {
        try {
          await loadCurrentUser();
          isAuthenticated.value = true;
          return true;
        } catch (e) {
          // Token exists but user fetch failed (backend down, expired token, etc.)
          await _authService.logout();
          isAuthenticated.value = false;
          currentUser.value = null;
          return false;
        }
      }

      isAuthenticated.value = false;
      currentUser.value = null;
      return false;
    } catch (e) {
      isAuthenticated.value = false;
      currentUser.value = null;
      return false;
    }
  }

  // Load current user profile
  Future<void> loadCurrentUser() async {
    try {
      User user = await _authService.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      // If token is invalid, logout
      await logout();
      rethrow;
    }
  }

  // Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    try {
      isLoading.value = true;

      await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
      );

      // Load full user profile
      await loadCurrentUser();
      isAuthenticated.value = true;

      Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        'Success',
        'Registration successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      await _authService.login(
        email: email,
        password: password,
      );

      // Load full user profile
      await loadCurrentUser();
      isAuthenticated.value = true;

      Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      isLoading.value = true;

      final updatedUser = await _authService.updateProfile(
        name: name,
        phone: phone,
      );

      currentUser.value = updatedUser;

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _authService.logout();
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
