import 'package:get/get.dart';
import 'package:mutualfund/app/data/services/auth_service.dart';
import 'package:mutualfund/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthService is registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
