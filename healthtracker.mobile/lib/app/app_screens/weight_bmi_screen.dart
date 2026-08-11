import 'dart:math';
import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/weight_bmi_record.dart';
import '../app_database/db_helper.dart';
import 'weight_bmi_add_record_screen.dart';
import 'weight_bmi_detail_screen.dart';
import 'weight_bmi_records_screen.dart';
import 'alarm_screen.dart';

class WeightBmiScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;
  final Function(HealthRecord)? onRecordAdded;

  const WeightBmiScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
    this.onRecordAdded,
  });

  @override
  State<WeightBmiScreen> createState() => _WeightBmiScreenState();
}

class _WeightBmiScreenState extends State<WeightBmiScreen> {
  List<WeightBmiRecord> _dbWeightRecords = [];
  bool _isLoading = true;

  String _selectedDateFilter = 'All Time'; // 'All Time', 'This week', 'This month', 'Date picker'
  final List<String> _ageCategories = ['Age: Over 20', 'Age: Under 20'];
  int _currentAgeIndex = 0;
  DateTimeRange? _customDateRange;

  final List<String> _dateFilters = ['All Time', 'This week', 'This month', 'Date picker'];

  @override
  void initState() {
    super.initState();
    _loadLocalRecords();
  }

  Future<void> _loadLocalRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.getAllWeightBmiRecords();
    setState(() {
      _dbWeightRecords = records;
      _isLoading = false;
    });
  }

  Future<void> _openAddRecordScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeightBmiAddRecordScreen(
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

  void _navigateToDetail(WeightBmiRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeightBmiDetailScreen(
          record: record,
          onDeleteCompleted: _loadLocalRecords,
        ),
      ),
    );
  }

  Future<void> _navigateToAllRecordsScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WeightBmiRecordsScreen(),
      ),
    );
    _loadLocalRecords();
  }

  // Filter logic
  List<WeightBmiRecord> get _filteredRecords {
    List<WeightBmiRecord> result = List.from(_dbWeightRecords);

    // Age filter
    if (_ageCategories[_currentAgeIndex] == 'Age: Under 20') {
      result = result.where((r) => r.age < 20).toList();
    } else {
      result = result.where((r) => r.age >= 20).toList();
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

  // Metric Calculations
  double get _averageBmi {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double sum = 0;
    for (var r in list) {
      sum += r.bmi;
    }
    return sum / list.length;
  }

  double get _averageWeight {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double sum = 0;
    for (var r in list) {
      sum += r.weightKg;
    }
    return sum / list.length;
  }

  double get _averageHeight {
    final list = _filteredRecords;
    if (list.isEmpty) return 0.0;
    double sum = 0;
    for (var r in list) {
      sum += r.heightCm;
    }
    return sum / list.length;
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

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

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
                        'Weight & BMI',
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
                    : Column(
                        children: [
                          const SizedBox(height: 14),

                          // 1. Top Controls Bar (Date Dropdown Pill & Age Stepper Switcher)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                // Date Filter Dropdown Pill
                                GestureDetector(
                                  onTap: _showDateFilterMenu,
                                  child: Container(
                                    height: 44,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                        const SizedBox(width: 8),
                                        Text(
                                          _selectedDateFilter,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Age Stepper Switcher (< Age: Over 20 >)
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey[200]!, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.chevron_left_rounded, color: Colors.black87, size: 24),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _currentAgeIndex = (_currentAgeIndex - 1 + _ageCategories.length) % _ageCategories.length;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        _ageCategories[_currentAgeIndex],
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right_rounded, color: Colors.black87, size: 24),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _currentAgeIndex = (_currentAgeIndex + 1) % _ageCategories.length;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 2. Main Body Content (Empty State vs Data Present)
                          Expanded(
                            child: filtered.isEmpty
                                ? _buildEmptyState()
                                : Stack(
                                    children: [
                                      SingleChildScrollView(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                                        child: Column(
                                          children: [
                                            // Rainbow Arc Gauge Card (Matching Screenshot 4)
                                            _buildAverageGaugeCard(),
                                            const SizedBox(height: 20),

                                            // Analysis Section
                                            _buildAnalysisCard(),
                                            const SizedBox(height: 20),

                                            // History Section
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
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rainbow Arc Gauge Card Builder (Matching Screenshot 4 1:1)
  Widget _buildAverageGaugeCard() {
    final avgBmi = _averageBmi;
    final avgW = _averageWeight;
    final avgH = _averageHeight;

    final tempRec = WeightBmiRecord(
      id: '',
      weightKg: avgW,
      heightCm: avgH,
      bmi: avgBmi,
      date: DateTime.now(),
    );
    final statusData = tempRec.categoryInfo;

    final gaugePercent = (avgBmi / 45.0).clamp(0.05, 1.0);

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
          // Rainbow Arc Gauge Visual
          SizedBox(
            width: 220,
            height: 115,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(220, 110),
                  painter: _RainbowArcGaugePainter(
                    valuePercent: gaugePercent,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Your Bmi is',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusData.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          statusData.label,
                          style: TextStyle(
                            color: statusData.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Average Dropdown Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Average',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Metrics Summary Row (HEIGHT | WEIGHT | BMI)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('HEIGHT', style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(avgH.toStringAsFixed(1), style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 2),
                      const Text('(cm)', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              Column(
                children: [
                  const Text('WEIGHT', style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(avgW.toStringAsFixed(1), style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 2),
                      const Text('(kg)', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              Column(
                children: [
                  const Text('BMI', style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    avgBmi.toStringAsFixed(1),
                    style: TextStyle(
                      color: statusData.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Weight & BMI Analysis Card Builder
  Widget _buildAnalysisCard() {
    final filtered = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weight & BMI Analysis',
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
              // Visual Chart Bar Demo
              SizedBox(
                height: 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    min(filtered.length, 7),
                    (index) {
                      final r = filtered[index];
                      final info = r.categoryInfo;
                      final barH = (r.bmi / 40.0 * 50).clamp(14.0, 54.0);

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
                    // Left Ring Displaying Numeric BMI
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: info.color, width: 3.5),
                      ),
                      child: Center(
                        child: Text(
                          rec.bmi.toStringAsFixed(1),
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
                                      await DatabaseHelper.instance.deleteWeightBmiRecord(rec.id);
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
                            "Weight:${rec.weightKg.toStringAsFixed(1)} (kg)",
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

  // Clipboard Empty State (Matching Screenshot 1 1:1)
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

// Rainbow Arc Gauge Custom Painter for BMI Categories (Matching Screenshot 4)
class _RainbowArcGaugePainter extends CustomPainter {
  final double valuePercent;

  _RainbowArcGaugePainter({required this.valuePercent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final colors = [
      const Color(0xFFE040FB), // Very Severely Underweight (Purple)
      const Color(0xFF42A5F5), // Underweight (Blue)
      const Color(0xFF4CAF50), // Normal (Green)
      const Color(0xFFFFEE58), // Overweight (Yellow)
      const Color(0xFFFF9800), // Obese Class 1 (Orange)
      const Color(0xFFEF5350), // Obese Class 3 (Red)
    ];

    final segmentAngle = pi / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      if (i == 0) paint.strokeCap = StrokeCap.round;
      if (i == colors.length - 1) paint.strokeCap = StrokeCap.round;

      canvas.drawArc(rect, pi + (i * segmentAngle), segmentAngle + 0.02, false, paint);
    }

    // Indicator Pointer Needle
    final angle = pi + (pi * valuePercent.clamp(0.05, 0.95));
    final pointerX = center.dx + (radius + 2) * cos(angle);
    final pointerY = center.dy + (radius + 2) * sin(angle);

    final pointerPaint = Paint()..color = Colors.red;
    final path = Path()
      ..moveTo(pointerX, pointerY - 4)
      ..lineTo(pointerX - 6, pointerY + 8)
      ..lineTo(pointerX + 6, pointerY + 8)
      ..close();

    canvas.drawPath(path, pointerPaint);
  }

  @override
  bool shouldRepaint(covariant _RainbowArcGaugePainter oldDelegate) =>
      oldDelegate.valuePercent != valuePercent;
}
