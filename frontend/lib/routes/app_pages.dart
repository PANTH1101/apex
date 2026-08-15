import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../views/edit_profile_view.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/profile_view.dart';
import '../views/register_view.dart';
import '../views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: AuthBinding(),
    ),
  ];
}
