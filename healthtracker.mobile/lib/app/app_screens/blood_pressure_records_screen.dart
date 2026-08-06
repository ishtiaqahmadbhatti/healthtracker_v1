import 'package:flutter/material.dart';
import '../app_models/blood_pressure_record.dart';
import '../app_database/db_helper.dart';
import 'blood_pressure_detail_screen.dart';

class BloodPressureRecordsScreen extends StatefulWidget {
  const BloodPressureRecordsScreen({super.key});

  @override
  State<BloodPressureRecordsScreen> createState() => _BloodPressureRecordsScreenState();
}

class _BloodPressureRecordsScreenState extends State<BloodPressureRecordsScreen> {
  List<BloodPressureRecord> _records = [];
  bool _isLoading = true;
  String _selectedDateFilter = 'All Time';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadAllRecords();
  }

  Future<void> _loadAllRecords() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllRecords();
    setState(() {
      _records = list;
      _isLoading = false;
    });
  }

  List<BloodPressureRecord> get _filteredRecords {
    if (_selectedDateFilter == 'All Time') {
      return _records;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_selectedDateFilter == 'This week') {
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      return _records.where((rec) => rec.date.isAfter(sevenDaysAgo)).toList();
    }
    if (_selectedDateFilter == 'This month') {
      return _records
          .where((rec) => rec.date.year == now.year && rec.date.month == now.month)
          .toList();
    }
    if (_selectedDateFilter == 'Date picker' && _selectedDateRange != null) {
      final start = DateTime(
        _selectedDateRange!.start.year,
        _selectedDateRange!.start.month,
        _selectedDateRange!.start.day,
      );
      final end = DateTime(
        _selectedDateRange!.end.year,
        _selectedDateRange!.end.month,
        _selectedDateRange!.end.day,
        23,
        59,
        59,
      );
      return _records
          .where(
            (rec) =>
                rec.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
                rec.date.isBefore(end.add(const Duration(seconds: 1))),
          )
          .toList();
    }
    return _records;
  }

  String _formatHistoryDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayStr = dt.day.toString().padLeft(2, '0');
    final monthStr = months[dt.month - 1];
    final yearStr = dt.year.toString();

    int hour = dt.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final hourStr = hour.toString().padLeft(2, '0');
    final minStr = dt.minute.toString().padLeft(2, '0');

    return "$dayStr $monthStr $yearStr, $hourStr:$minStr $period";
  }

  void _navigateToDetail(BloodPressureRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BloodPressureDetailScreen(
          record: record,
          onDeleteCompleted: () {
            _loadAllRecords();
          },
        ),
      ),
    ).then((_) => _loadAllRecords());
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Records',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFE53935)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Custom Date Filter Dropdown
                          _CustomDateFilterDropdown(
                            selectedFilter: _selectedDateFilter,
                            selectedDateRange: _selectedDateRange,
                            onSelectedFilterChanged: (newFilter) {
                              setState(() {
                                _selectedDateFilter = newFilter;
                                _selectedDateRange = null;
                              });
                            },
                            onDateRangePicked: (range) {
                              setState(() {
                                _selectedDateRange = range;
                                _selectedDateFilter = 'Date picker';
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 48.0),
                              child: Center(
                                child: Text(
                                  'No records found for the selected period.',
                                  style: TextStyle(color: Colors.black45, fontSize: 16),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final rec = filtered[index];
                                final info = rec.categoryInfo;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: info.color.withAlpha(22),
                                        blurRadius: 14,
                                        offset: const Offset(0, 4),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withAlpha(7),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      onTap: () => _navigateToDetail(rec),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            // Left Section: SYS / DIA Pill Badge
                                            Container(
                                              width: 74,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    info.color.withAlpha(24),
                                                    info.color.withAlpha(12),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: info.color.withAlpha(75), width: 1.5),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    rec.sys.toString(),
                                                    style: TextStyle(
                                                      color: info.color,
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 19,
                                                      height: 1.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 2,
                                                    width: 24,
                                                    color: info.color.withAlpha(90),
                                                    margin: const EdgeInsets.symmetric(vertical: 3),
                                                  ),
                                                  Text(
                                                    rec.dia.toString(),
                                                    style: TextStyle(
                                                      color: info.color,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      height: 1.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    'mmHg',
                                                    style: TextStyle(
                                                      color: info.color.withAlpha(200),
                                                      fontSize: 9.5,
                                                      fontWeight: FontWeight.w800,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 14),

                                            // Right Section: Structured for zero truncation
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Line 1: Category Status Badge
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: info.color.withAlpha(22),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 7,
                                                          height: 7,
                                                          decoration: BoxDecoration(
                                                            color: info.color,
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          info.label,
                                                          style: TextStyle(
                                                            color: info.color,
                                                            fontSize: 12.5,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),

                                                  // Line 2: Pulse (BPM) on Left & Tag on Right
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.favorite_rounded,
                                                            color: Color(0xFFE53935),
                                                            size: 15,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            '${rec.pul}',
                                                            style: const TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 14.5,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 3),
                                                          Text(
                                                            'BPM',
                                                            style: TextStyle(
                                                              color: Colors.grey[500],
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (rec.tag != 'None' && rec.tag.isNotEmpty)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[100],
                                                            borderRadius: BorderRadius.circular(6),
                                                            border: Border.all(color: Colors.grey[300]!, width: 0.8),
                                                          ),
                                                          child: Text(
                                                            rec.tag,
                                                            style: TextStyle(
                                                              color: Colors.grey[700],
                                                              fontSize: 10.5,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),

                                                  // Line 3: Complete Date & Time
                                                  Text(
                                                    _formatHistoryDate(rec.date),
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Inline Expandable Date Filter Dropdown Widget
class _CustomDateFilterDropdown extends StatefulWidget {
  final String selectedFilter;
  final DateTimeRange? selectedDateRange;
  final ValueChanged<String> onSelectedFilterChanged;
  final ValueChanged<DateTimeRange?> onDateRangePicked;

  const _CustomDateFilterDropdown({
    required this.selectedFilter,
    required this.selectedDateRange,
    required this.onSelectedFilterChanged,
    required this.onDateRangePicked,
  });

  @override
  State<_CustomDateFilterDropdown> createState() => _CustomDateFilterDropdownState();
}

class _CustomDateFilterDropdownState extends State<_CustomDateFilterDropdown> {
  bool _isExpanded = false;

  String _getDisplayTitle() {
    if (widget.selectedFilter == 'Date picker' && widget.selectedDateRange != null) {
      final start = widget.selectedDateRange!.start;
      final end = widget.selectedDateRange!.end;
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}";
    }
    return widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Trigger Button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Color(0xFFE53935), size: 22),
                      const SizedBox(width: 12),
                      Text(
                        _getDisplayTitle(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Options List
          if (_isExpanded) ...[
            Divider(height: 1, color: Colors.grey[200]),
            const SizedBox(height: 6),
            _buildOptionItem(
              value: 'This week',
              icon: Icons.date_range_rounded,
              label: 'This week',
            ),
            _buildOptionItem(
              value: 'This month',
              icon: Icons.calendar_month_rounded,
              label: 'This month',
            ),
            _buildOptionItem(
              value: 'All Time',
              icon: Icons.all_inclusive_rounded,
              label: 'All Time',
            ),
            _buildOptionItem(
              value: 'Date picker',
              icon: Icons.today_rounded,
              label: 'Date picker',
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String value,
    required IconData icon,
    required String label,
  }) {
    final isSelected = widget.selectedFilter == value;

    return InkWell(
      onTap: () async {
        setState(() {
          _isExpanded = false;
        });

        if (value == 'Date picker') {
          final DateTimeRange? picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  scaffoldBackgroundColor: Colors.white,
                  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFFE53935),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                    secondary: Color(0xFFE53935),
                    onSecondary: Colors.white,
                    surfaceContainerHigh: Colors.white,
                    surfaceContainerHighest: Colors.white,
                    onSurfaceVariant: Colors.black87,
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.white),
                    actionsIconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  datePickerTheme: DatePickerThemeData(
                    headerBackgroundColor: const Color(0xFFE53935),
                    headerForegroundColor: Colors.white,
                    rangePickerHeaderBackgroundColor: const Color(0xFFE53935),
                    rangePickerHeaderForegroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    dayStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                    rangeSelectionBackgroundColor: const Color(0xFFE53935).withAlpha(30),
                    rangeSelectionOverlayColor: WidgetStateProperty.all(const Color(0xFFE53935).withAlpha(20)),
                    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFFE53935);
                      }
                      return null;
                    }),
                    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.black87;
                    }),
                    todayForegroundColor: WidgetStateProperty.all(const Color(0xFFE53935)),
                    todayBorder: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            widget.onDateRangePicked(picked);
          }
        } else {
          widget.onSelectedFilterChanged(value);
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935).withAlpha(18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE53935) : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFE53935) : Colors.black87,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFE53935),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
