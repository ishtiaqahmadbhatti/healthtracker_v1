import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import 'base_detail_screen.dart';

class HeartRateScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;

  const HeartRateScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
  });

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  final List<String> _states = ['Resting', 'Exercise', 'Walking', 'Sleeping'];
  int _currentStateIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseDetailScreen(
      title: 'Heart Rate',
      defaultDateFilter: 'This week',
      records: widget.records,
      onAddRecordTap: widget.onAddRecordTap,
      secondaryFilter: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, color: Colors.black54, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _currentStateIndex = (_currentStateIndex - 1 + _states.length) % _states.length;
                  });
                },
              ),
              const SizedBox(width: 16),
              Text(
                _states[_currentStateIndex],
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, color: Colors.black54, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _currentStateIndex = (_currentStateIndex + 1) % _states.length;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
