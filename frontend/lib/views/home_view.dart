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
              Obx(() {
                final user = authController.currentUser.value;
                if (user == null) return const SizedBox.shrink();
                return Text(
                  'Welcome, ${user.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              const SizedBox(height: 48),

              // Organizer: My Events button
              Obx(() {
                final user = authController.currentUser.value;
                if (user == null || user.role != 'ORGANIZER') {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.myEvents),
                      icon: const Icon(Icons.event_note),
                      label: const Text('My Events'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              // Attendee: Discover Events button
              Obx(() {
                final user = authController.currentUser.value;
                if (user == null || user.role != 'ATTENDEE') {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.eventDiscovery),
                      icon: const Icon(Icons.explore),
                      label: const Text('Discover Events'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.profile),
                icon: const Icon(Icons.person),
                label: const Text('My Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  minimumSize: const Size(double.infinity, 52),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Backend connection test
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 52,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.connectionStatus.value.isNotEmpty) {
                  return Column(
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
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              controller.connectionStatus.value,
                              style: TextStyle(
                                color: controller.isConnected.value
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              OutlinedButton.icon(
                onPressed: controller.testBackendConnection,
                icon: const Icon(Icons.refresh),
                label: const Text('Test Backend Connection'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: () => authController.logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
