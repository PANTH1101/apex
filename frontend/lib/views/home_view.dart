import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('APEX Events'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'APEX Event Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Phase 1 - Authentication Complete ✅',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Testing backend connection...'),
                    ],
                  );
                }

                if (controller.connectionStatus.value.isNotEmpty) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.isConnected.value
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: controller.isConnected.value
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Backend Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.connectionStatus.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.isConnected.value
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (controller.backendMessage.value.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              controller.backendMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: controller.testBackendConnection,
                icon: const Icon(Icons.refresh),
                label: const Text('Test Backend Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => authController.isAuthenticated.value
                  ? OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.profile),
                      icon: const Icon(Icons.person),
                      label: const Text('My Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      icon: const Icon(Icons.login),
                      label: const Text('Go to Login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    )),
              const SizedBox(height: 12),
              Obx(() => authController.isAuthenticated.value
                  ? OutlinedButton.icon(
                      onPressed: () => authController.logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Go to Register'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
