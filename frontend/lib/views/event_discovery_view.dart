import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';
import '../widgets/event_card.dart';

class EventDiscoveryView extends StatefulWidget {
  const EventDiscoveryView({super.key});

  @override
  State<EventDiscoveryView> createState() => _EventDiscoveryViewState();
}

class _EventDiscoveryViewState extends State<EventDiscoveryView> {
  late final TextEditingController _searchController;
  late final DiscoveryController _c;

  static const List<String> _categories = [
    'Technology', 'Music', 'Sports', 'Entertainment', 'Education',
    'Business', 'Art', 'Food & Drink', 'Health', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _c = Get.find<DiscoveryController>();
    _searchController = TextEditingController(text: _c.searchKeyword.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Events'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Obx(() => _c.hasActiveFilters
              ? IconButton(
                  icon: const Icon(Icons.filter_alt_off),
                  tooltip: 'Clear Filters',
                  onPressed: () {
                    _c.clearFilters();
                    _searchController.clear();
                  },
                )
              : const SizedBox.shrink()),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filter',
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => _c.searchKeyword.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _c.onSearchChanged('');
                        },
                      )
                    : const SizedBox.shrink()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _c.onSearchChanged,
            ),
          ),

          // ── Active filter chips ─────────────────────────────────────────
          Obx(() {
            final chips = <Widget>[];

            if (_c.selectedCategory.value.isNotEmpty) {
              chips.add(_FilterChip(
                label: _c.selectedCategory.value,
                onDeleted: () {
                  _c.selectedCategory.value = '';
                  _c.loadEvents();
                },
              ));
            }

            final s = _c.startDate.value;
            final e = _c.endDate.value;
            if (s != null || e != null) {
              final label = s != null && e != null
                  ? '${_fmtDate(s)} – ${_fmtDate(e)}'
                  : s != null
                      ? 'From ${_fmtDate(s)}'
                      : 'Until ${_fmtDate(e!)}';
              chips.add(_FilterChip(
                label: label,
                onDeleted: () {
                  _c.startDate.value = null;
                  _c.endDate.value = null;
                  _c.loadEvents();
                },
              ));
            }

            if (chips.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: chips),
              ),
            );
          }),

          // ── Event list ──────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_c.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _c.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _c.loadEvents,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (_c.events.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          _c.hasActiveFilters
                              ? 'No events found'
                              : 'No upcoming events available.',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _c.hasActiveFilters
                              ? 'Try changing your search or filters.'
                              : 'Check back later for new events.',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        if (_c.hasActiveFilters) ...[
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: () {
                              _c.clearFilters();
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Filters'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _c.loadEvents,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: _c.events.length,
                  itemBuilder: (context, index) {
                    final event = _c.events[index];
                    return EventCard(
                      event: event,
                      onTap: () => _c.openEventDetails(event),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Filter bottom sheet ───────────────────────────────────────────────────

  void _showFilterSheet(BuildContext context) {
    String tempCategory = _c.selectedCategory.value;
    DateTime? tempStart = _c.startDate.value;
    DateTime? tempEnd   = _c.endDate.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      const Text('Filter Events',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _c.clearFilters();
                          _searchController.clear();
                        },
                        child: const Text('Clear All',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  const Text('Category',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: tempCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('All Categories')),
                      ..._categories.map(
                          (c) => DropdownMenuItem(value: c, child: Text(c))),
                    ],
                    onChanged: (val) =>
                        setSheetState(() => tempCategory = val ?? ''),
                  ),
                  const SizedBox(height: 16),

                  // Date range
                  const Text('Date Range',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: tempStart != null
                              ? _fmtDate(tempStart!)
                              : 'Start Date',
                          icon: Icons.calendar_today,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: tempStart ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setSheetState(() => tempStart = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateButton(
                          label: tempEnd != null
                              ? _fmtDate(tempEnd!)
                              : 'End Date',
                          icon: Icons.calendar_month,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate:
                                  tempEnd ?? (tempStart ?? DateTime.now()),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setSheetState(() => tempEnd = picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (tempStart != null || tempEnd != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setSheetState(() {
                          tempStart = null;
                          tempEnd = null;
                        }),
                        child: const Text('Clear dates',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _c.selectedCategory.value = tempCategory;
                      _c.startDate.value = tempStart;
                      _c.endDate.value   = tempEnd;
                      _c.loadEvents();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Apply Filters',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static String _fmtDate(DateTime d) {
    const m = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${m[d.month]} ${d.year}';
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;
  const _FilterChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
        backgroundColor: Colors.blue.shade50,
        side: BorderSide(color: Colors.blue.shade200),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _DateButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
