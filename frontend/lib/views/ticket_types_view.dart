import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../controllers/ticket_type_controller.dart';
import '../models/ticket_type.dart';

class TicketTypesView extends StatefulWidget {
  const TicketTypesView({super.key});

  @override
  State<TicketTypesView> createState() => _TicketTypesViewState();
}

class _TicketTypesViewState extends State<TicketTypesView> {
  late final TicketTypeController _controller;
  late final EventController _eventController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TicketTypeController>();
    _eventController = Get.find<EventController>();
    
    // Load ticket types for the selected event
    final event = _eventController.selectedEvent.value;
    if (event != null) {
      _controller.loadTicketTypes(event.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ticket Types'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateTicketTypeDialog(),
            tooltip: 'Add Ticket Type',
          ),
        ],
      ),
      body: Obx(() {
        final event = _eventController.selectedEvent.value;
        if (event == null) {
          return const Center(child: Text('Event not found.'));
        }

        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _controller.loadTicketTypes(event.id),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (_controller.ticketTypes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.confirmation_number_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No ticket types yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first ticket type to start selling tickets.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateTicketTypeDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Ticket Type'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadTicketTypes(event.id),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.ticketTypes.length,
            itemBuilder: (context, index) {
              final ticketType = _controller.ticketTypes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    ticketType.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ticketType.description != null) ...[
                        const SizedBox(height: 4),
                        Text(ticketType.description!,
                            style: const TextStyle(fontSize: 14)),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${ticketType.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Capacity: ${ticketType.capacity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            'Available: ${ticketType.availableQuantity}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditTicketTypeDialog(ticketType),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(ticketType),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showCreateTicketTypeDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final capacityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Ticket Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'e.g., Student, General, VIP',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₹) *',
                  hintText: '0',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity *',
                  hintText: '100',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: _controller.isSaving.value
                    ? null
                    : () => _createTicketType(
                          nameController.text.trim(),
                          descriptionController.text.trim(),
                          priceController.text.trim(),
                          capacityController.text.trim(),
                        ),
                child: _controller.isSaving.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add'),
              )),
        ],
      ),
    );
  }

  void _showEditTicketTypeDialog(TicketType ticketType) {
    final nameController = TextEditingController(text: ticketType.name);
    final descriptionController =
        TextEditingController(text: ticketType.description ?? '');
    final priceController =
        TextEditingController(text: ticketType.price.toStringAsFixed(0));
    final capacityController =
        TextEditingController(text: ticketType.capacity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Ticket Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price (₹) *'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity *'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: _controller.isSaving.value
                    ? null
                    : () => _updateTicketType(
                          ticketType.id,
                          nameController.text.trim(),
                          descriptionController.text.trim(),
                          priceController.text.trim(),
                          capacityController.text.trim(),
                        ),
                child: _controller.isSaving.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Update'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TicketType ticketType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket Type'),
        content: Text('Are you sure you want to delete "${ticketType.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: _controller.isDeleting.value
                    ? null
                    : () {
                        Get.back();
                        _deleteTicketType(ticketType.id);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: _controller.isDeleting.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete'),
              )),
        ],
      ),
    );
  }

  void _createTicketType(String name, String description, String price, String capacity) {
    if (name.isEmpty || price.isEmpty || capacity.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final event = _eventController.selectedEvent.value;
    if (event == null) return;

    final priceValue = double.tryParse(price);
    final capacityValue = int.tryParse(capacity);

    if (priceValue == null || priceValue < 0) {
      Get.snackbar('Error', 'Please enter a valid price.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (capacityValue == null || capacityValue <= 0) {
      Get.snackbar('Error', 'Please enter a valid capacity.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _controller.createTicketType(
      eventId: event.id,
      name: name,
      description: description.isEmpty ? null : description,
      price: priceValue,
      capacity: capacityValue,
    );
  }

  void _updateTicketType(int ticketTypeId, String name, String description, String price, String capacity) {
    if (name.isEmpty || price.isEmpty || capacity.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final event = _eventController.selectedEvent.value;
    if (event == null) return;

    final priceValue = double.tryParse(price);
    final capacityValue = int.tryParse(capacity);

    if (priceValue == null || priceValue < 0) {
      Get.snackbar('Error', 'Please enter a valid price.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (capacityValue == null || capacityValue <= 0) {
      Get.snackbar('Error', 'Please enter a valid capacity.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _controller.updateTicketType(
      eventId: event.id,
      ticketTypeId: ticketTypeId,
      name: name,
      description: description.isEmpty ? null : description,
      price: priceValue,
      capacity: capacityValue,
    );
  }

  void _deleteTicketType(int ticketTypeId) {
    final event = _eventController.selectedEvent.value;
    if (event == null) return;

    _controller.deleteTicketType(event.id, ticketTypeId);
  }
}