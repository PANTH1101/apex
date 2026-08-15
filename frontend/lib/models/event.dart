class Event {
  final int id;
  final int organizerId;
  final String organizerName;
  final String title;
  final String description;
  final String category;
  final String venue;
  final String address;
  final String city;

  // Registration period — both required
  final DateTime registrationStartDateTime;
  final DateTime registrationEndDateTime;

  // Event schedule — start required, end optional
  final DateTime startDateTime;
  final DateTime? endDateTime; // null = no end time specified

  final double ticketPrice;
  final int capacity;
  final int availableTickets;
  final String status;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.organizerId,
    required this.organizerName,
    required this.title,
    required this.description,
    required this.category,
    required this.venue,
    required this.address,
    required this.city,
    required this.registrationStartDateTime,
    required this.registrationEndDateTime,
    required this.startDateTime,
    this.endDateTime,
    required this.ticketPrice,
    required this.capacity,
    required this.availableTickets,
    required this.status,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      organizerId: json['organizerId'],
      organizerName: json['organizerName'] ?? '',
      title: json['title'],
      description: json['description'],
      category: json['category'],
      venue: json['venue'],
      address: json['address'],
      city: json['city'],
      registrationStartDateTime:
          DateTime.parse(json['registrationStartDateTime']),
      registrationEndDateTime:
          DateTime.parse(json['registrationEndDateTime']),
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'])
          : null,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      capacity: json['capacity'],
      availableTickets: json['availableTickets'],
      status: json['status'],
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'address': address,
      'city': city,
      'registrationStartDateTime': registrationStartDateTime.toIso8601String(),
      'registrationEndDateTime': registrationEndDateTime.toIso8601String(),
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'ticketPrice': ticketPrice,
      'capacity': capacity,
      'availableTickets': availableTickets,
      'status': status,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
