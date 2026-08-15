import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/event_image.dart';

class OrganizerEventDetailsView extends GetView<EventController> {
  const OrganizerEventDetailsView({super.key});

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
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () => Get.toNamed(AppRoutes.editEvent),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, event.id),
            ),
          ],
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
                    // Only show end row when end time is set
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
                    const Divider(),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.editEvent),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Event'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.ticketTypes),
                            icon: const Icon(Icons.confirmation_number),
                            label: const Text('Ticket Types'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Delete button - separate row
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton.icon(
                            onPressed: controller.isDeleting.value
                                ? null
                                : () => _confirmDelete(context, event.id),
                            icon: const Icon(Icons.delete),
                            label: controller.isDeleting.value
                                ? const SizedBox(
                                    height: 18, width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white))
                                : const Text('Delete Event'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, int eventId) {
    Get.dialog(AlertDialog(
      title: const Text('Delete Event'),
      content: const Text(
          'Are you sure you want to delete this event? This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            controller.deleteEvent(eventId);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          child: const Text('Delete'),
        ),
      ],
    ));
  }

  String _fmtDt(DateTime dt) {
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${m[dt.month]} ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
