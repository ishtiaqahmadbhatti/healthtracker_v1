import 'dart:math';
import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/blood_sugar_record.dart';
import '../app_database/db_helper.dart';
import 'blood_sugar_add_record_screen.dart';
import 'blood_sugar_detail_screen.dart';
import 'blood_sugar_records_screen.dart';
import 'alarm_screen.dart';

class BloodSugarScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;
  final Function(HealthRecord)? onRecordAdded;

  const BloodSugarScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
    this.onRecordAdded,
  });

  @override
  State<BloodSugarScreen> createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  List<BloodSugarRecord> _dbSugarRecords = [];
  bool _isLoading = true;

  String _selectedDateFilter = 'This month'; // 'This week', 'This month', 'All Time', 'Date picker'
  String _selectedStateFilter = 'All type';  // 'All type', 'Default', 'Fasting', etc.
  DateTimeRange? _customDateRange;

  final List<String> _dateFilters = ['This week', 'This month', 'All Time', 'Date picker'];
  final List<String> _stateFilters = [
    'All type',
    'Default',
    'Fasting',
    'Before a meal',
    'After a meal (1h)',
    'After a meal (2h)',
    'Asleep',
    'Before Exercise',
    'After exercise'
  ];

  @override
  void initState() {
    super.initState();
    _loadLocalRecords();
  }

  Future<void> _loadLocalRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.getAllSugarRecords();
    setState(() {
      _dbSugarRecords = records;
      _isLoading = false;
    });
  }

  Future<void> _openAddRecordScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BloodSugarAddRecordScreen(
          onSave: (rec) {
            if (widget.onRecordAdded != null) {
              widget.onRecordAdded!(rec);
            }
          },
        ),
      ),
    );

    if (result != null) {
      _loadLocalRecords();
    }
  }

  void _navigateToDetail(BloodSugarRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BloodSugarDetailScreen(
          record: record,
          onDeleteCompleted: _loadLocalRecords,
        ),
      ),
    );
  }

  Future<void> _navigateToAllRecordsScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BloodSugarRecordsScreen(),
      ),
    );
    _loadLocalRecords();
  }

  // Filter logic
  List<BloodSugarRecord> get _filteredRecords {
    List<BloodSugarRecord> result = List.from(_dbSugarRecords);

    // State filter
    if (_selectedStateFilter != 'All type') {
      result = result.where((r) => r.state == _selectedStateFilter).toList();
    }

    // Date filter
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedDateFilter == 'This week') {
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      result = result.where((r) => r.date.isAfter(sevenDaysAgo)).toList();
    } else if (_selectedDateFilter == 'This month') {
      result = result.where((r) => r.date.year == now.year && r.date.month == now.month).toList();
    } else if (_selectedDateFilter == 'Date picker' && _customDateRange != null) {
      final start = DateTime(_customDateRange!.start.year, _customDateRange!.start.month, _customDateRange!.start.day);
      final end = DateTime(_customDateRange!.end.year, _customDateRange!.end.month, _customDateRange!.end.day, 23, 59, 59);
      result = result.where((r) => r.date.isAfter(start.subtract(const Duration(seconds: 1))) && r.date.isBefore(end.add(const Duration(seconds: 1)))).toList();
    }

    return result;
  }

  // Calculations
  double get _averageVal {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double sum = 0;
    for (var r in list) {
      sum += r.value;
    }
    return sum / list.length;
  }

  double get _maxVal {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double maxV = 0.0;
    for (var r in list) {
      if (r.value > maxV) maxV = r.value;
    }
    return maxV;
  }

  double get _minVal {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double minV = double.infinity;
    for (var r in list) {
      if (r.value < minV) minV = r.value;
    }
    return minV == double.infinity ? 0.0 : minV;
  }

  double get _latestVal {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    return list.first.value;
  }

  String get _currentUnit {
    if (_filteredRecords.isNotEmpty) {
      return _filteredRecords.first.unit;
    }
    return 'mg/dL';
  }

  String _formatHistoryDate(DateTime date) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final dayName = days[date.weekday % 7];
    final dayNum = date.day.toString().padLeft(2, '0');
    final monthStr = months[date.month - 1];

    final hourInt = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final hourStr = hourInt.toString().padLeft(2, '0');
    final minStr = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return "$dayName, $dayNum $monthStr, $hourStr:$minStr $period";
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
                      _customDateRange = range;
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

  void _showStateFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _stateFilters.map((st) {
            final isSelected = st == _selectedStateFilter;
            return ListTile(
              title: Text(
                st,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFEF5350) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFFEF5350)) : null,
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _selectedStateFilter = st;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5350), // Header red color
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Blood Sugar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.alarm_rounded, color: Colors.white, size: 26),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const AlarmScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Light Body Panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFEF5350)))
                    : _dbSugarRecords.isEmpty
                        ? _buildEmptyState()
                        : Stack(
                            children: [
                              SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                                child: Column(
                                  children: [
                                    // 1. Filters Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: _showDateFilterMenu,
                                            child: Container(
                                              height: 44,
                                              padding: const EdgeInsets.symmetric(horizontal: 14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(22),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withAlpha(6),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87, size: 22),
                                                  const SizedBox(width: 6),
                                                  Flexible(
                                                    child: Text(
                                                      _selectedDateFilter,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: _showStateFilterMenu,
                                            child: Container(
                                              height: 44,
                                              padding: const EdgeInsets.symmetric(horizontal: 14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(22),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withAlpha(6),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      _selectedStateFilter,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87, size: 22),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // 2. Average Arc Gauge Card
                                    _buildAverageGaugeCard(),
                                    const SizedBox(height: 20),

                                    // 3. Blood Sugar Analysis Section
                                    _buildAnalysisCard(),
                                    const SizedBox(height: 20),

                                    // 4. History List Section
                                    _buildHistorySection(),
                                  ],
                                ),
                              ),

                              // Floating Action Button (+)
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: FloatingActionButton(
                                  onPressed: _openAddRecordScreen,
                                  backgroundColor: const Color(0xFFEF5350),
                                  elevation: 6,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gauge Card Builder
  Widget _buildAverageGaugeCard() {
    final avg = _averageVal;
    final unit = _currentUnit;
    final maxV = _maxVal;
    final minV = _minVal;
    final latV = _latestVal;

    final tempDummyRec = BloodSugarRecord(
      id: '',
      value: avg,
      unit: unit,
      date: DateTime.now(),
      state: _selectedStateFilter,
    );
    final statusData = tempDummyRec.categoryInfo;

    double gaugePercent = 0.5;
    if (unit == 'mmol/l') {
      gaugePercent = (avg / 15.0).clamp(0.1, 1.0);
    } else {
      gaugePercent = (avg / 250.0).clamp(0.1, 1.0);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Arc Gauge Visual
          SizedBox(
            width: 220,
            height: 115,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(220, 110),
                  painter: _ArcGaugePainter(
                    valuePercent: gaugePercent,
                    activeColor: statusData.color,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Average',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            avg.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _selectedStateFilter == 'All type'
                  ? 'Status: ${statusData.label}'
                  : 'Filter: $_selectedStateFilter',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sub-metrics Summary Row (MAXIMUM | MINIMUM | LATEST)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCol('MAXIMUM', maxV, unit),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              _buildMetricCol('MINIMUM', minV, unit),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              _buildMetricCol('LATEST', latV, unit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, double val, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              val.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Blood Sugar Analysis Card Builder
  Widget _buildAnalysisCard() {
    final filtered = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Blood Sugar Analysis',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToAllRecordsScreen,
              child: const Row(
                children: [
                  Text(
                    'View more',
                    style: TextStyle(
                      color: Color(0xFF2979FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFF2979FF), size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Tap to any circle to see the record',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Simple Visual Chart Bar Demo
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    min(filtered.length, 7),
                    (index) {
                      final r = filtered[index];
                      final info = r.categoryInfo;
                      final barH = (r.value / 200.0 * 60).clamp(18.0, 64.0);

                      return GestureDetector(
                        onTap: () => _navigateToDetail(r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: info.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 6,
                              height: barH,
                              decoration: BoxDecoration(
                                color: info.color.withAlpha(100),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // History List Section Builder
  Widget _buildHistorySection() {
    final list = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'History',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToAllRecordsScreen,
              child: const Row(
                children: [
                  Text(
                    'View more',
                    style: TextStyle(
                      color: Color(0xFF2979FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFF2979FF), size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: min(list.length, 5),
          itemBuilder: (context, index) {
            final rec = list[index];
            final info = rec.categoryInfo;

            return GestureDetector(
              onTap: () => _navigateToDetail(rec),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left Ring Displaying Numeric Value
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: info.color, width: 3.5),
                      ),
                      child: Center(
                        child: Text(
                          rec.value.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Middle Content Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  _formatHistoryDate(rec.date),
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.share_outlined, color: Colors.black45, size: 18),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.black45, size: 18),
                                    onPressed: () async {
                                      await DatabaseHelper.instance.deleteSugarRecord(rec.id);
                                      _loadLocalRecords();
                                    },
                                  ),
                                ],
                              ),
                            ],
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
                            rec.state,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Clipboard empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCA28),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                      children: List.generate(7, (index) => Container(height: 2, color: Colors.grey[200])),
                    ),
                  ),
                ),
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
          ),
          const SizedBox(height: 24),
          const Text(
            'There is no data yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: _openAddRecordScreen,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A65), Color(0xFFEF5350)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF5350).withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
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
          ),
        ],
      ),
    );
  }
}

// Arc Gauge Custom Painter
class _ArcGaugePainter extends CustomPainter {
  final double valuePercent;
  final Color activeColor;

  _ArcGaugePainter({required this.valuePercent, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 14;

    final bgPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * valuePercent.clamp(0.05, 1.0),
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter oldDelegate) =>
      oldDelegate.valuePercent != valuePercent || oldDelegate.activeColor != activeColor;
}
