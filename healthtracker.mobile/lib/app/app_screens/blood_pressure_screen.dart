import 'dart:math';
import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/blood_pressure_record.dart';
import '../app_database/db_helper.dart';
import 'blood_pressure_crud_screen.dart';
import 'blood_pressure_detail_screen.dart';

class BloodPressureScreen extends StatefulWidget {
  // Retaining parameters for compatibility with HomeScreen imports
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;

  const BloodPressureScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
  });

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  List<BloodPressureRecord> _dbRecords = [];
  bool _isLoading = true;
  String _selectedDateFilter = 'This week';
  DateTimeRange? _selectedDateRange;

  List<BloodPressureRecord> get _filteredRecords {
    if (_selectedDateFilter == 'All Time') {
      return _dbRecords;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_selectedDateFilter == 'This week') {
      // Last 7 days including today
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      return _dbRecords.where((rec) => rec.date.isAfter(sevenDaysAgo)).toList();
    }
    if (_selectedDateFilter == 'This month') {
      // Current calendar month
      return _dbRecords.where((rec) => rec.date.year == now.year && rec.date.month == now.month).toList();
    }
    if (_selectedDateFilter == 'Date picker' && _selectedDateRange != null) {
      final start = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
      final end = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day, 23, 59, 59);
      return _dbRecords.where((rec) => rec.date.isAfter(start) && rec.date.isBefore(end)).toList();
    }
    return _dbRecords;
  }



  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.getAllRecords();
    setState(() {
      _dbRecords = records;
      _isLoading = false;
    });
  }

  // Format date and time for the history list items (e.g., "13 Aug 2026, 02:45 PM")
  String _formatHistoryDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthStr = months[date.month - 1];
    final dayStr = date.day.toString().padLeft(2, '0');
    final yearStr = date.year.toString();

    final hourInt = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final hourStr = hourInt.toString().padLeft(2, '0');
    final minuteStr = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$dayStr $monthStr $yearStr, $hourStr:$minuteStr $period';
  }



  // Navigate to adding new record screen
  Future<void> _navigateToAddRecord() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BloodPressureCrudScreen()),
    );
    if (result == true) {
      _loadRecords();
    }
  }

  // Navigate to viewing details screen
  void _navigateToDetailRecord(BloodPressureRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BloodPressureDetailScreen(
          record: record,
          onDeleteCompleted: _loadRecords,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header vibrant red color
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                // Custom AppBar / Header Section
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
                        const Expanded(
                          child: Text(
                            'Blood Pressure',
                            style: TextStyle(
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
                              const SnackBar(content: Text('Reminders for Blood Pressure coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Content Body Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6F8), // Light grey panel
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          child: Column(
                            children: [
                              // Date filter drop-down dropdown
                              _buildCustomFilterDropdown(),
                              const SizedBox(height: 16),

                              // Conditional UI: Empty State vs Records Dashboard
                              _dbRecords.isEmpty ? _buildEmptyState() : _buildDashboardState(),
                            ],
                          ),
                        ),
                        // Floating action button for adding new record (shows only when not empty)
                        if (_dbRecords.isNotEmpty)
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: FloatingActionButton(
                              onPressed: _navigateToAddRecord,
                              backgroundColor: const Color(0xFFE53935),
                              elevation: 6,
                              shape: const CircleBorder(),
                              child: const Icon(Icons.add, color: Colors.white, size: 28),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Date Filter Dropdown UI
  Widget _buildCustomFilterDropdown() {
    return _CustomDateFilterDropdown(
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
    );
  }

  // Clipboard empty state (Screenshot 1)
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 48),
        // Clipboard Graphic
        SizedBox(
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
        // Add record button
        GestureDetector(
          onTap: _navigateToAddRecord,
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
        ),
      ],
    );
  }

  // Dashboard state with circular gauge and records list (Screenshot 4)
  Widget _buildDashboardState() {
    final filtered = _filteredRecords;
    final latestRecord = filtered.isNotEmpty ? filtered.first : _dbRecords.first;
    final bpInfo = latestRecord.categoryInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card with Semicircular Gauge
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              // Custom paint semicircular gauge
              BloodPressureGauge(category: bpInfo.label),
              const SizedBox(height: 12),
              const Text(
                'your Blood Pressure',
                style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                bpInfo.label,
                style: TextStyle(
                  color: bpInfo.color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Dropdown button mimic average
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[350]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Average', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Details SYS / DIA / PUL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatsItem('SYS', latestRecord.sys, 'mmHg'),
                  _buildStatsItem('DIA', latestRecord.dia, 'mmHg'),
                  _buildStatsItem('PUL', latestRecord.pul, 'BPM'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // History Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'History',
              style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'View more >',
              style: TextStyle(color: Colors.blue[600], fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List of history records (matching Screenshot 4 layout)
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Text(
                'No records found for the selected period.',
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            ),
          )
        else
          ListView.builder(
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
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _navigateToDetailRecord(rec),
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

                          // Right Section: Structured for zero truncation & full readability
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Line 1: Category Status Badge (Full legibility)
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

                                // Line 3: Complete Date & Time (Full legibility)
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
    );
  }

  // SYS, DIA, PUL Display
  Widget _buildStatsItem(String label, int value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(color: Colors.black87, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(color: Colors.black45, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

// Semicircular Gauge Widget
class BloodPressureGauge extends StatelessWidget {
  final String category;

  const BloodPressureGauge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 220,
      child: CustomPaint(
        painter: _GaugePainter(category: category),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final String category;

  _GaugePainter({required this.category});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height - 10;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.square;

    final colors = [
      const Color(0xFF2196F3), // Low - Blue
      const Color(0xFF10B981), // Normal - Green
      const Color(0xFFF59E0B), // Elevated - Yellow
      const Color(0xFFFF9800), // Stage 1 - Orange
      const Color(0xFFE53935), // Stage 2 - Red
      const Color(0xFFB71C1C), // Crisis - Dark Red
    ];

    final double startAngle = pi;
    final double sweepAngle = pi / 6;

    // Draw segment arcs
    for (int i = 0; i < 6; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (i * sweepAngle),
        sweepAngle - 0.02,
        false,
        paint,
      );
    }

    // Determine pointer location index
    double needleIndex = 1.5;
    if (category == 'Hypotension (Low)') {
      needleIndex = 0.5;
    } else if (category == 'Normal') {
      needleIndex = 1.5;
    } else if (category == 'Elevated') {
      needleIndex = 2.5;
    } else if (category == 'Stage 1 Hypertension') {
      needleIndex = 3.5;
    } else if (category == 'Stage 2 Hypertension') {
      needleIndex = 4.5;
    } else if (category == 'Hypertensive Crisis') {
      needleIndex = 5.5;
    }

    final needleAngle = pi + (needleIndex * sweepAngle);

    final needlePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    // Pointer line
    final double arcDistance = radius;
    final needleTip = Offset(
      center.dx + arcDistance * cos(needleAngle),
      center.dy + arcDistance * sin(needleAngle),
    );

    final needleLinePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleTip, needleLinePaint);
    canvas.drawCircle(center, 6, needlePaint);

    // Draw small arrow indicator on the pointer tip
    final Path arrowPath = Path();
    const double arrowSize = 6;
    final double perpAngle = needleAngle + pi / 2;

    final Offset p1 = needleTip;
    final Offset p2 = Offset(
      needleTip.dx - arrowSize * cos(needleAngle) + arrowSize * 0.5 * cos(perpAngle),
      needleTip.dy - arrowSize * sin(needleAngle) + arrowSize * 0.5 * sin(perpAngle),
    );
    final Offset p3 = Offset(
      needleTip.dx - arrowSize * cos(needleAngle) - arrowSize * 0.5 * cos(perpAngle),
      needleTip.dy - arrowSize * sin(needleAngle) - arrowSize * 0.5 * sin(perpAngle),
    );

    arrowPath.moveTo(p1.dx, p1.dy);
    arrowPath.lineTo(p2.dx, p2.dy);
    arrowPath.lineTo(p3.dx, p3.dy);
    arrowPath.close();

    canvas.drawPath(arrowPath, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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

