import 'package:get/get.dart';
import '../controllers/ticket_type_controller.dart';
import '../services/ticket_type_service.dart';

class TicketTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketTypeService>(() => TicketTypeService(), fenix: true);
    Get.lazyPut<TicketTypeController>(() => TicketTypeController(), fenix: true);
  }
}