import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_image.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Event image ─────────────────────────────────────────────
            EventImageWidget(
              imageUrl: event.imageUrl,
              height: 160,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),

            // ── Event info ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: event.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(Icons.category, event.category),
                  const SizedBox(height: 4),
                  _InfoRow(
                    Icons.location_city,
                    '${event.venue}, ${event.city}',
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    Icons.calendar_today,
                    _formatDate(event.startDateTime),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _PillLabel(
                        label: '₹${event.ticketPrice.toStringAsFixed(0)}',
                        color: Colors.blue.shade50,
                        textColor: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      _PillLabel(
                        label:
                            '${event.availableTickets}/${event.capacity} seats',
                        color: Colors.green.shade50,
                        textColor: Colors.green.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day} ${_month(dt.month)} ${dt.year}  ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  String _month(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  String _pad(int v) => v.toString().padLeft(2, '0');
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'PUBLISHED':
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        break;
      case 'CANCELLED':
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
        break;
      default: // DRAFT
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _PillLabel(
      {required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
