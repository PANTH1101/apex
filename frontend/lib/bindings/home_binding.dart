import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is already registered by AuthBinding (splash/login).
    // Do NOT re-register it here — reuse the existing instance.
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
