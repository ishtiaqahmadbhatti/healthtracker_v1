import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import 'base_detail_screen.dart';

class WeightBmiScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;

  const WeightBmiScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
  });

  @override
  State<WeightBmiScreen> createState() => _WeightBmiScreenState();
}

class _WeightBmiScreenState extends State<WeightBmiScreen> {
  String _selectedDateFilter = 'This month';
  final List<String> _ageCategories = ['Age: Over 20', 'Age: Under 20'];
  int _currentAgeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isThisMonth = _selectedDateFilter == 'This month';

    return BaseDetailScreen(
      title: 'Weight & BMI',
      defaultDateFilter: 'This month',
      records: widget.records,
      onAddRecordTap: widget.onAddRecordTap,
      showClipboardIcon: !isThisMonth,
      emptyStateMessage: isThisMonth
          ? '(This month) No record yet.\nAdd your new weight & bmi\nrecord'
          : 'There is no data yet',
      onDateFilterChanged: (newFilter) {
        setState(() {
          _selectedDateFilter = newFilter;
        });
      },
      secondaryFilter: isThisMonth
          ? null
          : Align(
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
                      icon: const Icon(Icons.chevron_right_rounded, color: Colors.black54, size: 28),
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
            ),
    );
  }
}
