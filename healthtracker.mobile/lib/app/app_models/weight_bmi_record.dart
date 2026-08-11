import 'package:flutter/material.dart';

class WeightBmiCategoryInfo {
  final String label;
  final Color color;
  final String rangeText;
  final String normalWeightRangeText;

  WeightBmiCategoryInfo({
    required this.label,
    required this.color,
    required this.rangeText,
    required this.normalWeightRangeText,
  });
}

class WeightBmiRecord {
  final String id;
  final double weightKg;
  final double heightCm;
  final double bmi;
  final DateTime date;
  final String gender;
  final int age;
  final String note;

  WeightBmiRecord({
    required this.id,
    required this.weightKg,
    required this.heightCm,
    double? bmi,
    required this.date,
    this.gender = 'Male',
    this.age = 26,
    this.note = '',
  }) : bmi = bmi ?? _calculateBmi(weightKg, heightCm);

  static double _calculateBmi(double weightKg, double heightCm) {
    if (heightCm <= 0) return 0.0;
    final hMeters = heightCm / 100.0;
    return weightKg / (hMeters * hMeters);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'bmi': bmi,
      'date': date.toIso8601String(),
      'gender': gender,
      'age': age,
      'note': note,
    };
  }

  factory WeightBmiRecord.fromMap(Map<String, dynamic> map) {
    return WeightBmiRecord(
      id: map['id'] as String,
      weightKg: (map['weightKg'] as num).toDouble(),
      heightCm: (map['heightCm'] as num).toDouble(),
      bmi: (map['bmi'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      gender: map['gender'] as String? ?? 'Male',
      age: map['age'] as int? ?? 26,
      note: map['note'] as String? ?? '',
    );
  }

  WeightBmiCategoryInfo get categoryInfo {
    final hMeters = heightCm > 0 ? heightCm / 100.0 : 1.70;
    final minNormalKg = (18.5 * hMeters * hMeters).toStringAsFixed(1);
    final maxNormalKg = (24.9 * hMeters * hMeters).toStringAsFixed(1);
    final normalRangeStr = "$minNormalKg - $maxNormalKg kg";

    if (bmi < 16.0) {
      return WeightBmiCategoryInfo(
        label: 'Very severely underweight',
        color: const Color(0xFFE040FB),
        rangeText: 'Bmi: <16.0',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 16.9) {
      return WeightBmiCategoryInfo(
        label: 'Severely underweight',
        color: const Color(0xFFAB47BC),
        rangeText: 'Bmi: 16.0–16.9',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 18.4) {
      return WeightBmiCategoryInfo(
        label: 'Underweight',
        color: const Color(0xFF42A5F5),
        rangeText: 'Bmi: 17.0–18.4',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 24.9) {
      return WeightBmiCategoryInfo(
        label: 'Normal',
        color: const Color(0xFF4CAF50),
        rangeText: 'Bmi: 18.5–24.9',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 29.9) {
      return WeightBmiCategoryInfo(
        label: 'Overweight',
        color: const Color(0xFFFFB74D),
        rangeText: 'Bmi: 25.0–29.9',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 34.9) {
      return WeightBmiCategoryInfo(
        label: 'Obese Class 1',
        color: const Color(0xFFFF9800),
        rangeText: 'Bmi: 30.0–34.9',
        normalWeightRangeText: normalRangeStr,
      );
    } else if (bmi <= 39.9) {
      return WeightBmiCategoryInfo(
        label: 'Obese Class 2',
        color: const Color(0xFFFF7043),
        rangeText: 'Bmi: 35.0–39.9',
        normalWeightRangeText: normalRangeStr,
      );
    } else {
      return WeightBmiCategoryInfo(
        label: 'Obese Class 3',
        color: const Color(0xFFEF5350),
        rangeText: 'Bmi: >=40.0',
        normalWeightRangeText: normalRangeStr,
      );
    }
  }
}
