import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../services/event_service.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    // Use fenix: true so GetX recreates the controller if it was disposed,
    // but reuses the existing instance when still alive (e.g. navigating
    // detail → edit stays on the same controller and preserves selectedEvent).pl
    Get.lazyPut<EventService>(() => EventService(), fenix: true);
    Get.lazyPut<EventController>(() => EventController(), fenix: true);
  }
}
