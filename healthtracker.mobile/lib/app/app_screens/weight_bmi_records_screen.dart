import 'package:flutter/material.dart';
import '../app_models/weight_bmi_record.dart';
import '../app_database/db_helper.dart';
import 'weight_bmi_detail_screen.dart';

class WeightBmiRecordsScreen extends StatefulWidget {
  const WeightBmiRecordsScreen({super.key});

  @override
  State<WeightBmiRecordsScreen> createState() => _WeightBmiRecordsScreenState();
}

class _WeightBmiRecordsScreenState extends State<WeightBmiRecordsScreen> {
  List<WeightBmiRecord> _records = [];
  bool _isLoading = true;
  String _selectedDateFilter = 'All Time';
  DateTimeRange? _selectedDateRange;

  final List<String> _dateFilters = ['All Time', 'This week', 'This month', 'Date picker'];

  @override
  void initState() {
    super.initState();
    _loadAllRecords();
  }

  Future<void> _loadAllRecords() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllWeightBmiRecords();
    setState(() {
      _records = list;
      _isLoading = false;
    });
  }

  List<WeightBmiRecord> get _filteredRecords {
    List<WeightBmiRecord> result = List.from(_records);

    if (_selectedDateFilter == 'This week') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      result = result.where((rec) => rec.date.isAfter(sevenDaysAgo)).toList();
    } else if (_selectedDateFilter == 'This month') {
      final now = DateTime.now();
      result = result
          .where((rec) => rec.date.year == now.year && rec.date.month == now.month)
          .toList();
    } else if (_selectedDateFilter == 'Date picker' && _selectedDateRange != null) {
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
      result = result
          .where(
            (rec) =>
                rec.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
                rec.date.isBefore(end.add(const Duration(seconds: 1))),
          )
          .toList();
    }

    return result;
  }

  String _formatHistoryDate(DateTime dt) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayName = days[dt.weekday % 7];
    final dayStr = dt.day.toString().padLeft(2, '0');
    final monthStr = months[dt.month - 1];
    final yearStr = dt.year.toString();

    int hour = dt.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final hourStr = hour.toString().padLeft(2, '0');
    final minStr = dt.minute.toString().padLeft(2, '0');

    return "$dayName, $dayStr $monthStr $yearStr, $hourStr:$minStr $period";
  }

  void _navigateToDetail(WeightBmiRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeightBmiDetailScreen(
          record: record,
          onDeleteCompleted: () {
            _loadAllRecords();
          },
        ),
      ),
    ).then((_) => _loadAllRecords());
  }

  void _showDateFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _dateFilters.map((df) {
            final isSelected = df == _selectedDateFilter;
            return ListTile(
              title: Text(
                df,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFEF5350) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFFEF5350)) : null,
              onTap: () async {
                Navigator.of(ctx).pop();
                if (df == 'Date picker') {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) => Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFFEF5350)),
                      ),
                      child: child!,
                    ),
                  );
                  if (range != null) {
                    setState(() {
                      _selectedDateRange = range;
                      _selectedDateFilter = 'Date picker';
                    });
                  }
                } else {
                  setState(() {
                    _selectedDateFilter = df;
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

    return Scaffold(
      backgroundColor: const Color(0xFFEF5350),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5350),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Weight & BMI Records',
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
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFEF5350)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Filter Bar
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _showDateFilterMenu,
                              child: Container(
                                height: 44,
                                width: 180,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, color: Color(0xFFEF5350), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedDateFilter,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 48.0),
                              child: Center(
                                child: Text(
                                  'No records found for the selected filter.',
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
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: info.color.withAlpha(20),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () => _navigateToDetail(rec),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          // Value Ring Display (BMI)
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: info.color, width: 3.5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                rec.bmi.toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Record Info Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _formatHistoryDate(rec.date),
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  info.label,
                                                  style: TextStyle(
                                                    color: info.color,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "Weight: ${rec.weightKg.toStringAsFixed(1)} (kg)",
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.black26,
                                            size: 24,
                                          ),
                                        ],
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
