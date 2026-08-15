class TicketType {
  final int id;
  final int eventId;
  final String name;
  final String? description;
  final double price;
  final int capacity;
  final int availableQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketType({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    required this.price,
    required this.capacity,
    required this.availableQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      capacity: json['capacity'],
      availableQuantity: json['availableQuantity'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'description': description,
      'price': price,
      'capacity': capacity,
      'availableQuantity': availableQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}