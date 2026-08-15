import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';
import '../services/event_service.dart';

class DiscoveryBinding extends Bindings {
  @override
  void dependencies() {
    // Reuse EventService if already registered (Organizer routes may have put it);
    // otherwise create it fresh. fenix: true ensures recreation after disposal.
    Get.lazyPut<EventService>(() => EventService(), fenix: true);
    Get.lazyPut<DiscoveryController>(() => DiscoveryController(), fenix: true);
  }
}
