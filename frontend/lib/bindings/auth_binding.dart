import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // permanent: true keeps AuthController alive across all route changes.
    // fenix: true allows it to be recreated if it was manually disposed.
    Get.put<AuthController>(
      AuthController(),
      permanent: true,
    );
  }
}
