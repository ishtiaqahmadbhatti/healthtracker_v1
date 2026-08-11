import 'package:flutter/material.dart';
import '../app_models/period_record.dart';
import '../app_database/db_helper.dart';
import 'period_add_record_screen.dart';

class PeriodDetailScreen extends StatefulWidget {
  final PeriodRecord record;
  final VoidCallback onDeleteCompleted;

  const PeriodDetailScreen({
    super.key,
    required this.record,
    required this.onDeleteCompleted,
  });

  @override
  State<PeriodDetailScreen> createState() => _PeriodDetailScreenState();
}

class _PeriodDetailScreenState extends State<PeriodDetailScreen> {
  late PeriodRecord _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
  }

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Delete',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: const Text(
            'Are you sure you want to delete this Period log?',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deletePeriodRecord(_currentRecord.id);
                if (context.mounted) {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // close detail screen
                  widget.onDeleteCompleted();  // trigger refresh
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFE91E63), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEdit() async {
    final updated = await Navigator.of(context).push<PeriodRecord>(
      MaterialPageRoute(
        builder: (context) => PeriodAddRecordScreen(
          recordToEdit: _currentRecord,
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        _currentRecord = updated;
      });
      widget.onDeleteCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final phase = _currentRecord.currentPhaseInfo;

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
          'Cycle Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Main Phase Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(6),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            phase.phaseName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: phase.color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: phase.color.withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Pregnancy Chance: ${phase.pregnancyChance}",
                              style: TextStyle(
                                color: phase.color,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE0E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              phase.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Period Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded, color: Color(0xFFE91E63), size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Started: ${_formatDate(_currentRecord.startDate)}",
                                    style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                "${_currentRecord.periodLength} Days Period",
                                style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Flow Level: ${_currentRecord.flow}",
                                style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Cycle: ${_currentRecord.cycleLength} Days",
                                style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.mood_rounded, color: Color(0xFFE91E63), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Mood: ${_currentRecord.mood}",
                                style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Symptoms Card
                    if (_currentRecord.symptoms.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Logged Symptoms',
                              style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _currentRecord.symptoms.map((s) {
                                return Chip(
                                  label: Text(s),
                                  backgroundColor: const Color(0xFFFDE0E8),
                                  labelStyle: const TextStyle(color: Color(0xFFC2185B), fontWeight: FontWeight.bold, fontSize: 13),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                    if (_currentRecord.notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notes',
                              style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(_currentRecord.notes, style: const TextStyle(color: Colors.black87, fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
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
