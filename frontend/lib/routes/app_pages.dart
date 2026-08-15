import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/discovery_binding.dart';
import '../bindings/event_binding.dart';
import '../bindings/home_binding.dart';
import '../views/attendee_event_details_view.dart';
import '../views/create_event_view.dart';
import '../views/edit_event_view.dart';
import '../views/edit_profile_view.dart';
import '../views/event_discovery_view.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/my_events_view.dart';
import '../views/organizer_event_details_view.dart';
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
    // Phase 2B — Organizer Event Management
    GetPage(
      name: AppRoutes.myEvents,
      page: () => const MyEventsView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: AppRoutes.createEvent,
      page: () => const CreateEventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: AppRoutes.eventDetails,
      page: () => const OrganizerEventDetailsView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: AppRoutes.editEvent,
      page: () => const EditEventView(),
      binding: EventBinding(),
    ),
    // Phase 2C — Attendee Event Discovery
    GetPage(
      name: AppRoutes.eventDiscovery,
      page: () => const EventDiscoveryView(),
      binding: DiscoveryBinding(),
    ),
    GetPage(
      name: AppRoutes.attendeeEventDetails,
      page: () => const AttendeeEventDetailsView(),
      binding: DiscoveryBinding(),
    ),
  ];
}
