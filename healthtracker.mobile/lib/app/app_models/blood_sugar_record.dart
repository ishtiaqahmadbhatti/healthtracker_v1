import 'package:flutter/material.dart';

class BloodSugarCategoryInfo {
  final String label;
  final Color color;
  final String rangeText;
  final String advice;

  BloodSugarCategoryInfo({
    required this.label,
    required this.color,
    required this.rangeText,
    required this.advice,
  });
}

class BloodSugarRecord {
  final String id;
  final double value;
  final String unit; // 'mg/dL' or 'mmol/l'
  final DateTime date;
  final String state; // 'Default', 'Fasting', 'Before a meal', etc.
  final String note;

  BloodSugarRecord({
    required this.id,
    required this.value,
    required this.unit,
    required this.date,
    required this.state,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'unit': unit,
      'date': date.toIso8601String(),
      'state': state,
      'note': note,
    };
  }

  factory BloodSugarRecord.fromMap(Map<String, dynamic> map) {
    return BloodSugarRecord(
      id: map['id'] as String,
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
      date: DateTime.parse(map['date'] as String),
      state: map['state'] as String,
      note: map['note'] as String? ?? '',
    );
  }

  BloodSugarCategoryInfo get categoryInfo {
    final bool isMmol = unit == 'mmol/l';

    if (isMmol) {
      if (value < 3.9) {
        return BloodSugarCategoryInfo(
          label: 'Low',
          color: const Color(0xFF2979FF),
          rangeText: '< 3.9 mmol/l',
          advice: 'Your blood sugar level is low. Please consider consuming fast-acting carbohydrates or contact a doctor if symptoms arise.',
        );
      } else if (value <= 5.4) {
        return BloodSugarCategoryInfo(
          label: 'Normal',
          color: const Color(0xFF4CAF50),
          rangeText: '4.0 - 5.4 mmol/l',
          advice: 'Your blood sugar level is within the healthy normal target range. Keep maintaining your healthy routine!',
        );
      } else if (value <= 6.9) {
        return BloodSugarCategoryInfo(
          label: 'Pre - Diabetes',
          color: const Color(0xFFFBC02D),
          rangeText: '5.5 - 6.9 mmol/l',
          advice: 'Your blood sugar is slightly elevated. Maintaining a balanced diet and regular physical activity can help lower it.',
        );
      } else {
        return BloodSugarCategoryInfo(
          label: 'Diabetes',
          color: const Color(0xFFFF5722),
          rangeText: '≥ 7.0 mmol/l',
          advice: 'Your blood sugar level is high. Please consult your physician or healthcare provider for medical guidance.',
        );
      }
    } else {
      if (value < 71.0) {
        return BloodSugarCategoryInfo(
          label: 'Low',
          color: const Color(0xFF2979FF),
          rangeText: '< 71.0 mg/dL',
          advice: 'Your blood sugar level is low. Please consider consuming fast-acting carbohydrates or contact a doctor if symptoms arise.',
        );
      } else if (value <= 98.0) {
        return BloodSugarCategoryInfo(
          label: 'Normal',
          color: const Color(0xFF4CAF50),
          rangeText: '72.0 - 98.0 mg/dL',
          advice: 'Your blood sugar level is within the healthy normal target range. Keep maintaining your healthy routine!',
        );
      } else if (value <= 125.0) {
        return BloodSugarCategoryInfo(
          label: 'Pre - Diabetes',
          color: const Color(0xFFFBC02D),
          rangeText: '99.0 - 125.0 mg/dL',
          advice: 'Your blood sugar is slightly elevated. Maintaining a balanced diet and regular physical activity can help lower it.',
        );
      } else {
        return BloodSugarCategoryInfo(
          label: 'Diabetes',
          color: const Color(0xFFFF5722),
          rangeText: '≥ 126.0 mg/dL',
          advice: 'Your blood sugar level is high. Please consult your physician or healthcare provider for medical guidance.',
        );
      }
    }
  }
}
