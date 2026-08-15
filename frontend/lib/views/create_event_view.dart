import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/event_controller.dart';
import '../services/api_client.dart';
import '../widgets/image_picker_widget.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();

  // Registration period (both required)
  DateTime? _regStart;
  DateTime? _regEnd;

  // Event schedule
  DateTime? _eventStart;
  DateTime? _eventEnd; // optional

  static const List<String> _categories = [
    'Technology', 'Music', 'Sports', 'Entertainment', 'Education',
    'Business', 'Art', 'Food & Drink', 'Health', 'Other',
  ];
  String _selectedCategory = 'Technology';

  XFile? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDt(
    BuildContext context, {
    required void Function(DateTime) onPicked,
    DateTime? initial,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context, // ignore: use_build_context_synchronously
      initialTime:
          initial != null ? TimeOfDay.fromDateTime(initial) : TimeOfDay.now(),
    );
    if (time == null) return;
    onPicked(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  String _fmt(DateTime dt) {
    const m = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${m[dt.month]} ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Registration period required
    if (_regStart == null) {
      _snack('Please select registration start date & time'); return;
    }
    if (_regEnd == null) {
      _snack('Please select registration end date & time'); return;
    }
    if (!_regEnd!.isAfter(_regStart!)) {
      _snack('Registration end must be after registration start'); return;
    }

    // Event start required
    if (_eventStart == null) {
      _snack('Please select event start date & time'); return;
    }
    if (_eventStart!.isBefore(_regEnd!)) {
      _snack('Event start must be on or after registration end'); return;
    }

    // Event end optional but validated if set
    if (_eventEnd != null && !_eventEnd!.isAfter(_eventStart!)) {
      _snack('Event end must be after event start'); return;
    }

    Get.find<EventController>().createEvent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      venue: _venueController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      registrationStartDateTime: _regStart!,
      registrationEndDateTime: _regEnd!,
      startDateTime: _eventStart!,
      endDateTime: _eventEnd,
      ticketPrice: double.parse(_priceController.text.trim()),
      capacity: int.parse(_capacityController.text.trim()),
      imageFilePath: _pickedImage?.path,
      imageMimeType: _pickedImage != null ? _mime(_pickedImage!.path) : null,
    );
  }

  void _snack(String msg) =>
      Get.snackbar('Validation', msg, snackPosition: SnackPosition.BOTTOM);

  String _mime(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Image ────────────────────────────────────────────
                _section('Event Image'),
                const SizedBox(height: 8),
                ImagePickerWidget(
                  pickedFile: _pickedImage,
                  onPicked: (f) => setState(() => _pickedImage = f),
                  onRemoved: () => setState(() => _pickedImage = null),
                  staticBaseUrl: ApiClient.staticBaseUrl,
                ),
                const SizedBox(height: 20),

                // ── Event Details ─────────────────────────────────────
                _section('Event Details'),
                const SizedBox(height: 8),
                _textField(_titleController, 'Title *', Icons.title,
                    validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title is required';
                  if (v.trim().length < 3) return 'Min 3 characters';
                  return null;
                }),
                const SizedBox(height: 12),
                _textField(
                  _descriptionController, 'Description *', Icons.description,
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((c) =>
                          DropdownMenuItem<String>(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedCategory = v);
                  },
                ),

                // ── Location ──────────────────────────────────────────
                const SizedBox(height: 20),
                _section('Location'),
                const SizedBox(height: 8),
                _textField(_venueController, 'Venue *', Icons.place,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Venue is required'
                        : null),
                const SizedBox(height: 12),
                _textField(_addressController, 'Address *', Icons.location_on,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Address is required'
                        : null),
                const SizedBox(height: 12),
                _textField(_cityController, 'City *', Icons.location_city,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'City is required'
                        : null),

                // ── Registration Period ───────────────────────────────
                const SizedBox(height: 20),
                _section('Registration Period'),
                const SizedBox(height: 4),
                const Text(
                  'The window during which attendees can register.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                _DtField(
                  label: 'Registration Start *',
                  value: _regStart != null ? _fmt(_regStart!) : null,
                  onTap: () => _pickDt(context,
                      initial: _regStart,
                      onPicked: (d) => setState(() => _regStart = d)),
                ),
                const SizedBox(height: 12),
                _DtField(
                  label: 'Registration End *',
                  value: _regEnd != null ? _fmt(_regEnd!) : null,
                  onTap: () => _pickDt(context,
                      initial: _regEnd,
                      onPicked: (d) => setState(() => _regEnd = d)),
                ),

                // ── Event Schedule ────────────────────────────────────
                const SizedBox(height: 20),
                _section('Event Schedule'),
                const SizedBox(height: 4),
                const Text(
                  'When the actual event takes place.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                _DtField(
                  label: 'Event Start *',
                  value: _eventStart != null ? _fmt(_eventStart!) : null,
                  onTap: () => _pickDt(context,
                      initial: _eventStart,
                      onPicked: (d) => setState(() => _eventStart = d)),
                ),
                const SizedBox(height: 12),
                // Optional end time
                if (_eventEnd == null)
                  OutlinedButton.icon(
                    onPressed: () => _pickDt(context,
                        initial: _eventStart,
                        onPicked: (d) => setState(() => _eventEnd = d)),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Event End Time (Optional)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _DtField(
                          label: 'Event End (Optional)',
                          value: _fmt(_eventEnd!),
                          onTap: () => _pickDt(context,
                              initial: _eventEnd,
                              onPicked: (d) =>
                                  setState(() => _eventEnd = d)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: 'Remove end time',
                        onPressed: () => setState(() => _eventEnd = null),
                      ),
                    ],
                  ),

                // ── Tickets ───────────────────────────────────────────
                const SizedBox(height: 20),
                _section('Tickets'),
                const SizedBox(height: 8),
                _textField(
                  _priceController, 'Ticket Price (₹) *',
                  Icons.currency_rupee,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Price is required';
                    final d = double.tryParse(v.trim());
                    if (d == null) return 'Enter a valid number';
                    if (d < 0) return 'Price must not be negative';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _textField(
                  _capacityController, 'Capacity *', Icons.people,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Capacity is required';
                    final i = int.tryParse(v.trim());
                    if (i == null) return 'Enter a valid number';
                    if (i <= 0) return 'Must be greater than zero';
                    return null;
                  },
                ),

                const SizedBox(height: 28),
                Obx(() => ElevatedButton(
                      onPressed: ctrl.isSaving.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: ctrl.isSaving.value
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Create Event'),
                    )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String label) => Text(
        label,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
      );

  Widget _textField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines > 1,
        ),
        validator: validator,
      );
}

class _DtField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;
  const _DtField({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.access_time),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          value ?? 'Tap to select',
          style: TextStyle(color: value != null ? Colors.black87 : Colors.grey),
        ),
      ),
    );
  }
}
