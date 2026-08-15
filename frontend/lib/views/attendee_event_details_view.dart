import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';
import '../widgets/event_image.dart';

class AttendeeEventDetailsView extends GetView<DiscoveryController> {
  const AttendeeEventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final event = controller.selectedEvent.value;

      if (event == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Event Details')),
          body: const Center(child: Text('Event not found.')),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Event Details'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Event image ──────────────────────────────────────────
              EventImageWidget(imageUrl: event.imageUrl, height: 220),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(event.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(event.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // Basic info
                    _Row(Icons.description, 'Description', event.description),
                    _Row(Icons.category, 'Category', event.category),
                    _Row(Icons.place, 'Venue', event.venue),
                    _Row(Icons.location_on, 'Address', event.address),
                    _Row(Icons.location_city, 'City', event.city),
                    const Divider(),

                    // Registration period
                    _sectionLabel('Registration Period'),
                    const SizedBox(height: 4),
                    _Row(Icons.how_to_reg, 'Opens',
                        _fmtDt(event.registrationStartDateTime)),
                    _Row(Icons.event_busy, 'Closes',
                        _fmtDt(event.registrationEndDateTime)),
                    const Divider(),

                    // Event schedule
                    _sectionLabel('Event Schedule'),
                    const SizedBox(height: 4),
                    _Row(Icons.play_circle_outline, 'Start',
                        _fmtDt(event.startDateTime)),
                    // End row only if end time exists
                    if (event.endDateTime != null)
                      _Row(Icons.stop_circle_outlined, 'End',
                          _fmtDt(event.endDateTime!)),
                    const Divider(),

                    // Tickets
                    _Row(Icons.currency_rupee, 'Ticket Price',
                        '₹${event.ticketPrice.toStringAsFixed(2)}'),
                    _Row(Icons.people, 'Capacity', '${event.capacity}'),
                    _Row(Icons.confirmation_number, 'Available Tickets',
                        '${event.availableTickets}'),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _fmtDt(DateTime dt) {
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = dt.hour > 12
        ? dt.hour - 12
        : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${m[dt.month]} ${dt.year}  $h:$min $ampm';
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 0.5)),
      );
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'PUBLISHED':
        bg = Colors.green.shade100; fg = Colors.green.shade800;
        break;
      case 'CANCELLED':
        bg = Colors.red.shade100; fg = Colors.red.shade800;
        break;
      default:
        bg = Colors.orange.shade100; fg = Colors.orange.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13, color: fg)),
    );
  }
}
