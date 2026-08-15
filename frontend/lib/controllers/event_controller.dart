import 'package:get/get.dart';
import '../models/event.dart';
import '../routes/app_routes.dart';
import '../services/event_service.dart';

class EventController extends GetxController {
  late final EventService _eventService;

  final RxList<Event> events = <Event>[].obs;
  final Rx<Event?> selectedEvent = Rx<Event?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isUploadingImage = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _eventService = Get.isRegistered<EventService>()
        ? Get.find<EventService>()
        : EventService();
    loadMyEvents();
  }

  // ── Load list ─────────────────────────────────────────────────────────────

  Future<void> loadMyEvents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _eventService.getMyEvents();
      events.assignAll(result);
    } catch (e) {
      errorMessage.value = _friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load single ───────────────────────────────────────────────────────────

  Future<void> loadEvent(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _eventService.getEventById(id);
      selectedEvent.value = result;
    } catch (e) {
      errorMessage.value = _friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<void> createEvent({
    required String title,
    required String description,
    required String category,
    required String venue,
    required String address,
    required String city,
    required DateTime registrationStartDateTime,
    required DateTime registrationEndDateTime,
    required DateTime startDateTime,
    DateTime? endDateTime,
    required double ticketPrice,
    required int capacity,
    String? imageFilePath,
    String? imageMimeType,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      final created = await _eventService.createEvent(
        title: title,
        description: description,
        category: category,
        venue: venue,
        address: address,
        city: city,
        registrationStartDateTime: registrationStartDateTime,
        registrationEndDateTime: registrationEndDateTime,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        ticketPrice: ticketPrice,
        capacity: capacity,
      );

      // Upload image (best-effort)
      if (imageFilePath != null && imageMimeType != null) {
        try {
          await _eventService.uploadEventImage(
            eventId: created.id,
            filePath: imageFilePath,
            mimeType: imageMimeType,
          );
        } catch (_) {}
      }

      Get.snackbar('Success', 'Event created successfully!',
          snackPosition: SnackPosition.BOTTOM);

      Get.offNamedUntil(
          AppRoutes.myEvents, (r) => r.settings.name == AppRoutes.home);
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> updateEvent({
    required int id,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? address,
    String? city,
    DateTime? registrationStartDateTime,
    DateTime? registrationEndDateTime,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool removeEndDateTime = false,
    double? ticketPrice,
    int? capacity,
    String? status,
    String? imageFilePath,
    String? imageMimeType,
    bool removeImage = false,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      Event updated = await _eventService.updateEvent(
        id: id,
        title: title,
        description: description,
        category: category,
        venue: venue,
        address: address,
        city: city,
        registrationStartDateTime: registrationStartDateTime,
        registrationEndDateTime: registrationEndDateTime,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        removeEndDateTime: removeEndDateTime,
        ticketPrice: ticketPrice,
        capacity: capacity,
        status: status,
      );

      if (removeImage) {
        try { updated = await _eventService.removeEventImage(id); } catch (_) {}
      } else if (imageFilePath != null && imageMimeType != null) {
        try {
          updated = await _eventService.uploadEventImage(
            eventId: id,
            filePath: imageFilePath,
            mimeType: imageMimeType,
          );
        } catch (_) {}
      }

      final index = events.indexWhere((e) => e.id == id);
      if (index != -1) events[index] = updated;
      selectedEvent.value = updated;

      Get.snackbar('Success', 'Event updated successfully!',
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

  // ── Image upload ──────────────────────────────────────────────────────────

  Future<void> uploadImage({
    required int eventId,
    required String filePath,
    required String mimeType,
  }) async {
    if (isUploadingImage.value) return;
    try {
      isUploadingImage.value = true;
      final updated = await _eventService.uploadEventImage(
          eventId: eventId, filePath: filePath, mimeType: mimeType);
      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) events[index] = updated;
      selectedEvent.value = updated;
      Get.snackbar('Success', 'Image updated!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploadingImage.value = false;
    }
  }

  // ── Image remove ──────────────────────────────────────────────────────────

  Future<void> removeImage(int eventId) async {
    if (isUploadingImage.value) return;
    try {
      isUploadingImage.value = true;
      final updated = await _eventService.removeEventImage(eventId);
      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) events[index] = updated;
      selectedEvent.value = updated;
      Get.snackbar('Success', 'Image removed.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploadingImage.value = false;
    }
  }

  // ── Delete event ──────────────────────────────────────────────────────────

  Future<void> deleteEvent(int id) async {
    if (isDeleting.value) return;
    try {
      isDeleting.value = true;
      errorMessage.value = '';
      await _eventService.deleteEvent(id);
      events.removeWhere((e) => e.id == id);
      selectedEvent.value = null;
      Get.snackbar('Success', 'Event deleted successfully!',
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamedUntil(
          AppRoutes.myEvents, (r) => r.settings.name == AppRoutes.home);
    } catch (e) {
      final msg = _friendlyError(e);
      errorMessage.value = msg;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyError(Object e) {
    final msg = e.toString().replaceAll('Exception: ', '');
    if (msg.contains('Unauthorized')) return 'Session expired. Please log in again.';
    if (msg.contains('Forbidden')) return 'You do not have permission to do this.';
    if (msg.contains('Not found') || msg.contains('not found')) return 'Event not found.';
    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Failed host lookup')) {
      return 'Unable to connect to server. Please try again.';
    }
    return msg;
  }
}
