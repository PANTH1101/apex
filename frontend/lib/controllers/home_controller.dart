import 'package:get/get.dart';
import '../services/api_client.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxBool isLoading = false.obs;
  final RxString connectionStatus = ''.obs;
  final RxString backendMessage = ''.obs;
  final RxBool isConnected = false.obs;

  Future<void> testBackendConnection() async {
    isLoading.value = true;
    connectionStatus.value = 'Connecting...';
    backendMessage.value = '';
    isConnected.value = false;

    try {
      final response = await _apiClient.get('/ping');

      if (response['status'] == 'success') {
        connectionStatus.value = 'Connected successfully';
        backendMessage.value = response['message'] ?? '';
        isConnected.value = true;
      } else {
        connectionStatus.value = 'Connection failed';
        isConnected.value = false;
      }
    } catch (e) {
      connectionStatus.value = 'Unable to connect to backend';
      backendMessage.value = e.toString();
      isConnected.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
