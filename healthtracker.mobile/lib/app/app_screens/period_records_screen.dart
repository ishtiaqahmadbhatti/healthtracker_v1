import 'package:flutter/material.dart';
import '../app_models/period_record.dart';
import '../app_database/db_helper.dart';
import 'period_detail_screen.dart';

class PeriodRecordsScreen extends StatefulWidget {
  const PeriodRecordsScreen({super.key});

  @override
  State<PeriodRecordsScreen> createState() => _PeriodRecordsScreenState();
}

class _PeriodRecordsScreenState extends State<PeriodRecordsScreen> {
  List<PeriodRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllRecords();
  }

  Future<void> _loadAllRecords() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllPeriodRecords();
    setState(() {
      _records = list;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  void _navigateToDetail(PeriodRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PeriodDetailScreen(
          record: record,
          onDeleteCompleted: _loadAllRecords,
        ),
      ),
    ).then((_) => _loadAllRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Period & Cycle History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
            : _records.isEmpty
                ? const Center(
                    child: Text(
                      'No period logs saved yet.',
                      style: TextStyle(color: Colors.black45, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final rec = _records[index];
                      final phase = rec.currentPhaseInfo;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: phase.color.withAlpha(20),
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
                                // Left Rose Badge Display
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: phase.color.withAlpha(30),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: phase.color, width: 2.5),
                                  ),
                                  child: Icon(Icons.calendar_month_rounded, color: phase.color, size: 28),
                                ),
                                const SizedBox(width: 16),

                                // Record Info Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Started: ${_formatDate(rec.startDate)}",
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
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
      ),
    );
  }
}
