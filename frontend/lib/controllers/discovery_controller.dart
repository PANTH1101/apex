import 'dart:async';
import 'package:get/get.dart';
import '../models/event.dart';
import '../routes/app_routes.dart';
import '../services/event_service.dart';

class DiscoveryController extends GetxController {
  late final EventService _eventService;

  // ── Event list ────────────────────────────────────────────────────────────
  final RxList<Event> events = <Event>[].obs;
  final Rx<Event?> selectedEvent = Rx<Event?>(null);

  // ── State ─────────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Active filters ────────────────────────────────────────────────────────
  final RxString searchKeyword = ''.obs;
  final RxString selectedCategory = ''.obs; // '' = All
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // ── Debounce timer for search ─────────────────────────────────────────────
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _eventService = Get.isRegistered<EventService>()
        ? Get.find<EventService>()
        : EventService();
    loadEvents();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  // ── Load / search ─────────────────────────────────────────────────────────

  Future<void> loadEvents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _eventService.getEvents(
        keyword: searchKeyword.value.isEmpty ? null : searchKeyword.value,
        category: selectedCategory.value.isEmpty ? null : selectedCategory.value,
        startDate: startDate.value,
        endDate: endDate.value,
      );
      events.assignAll(result);
    } catch (e) {
      errorMessage.value = _friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Called whenever the search text field changes.
  /// Debounces 500 ms before triggering the API call.
  void onSearchChanged(String value) {
    searchKeyword.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), loadEvents);
  }

  /// Called when the user explicitly taps Search / applies filters.
  void applyFilters() {
    _debounce?.cancel();
    loadEvents();
  }

  /// Reset all filters and reload.
  void clearFilters() {
    _debounce?.cancel();
    searchKeyword.value = '';
    selectedCategory.value = '';
    startDate.value = null;
    endDate.value = null;
    loadEvents();
  }

  bool get hasActiveFilters =>
      searchKeyword.value.isNotEmpty ||
      selectedCategory.value.isNotEmpty ||
      startDate.value != null ||
      endDate.value != null;

  // ── Navigate to attendee details ──────────────────────────────────────────

  void openEventDetails(Event event) {
    selectedEvent.value = event;
    Get.toNamed(AppRoutes.attendeeEventDetails);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyError(Object e) {
    final msg = e.toString().replaceAll('Exception: ', '');
    if (msg.contains('Unauthorized')) {
      return 'Session expired. Please log in again.';
    }
    if (msg.contains('Forbidden')) {
      return 'You do not have permission to access events.';
    }
    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Failed host lookup')) {
      return 'Unable to connect to server. Please try again.';
    }
    return msg;
  }
}
