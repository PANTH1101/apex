import '../models/event.dart';
import 'api_client.dart';

class EventService {
  final ApiClient _apiClient = ApiClient();

  // ── POST /api/events ──────────────────────────────────────────────────────

  Future<Event> createEvent({
    required String title,
    required String description,
    required String category,
    required String venue,
    required String address,
    required String city,
    required DateTime registrationStartDateTime,
    required DateTime registrationEndDateTime,
    required DateTime startDateTime,
    DateTime? endDateTime, // optional
    required double ticketPrice,
    required int capacity,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'address': address,
      'city': city,
      'registrationStartDateTime': registrationStartDateTime.toIso8601String(),
      'registrationEndDateTime': registrationEndDateTime.toIso8601String(),
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(), // null sent as JSON null
      'ticketPrice': ticketPrice,
      'capacity': capacity,
    };
    final response = await _apiClient.post('/events', body, requiresAuth: true);
    return Event.fromJson(response);
  }

  // ── GET /api/events/my ────────────────────────────────────────────────────

  Future<List<Event>> getMyEvents() async {
    final response = await _apiClient.getList('/events/my', requiresAuth: true);
    return response.map((json) => Event.fromJson(json)).toList();
  }

  // ── GET /api/events/{id} ──────────────────────────────────────────────────

  Future<Event> getEventById(int id) async {
    final response =
        await _apiClient.get('/events/$id', requiresAuth: true);
    return Event.fromJson(response);
  }

  // ── PUT /api/events/{id} ──────────────────────────────────────────────────

  Future<Event> updateEvent({
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
    bool removeEndDateTime = false, // true = explicitly clear end time
    double? ticketPrice,
    int? capacity,
    String? status,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (category != null) body['category'] = category;
    if (venue != null) body['venue'] = venue;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (registrationStartDateTime != null) {
      body['registrationStartDateTime'] =
          registrationStartDateTime.toIso8601String();
    }
    if (registrationEndDateTime != null) {
      body['registrationEndDateTime'] =
          registrationEndDateTime.toIso8601String();
    }
    if (startDateTime != null) {
      body['startDateTime'] = startDateTime.toIso8601String();
    }
    if (removeEndDateTime) {
      // Signal to backend: clear the end time
      body['removeEndDateTime'] = true;
      body['endDateTime'] = null;
    } else if (endDateTime != null) {
      body['endDateTime'] = endDateTime.toIso8601String();
    }
    if (ticketPrice != null) body['ticketPrice'] = ticketPrice;
    if (capacity != null) body['capacity'] = capacity;
    if (status != null) body['status'] = status;

    final response =
        await _apiClient.put('/events/$id', body, requiresAuth: true);
    return Event.fromJson(response);
  }

  // ── DELETE /api/events/{id} ───────────────────────────────────────────────

  Future<void> deleteEvent(int id) async {
    await _apiClient.delete('/events/$id', requiresAuth: true);
  }

  // ── POST /api/events/{id}/image ───────────────────────────────────────────

  Future<Event> uploadEventImage({
    required int eventId,
    required String filePath,
    required String mimeType,
  }) async {
    final response = await _apiClient.postMultipart(
      '/events/$eventId/image',
      fileField: 'image',
      filePath: filePath,
      mimeType: mimeType,
    );
    return Event.fromJson(response);
  }

  // ── DELETE /api/events/{id}/image ─────────────────────────────────────────

  Future<Event> removeEventImage(int eventId) async {
    final response = await _apiClient.deleteReturningBody(
      '/events/$eventId/image',
      requiresAuth: true,
    );
    return Event.fromJson(response);
  }

  // ── GET /api/events (discovery) ───────────────────────────────────────────

  Future<List<Event>> getEvents({
    String? keyword,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final params = <String, String>{};
    if (keyword != null && keyword.trim().isNotEmpty) {
      params['keyword'] = keyword.trim();
    }
    if (category != null && category.trim().isNotEmpty) {
      params['category'] = category.trim();
    }
    if (startDate != null) {
      params['startDate'] =
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-'
          '${startDate.day.toString().padLeft(2, '0')}';
    }
    if (endDate != null) {
      params['endDate'] =
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-'
          '${endDate.day.toString().padLeft(2, '0')}';
    }

    final query = params.isEmpty
        ? ''
        : '?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';

    final response =
        await _apiClient.getList('/events$query', requiresAuth: true);
    return response.map((json) => Event.fromJson(json)).toList();
  }
}
