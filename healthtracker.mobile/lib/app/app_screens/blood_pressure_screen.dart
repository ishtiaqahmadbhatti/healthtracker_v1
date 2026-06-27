import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import 'base_detail_screen.dart';

class BloodPressureScreen extends StatelessWidget {
  final List<HealthRecord> records;
  final VoidCallback onAddRecordTap;

  const BloodPressureScreen({
    super.key,
    required this.records,
    required this.onAddRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDetailScreen(
      title: 'Blood Pressure',
      defaultDateFilter: 'This month',
      records: records,
      onAddRecordTap: onAddRecordTap,
    );
  }
}
