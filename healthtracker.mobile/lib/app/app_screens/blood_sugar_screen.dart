import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import 'base_detail_screen.dart';

class BloodSugarScreen extends StatefulWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;

  const BloodSugarScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
  });

  @override
  State<BloodSugarScreen> createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  String _selectedType = 'All type';

  @override
  Widget build(BuildContext context) {
    return BaseDetailScreen(
      title: 'Blood Sugar',
      defaultDateFilter: 'This week',
      records: widget.records,
      onAddRecordTap: widget.onAddRecordTap,
      secondaryFilter: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              items: <String>['All type', 'Before meal', 'After meal', 'Fasting']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
