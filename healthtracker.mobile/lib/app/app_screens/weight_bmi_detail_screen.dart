import 'package:flutter/material.dart';
import '../app_models/weight_bmi_record.dart';
import '../app_database/db_helper.dart';
import 'weight_bmi_add_record_screen.dart';

class WeightBmiDetailScreen extends StatefulWidget {
  final WeightBmiRecord record;
  final VoidCallback onDeleteCompleted;

  const WeightBmiDetailScreen({
    super.key,
    required this.record,
    required this.onDeleteCompleted,
  });

  @override
  State<WeightBmiDetailScreen> createState() => _WeightBmiDetailScreenState();
}

class _WeightBmiDetailScreenState extends State<WeightBmiDetailScreen> {
  late WeightBmiRecord _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
  }

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  String _formatTime(DateTime dt) {
    final hourInt = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final hourStr = hourInt.toString().padLeft(2, '0');
    final minStr = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hourStr:$minStr $period";
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
            'Are you sure you want to delete this Weight & BMI record?',
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
                await DatabaseHelper.instance.deleteWeightBmiRecord(_currentRecord.id);
                if (context.mounted) {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // close detail screen
                  widget.onDeleteCompleted();  // trigger refresh
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFEF5350), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEdit() async {
    final updated = await Navigator.of(context).push<WeightBmiRecord>(
      MaterialPageRoute(
        builder: (context) => WeightBmiAddRecordScreen(
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
    final info = _currentRecord.categoryInfo;

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
          'Record Details',
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
                    // Main Display Card
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
                          // Value Display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _currentRecord.bmi.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: info.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'BMI',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              color: info.color.withAlpha(25),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: info.color.withAlpha(60), width: 1),
                            ),
                            child: Text(
                              info.label,
                              style: TextStyle(
                                color: info.color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Metrics Row (Weight & Height)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text('WEIGHT', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("${_currentRecord.weightKg.toStringAsFixed(1)} kg", style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Container(width: 1, height: 28, color: const Color(0xFFEEEEEE)),
                              Column(
                                children: [
                                  const Text('HEIGHT', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("${_currentRecord.heightCm.toStringAsFixed(1)} cm", style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Normal Weight Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                const Text('Normal Weight Range:', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(info.normalWeightRangeText, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date & Time Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Color(0xFFEF5350), size: 20),
                              const SizedBox(width: 10),
                              Text(
                                _formatDate(_currentRecord.date),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, color: Color(0xFFEF5350), size: 20),
                              const SizedBox(width: 10),
                              Text(
                                _formatTime(_currentRecord.date),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Demographics Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle_outlined, color: Colors.black54, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            "${_currentRecord.gender}, Age: ${_currentRecord.age}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
