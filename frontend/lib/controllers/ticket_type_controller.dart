import 'package:get/get.dart';
import '../models/ticket_type.dart';
import '../services/ticket_type_service.dart';

class TicketTypeController extends GetxController {
  late final TicketTypeService _ticketTypeService;

  final RxList<TicketType> ticketTypes = <TicketType>[].obs;
  final Rx<TicketType?> selectedTicketType = Rx<TicketType?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _ticketTypeService = Get.isRegistered<TicketTypeService>()
        ? Get.find<TicketTypeService>()
        : TicketTypeService();
  }

  // ── Load ticket types ─────────────────────────────────────────────────────

  Future<void> loadTicketTypes(int eventId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _ticketTypeService.getTicketTypes(eventId);
      ticketTypes.assignAll(result);
    } catch (e) {
      errorMessage.value = _friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load single ticket type ───────────────────────────────────────────────

  Future<void> loadTicketType(int eventId, int ticketTypeId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _ticketTypeService.getTicketType(eventId, ticketTypeId);
      selectedTicketType.value = result;
    } catch (e) {
      errorMessage.value = _friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Create ticket type ────────────────────────────────────────────────────

  Future<void> createTicketType({
    required int eventId,
    required String name,
    String? description,
    required double price,
    required int capacity,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final created = await _ticketTypeService.createTicketType(
        eventId: eventId,
        name: name,
        description: description,
        price: price,
        capacity: capacity,
      );

      ticketTypes.add(created);
      
      Get.snackbar('Success', 'Ticket type created successfully!',
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  // ── Update ticket type ────────────────────────────────────────────────────

  Future<void> updateTicketType({
    required int eventId,
    required int ticketTypeId,
    String? name,
    String? description,
    double? price,
    int? capacity,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final updated = await _ticketTypeService.updateTicketType(
        eventId: eventId,
        ticketTypeId: ticketTypeId,
        name: name,
        description: description,
        price: price,
        capacity: capacity,
      );

      final index = ticketTypes.indexWhere((t) => t.id == ticketTypeId);
      if (index != -1) {
        ticketTypes[index] = updated;
      }
      selectedTicketType.value = updated;

      Get.snackbar('Success', 'Ticket type updated successfully!',
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  // ── Delete ticket type ────────────────────────────────────────────────────

  Future<void> deleteTicketType(int eventId, int ticketTypeId) async {
    if (isDeleting.value) return;
    try {
      isDeleting.value = true;
      errorMessage.value = '';
      
      await _ticketTypeService.deleteTicketType(eventId, ticketTypeId);
      
      ticketTypes.removeWhere((t) => t.id == ticketTypeId);
      if (selectedTicketType.value?.id == ticketTypeId) {
        selectedTicketType.value = null;
      }
      
      Get.snackbar('Success', 'Ticket type deleted successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
  }

  // ── Clear state ───────────────────────────────────────────────────────────

  void clearState() {
    ticketTypes.clear();
    selectedTicketType.value = null;
    errorMessage.value = '';
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyError(Object e) {
    final msg = e.toString().replaceAll('Exception: ', '');
    if (msg.contains('Unauthorized')) return 'Session expired. Please log in again.';
    if (msg.contains('Forbidden')) return 'You do not have permission to do this.';
    if (msg.contains('Not found') || msg.contains('not found')) return 'Resource not found.';
    if (msg.contains('already exists')) return msg; // Show duplicate name errors as-is
    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Failed host lookup')) {
      return 'Unable to connect to server. Please try again.';
    }
    return msg;
  }
}