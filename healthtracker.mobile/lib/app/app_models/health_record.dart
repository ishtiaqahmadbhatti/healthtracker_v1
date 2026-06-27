import 'package:flutter/material.dart';

class HealthRecord {
  final String id;
  final String type;
  final String value;
  final String unit;
  final DateTime date;
  final String note;
  final IconData icon;
  final Color iconColor;

  HealthRecord({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
    required this.note,
    required this.icon,
    required this.iconColor,
  });
}
