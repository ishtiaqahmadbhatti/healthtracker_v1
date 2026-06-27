import 'package:flutter/material.dart';
import '../app_models/health_record.dart';

class BaseDetailScreen extends StatefulWidget {
  final String title;
  final String defaultDateFilter;
  final Widget? secondaryFilter;
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;
  final String? emptyStateMessage;
  final bool showClipboardIcon;
  final ValueChanged<String>? onDateFilterChanged;

  const BaseDetailScreen({
    super.key,
    required this.title,
    required this.defaultDateFilter,
    this.secondaryFilter,
    required this.records,
    required this.onAddRecordTap,
    this.emptyStateMessage,
    this.showClipboardIcon = true,
    this.onDateFilterChanged,
  });

  @override
  State<BaseDetailScreen> createState() => _BaseDetailScreenState();
}

class _BaseDetailScreenState extends State<BaseDetailScreen> {
  late String _selectedDateFilter;

  @override
  void initState() {
    super.initState();
    _selectedDateFilter = widget.defaultDateFilter;
  }

  @override
  Widget build(BuildContext context) {
    // Filter records by type
    final filteredRecords = widget.records.where((r) => r.type == widget.title).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header background (vibrant red)
      body: Column(
        children: [
          // AppBar / Header Section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.alarm_rounded, color: Colors.white, size: 28),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reminders for ${widget.title} coming soon!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Main Body Panel
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey panel
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Date Filter Dropdown
                    CustomDateDropdown(
                      value: _selectedDateFilter,
                      items: const ['This week', 'This month', 'All Time', 'Date picker'],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDateFilter = newValue;
                        });
                        if (widget.onDateFilterChanged != null) {
                          widget.onDateFilterChanged!(newValue);
                        }
                      },
                    ),
                    if (widget.secondaryFilter != null) ...[
                      const SizedBox(height: 16),
                      widget.secondaryFilter!,
                    ],
                    const SizedBox(height: 48),

                    // Conditional Content (Empty State vs History List)
                    filteredRecords.isEmpty
                        ? _buildEmptyState()
                        : _buildHistoryList(filteredRecords),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showClipboardIcon) ...[
          _buildClipboardGraphic(),
          const SizedBox(height: 24),
        ],
        Text(
          widget.emptyStateMessage ?? 'There is no data yet',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 36),
        _buildAddRecordButton(),
      ],
    );
  }

  Widget _buildHistoryList(List<HealthRecord> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'History Logs',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${items.length} records',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final record = items[index];
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: record.iconColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    record.icon,
                    color: record.iconColor,
                  ),
                ),
                title: Text(
                  '${record.value} ${record.unit}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: record.iconColor,
                  ),
                ),
                subtitle: Text(
                  'Logged on ${record.date.day}/${record.date.month} at ${record.date.hour.toString().padLeft(2, '0')}:${record.date.minute.toString().padLeft(2, '0')}'
                  '${record.note.isNotEmpty ? '\nNote: ${record.note}' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Center(child: _buildAddRecordButton()),
      ],
    );
  }

  Widget _buildAddRecordButton() {
    return GestureDetector(
      onTap: widget.onAddRecordTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF8A65),
              Color(0xFFE53935),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Text(
          'Add record now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildClipboardGraphic() {
    return SizedBox(
      width: 100,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Clipboard base (Yellow)
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFFCA28), // Warm yellow
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // White paper inside
          Positioned(
            top: 14,
            child: Container(
              width: 68,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  return Container(
                    height: 2,
                    color: Colors.grey[200],
                  );
                }),
              ),
            ),
          ),
          // Clip on top
          Positioned(
            top: 2,
            child: Container(
              width: 32,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDateDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const CustomDateDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CustomDateDropdown> createState() => _CustomDateDropdownState();
}

class _CustomDateDropdownState extends State<CustomDateDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected item header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    color: Colors.black87,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded items
          if (_isExpanded) ...[
            Divider(height: 1, color: Colors.grey[200]),
            ...widget.items.map((item) {
              return GestureDetector(
                onTap: () {
                  widget.onChanged(item);
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 12),
                  color: Colors.transparent,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == widget.value ? const Color(0xFFE53935) : Colors.black87,
                      fontSize: 16,
                      fontWeight: item == widget.value ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
