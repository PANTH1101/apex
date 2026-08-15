import '../models/ticket_type.dart';
import 'api_client.dart';

class TicketTypeService {
  final ApiClient _apiClient = ApiClient();

  // ── GET /api/events/{eventId}/ticket-types ────────────────────────────────

  Future<List<TicketType>> getTicketTypes(int eventId) async {
    final response = await _apiClient.getList('/events/$eventId/ticket-types', requiresAuth: true);
    return response.map((json) => TicketType.fromJson(json)).toList();
  }

  // ── GET /api/events/{eventId}/ticket-types/{ticketTypeId} ──────────────────

  Future<TicketType> getTicketType(int eventId, int ticketTypeId) async {
    final response = await _apiClient.get('/events/$eventId/ticket-types/$ticketTypeId', requiresAuth: true);
    return TicketType.fromJson(response);
  }

  // ── POST /api/events/{eventId}/ticket-types ───────────────────────────────

  Future<TicketType> createTicketType({
    required int eventId,
    required String name,
    String? description,
    required double price,
    required int capacity,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'capacity': capacity,
    };
    final response = await _apiClient.post('/events/$eventId/ticket-types', body, requiresAuth: true);
    return TicketType.fromJson(response);
  }

  // ── PUT /api/events/{eventId}/ticket-types/{ticketTypeId} ──────────────────

  Future<TicketType> updateTicketType({
    required int eventId,
    required int ticketTypeId,
    String? name,
    String? description,
    double? price,
    int? capacity,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (price != null) body['price'] = price;
    if (capacity != null) body['capacity'] = capacity;

    final response = await _apiClient.put('/events/$eventId/ticket-types/$ticketTypeId', body, requiresAuth: true);
    return TicketType.fromJson(response);
  }

  // ── DELETE /api/events/{eventId}/ticket-types/{ticketTypeId} ───────────────

  Future<void> deleteTicketType(int eventId, int ticketTypeId) async {
    await _apiClient.delete('/events/$eventId/ticket-types/$ticketTypeId', requiresAuth: true);
  }
}