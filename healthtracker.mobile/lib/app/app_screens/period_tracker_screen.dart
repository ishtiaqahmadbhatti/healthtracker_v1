import 'dart:math';
import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/period_record.dart';
import '../app_database/db_helper.dart';
import 'period_add_record_screen.dart';
import 'period_detail_screen.dart';
import 'period_records_screen.dart';
import 'alarm_screen.dart';

class PeriodTrackerScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;
  final Function(HealthRecord)? onRecordAdded;

  const PeriodTrackerScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
    this.onRecordAdded,
  });

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  List<PeriodRecord> _dbPeriodRecords = [];
  bool _isLoading = true;
  String _selectedDateFilter = 'This month';

  final List<String> _dateFilters = ['This week', 'This month', 'All Time'];

  @override
  void initState() {
    super.initState();
    _loadLocalRecords();
  }

  Future<void> _loadLocalRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.getAllPeriodRecords();
    setState(() {
      _dbPeriodRecords = records;
      _isLoading = false;
    });
  }

  Future<void> _openAddRecordScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PeriodAddRecordScreen(
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

  void _navigateToDetail(PeriodRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PeriodDetailScreen(
          record: record,
          onDeleteCompleted: _loadLocalRecords,
        ),
      ),
    );
  }

  Future<void> _navigateToAllRecordsScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PeriodRecordsScreen(),
      ),
    );
    _loadLocalRecords();
  }

  String _formatShortDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}";
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
                  color: isSelected ? const Color(0xFFE91E63) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFFE91E63)) : null,
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() => _selectedDateFilter = df);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestRecord = _dbPeriodRecords.isNotEmpty ? _dbPeriodRecords.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFE91E63), // Primary Pink Theme
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
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
                        'Period & Cycle',
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

            // Light Body Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
                    : Column(
                        children: [
                          const SizedBox(height: 14),

                          // Date Filter Dropdown Pill
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GestureDetector(
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
                                  mainAxisSize: MainAxisSize.min,
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
                          ),
                          const SizedBox(height: 16),

                          // Main Content (Empty State vs Data View)
                          Expanded(
                            child: latestRecord == null
                                ? _buildEmptyState()
                                : Stack(
                                    children: [
                                      SingleChildScrollView(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                                        child: Column(
                                          children: [
                                            // Cycle Arc Gauge Card
                                            _buildCycleGaugeCard(latestRecord),
                                            const SizedBox(height: 20),

                                            // Analysis Section
                                            _buildAnalysisCard(latestRecord),
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
                                          backgroundColor: const Color(0xFFE91E63),
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

  // Cycle Arc Gauge Card
  Widget _buildCycleGaugeCard(PeriodRecord record) {
    final phase = record.currentPhaseInfo;
    final cycleDay = record.currentCycleDay;
    final gaugePercent = (cycleDay / record.cycleLength).clamp(0.05, 1.0);

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
                  painter: _PeriodCycleArcGaugePainter(
                    valuePercent: gaugePercent,
                    activeColor: phase.color,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Current Cycle Day',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Day $cycleDay",
                            style: TextStyle(
                              color: phase.color,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "of ${record.cycleLength}",
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 13,
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
              color: phase.color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              phase.phaseName,
              style: TextStyle(
                color: phase.color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sub-metrics Summary Row (PERIOD | CYCLE | NEXT PERIOD | FERTILE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCol('PERIOD', "${record.periodLength} Days"),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              _buildMetricCol('CYCLE', "${record.cycleLength} Days"),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              _buildMetricCol('NEXT PERIOD', _formatShortDate(record.nextPeriodDate)),
              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
              _buildMetricCol('FERTILE', "${record.fertileWindowStart.day}-${record.fertileWindowEnd.day}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Period Analysis Card Builder
  Widget _buildAnalysisCard(PeriodRecord record) {
    final phase = record.currentPhaseInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cycle & Fertility Insights',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFE91E63), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Pregnancy Chance: ${phase.pregnancyChance}",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                phase.description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.4,
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
    final list = _dbPeriodRecords;

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
            final phase = rec.currentPhaseInfo;

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
                    // Circular Pink Badge
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: phase.color.withAlpha(25),
                        border: Border.all(color: phase.color, width: 2.5),
                      ),
                      child: Icon(Icons.water_drop_rounded, color: phase.color, size: 28),
                    ),
                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Started: ${_formatShortDate(rec.startDate)}",
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
                                      await DatabaseHelper.instance.deletePeriodRecord(rec.id);
                                      _loadLocalRecords();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phase.phaseName,
                            style: TextStyle(
                              color: phase.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Flow: ${rec.flow} • Mood: ${rec.mood}",
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

  // Clipboard Empty State
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
            'There is no period data yet',
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
                  colors: [Color(0xFFEC407A), Color(0xFFE91E63)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withAlpha(40),
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

// Arc Gauge Custom Painter for Period Cycle
class _PeriodCycleArcGaugePainter extends CustomPainter {
  final double valuePercent;
  final Color activeColor;

  _PeriodCycleArcGaugePainter({required this.valuePercent, required this.activeColor});

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
  bool shouldRepaint(covariant _PeriodCycleArcGaugePainter oldDelegate) =>
      oldDelegate.valuePercent != valuePercent || oldDelegate.activeColor != activeColor;
}
