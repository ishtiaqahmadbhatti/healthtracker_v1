import 'package:flutter/material.dart';

class BPCategoryInfo {
  final String label;
  final Color color;
  final String rangeText;
  final String advice;

  const BPCategoryInfo({
    required this.label,
    required this.color,
    required this.rangeText,
    required this.advice,
  });
}

class BloodPressureRecord {
  final String id;
  final int sys;
  final int dia;
  final int pul;
  final DateTime date;
  final String bodyPosition; // 'None', 'Standing', 'Sitting', 'Lying'
  final String measuredArm;  // 'None', 'Left', 'Right'
  final String tag;          // 'None', 'Before meal', 'After meal', etc.
  final String note;

  const BloodPressureRecord({
    required this.id,
    required this.sys,
    required this.dia,
    required this.pul,
    required this.date,
    required this.bodyPosition,
    required this.measuredArm,
    required this.tag,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sys': sys,
      'dia': dia,
      'pul': pul,
      'date': date.toIso8601String(),
      'body_position': bodyPosition,
      'measured_arm': measuredArm,
      'tag': tag,
      'note': note,
    };
  }

  factory BloodPressureRecord.fromMap(Map<String, dynamic> map) {
    return BloodPressureRecord(
      id: map['id'] as String,
      sys: map['sys'] as int,
      dia: map['dia'] as int,
      pul: map['pul'] as int,
      date: DateTime.parse(map['date'] as String),
      bodyPosition: map['body_position'] as String? ?? 'None',
      measuredArm: map['measured_arm'] as String? ?? 'None',
      tag: map['tag'] as String? ?? 'None',
      note: map['note'] as String? ?? '',
    );
  }

  // Calculate Blood Pressure category based on American Heart Association standards
  BPCategoryInfo get categoryInfo {
    if (sys > 180 || dia > 120) {
      return const BPCategoryInfo(
        label: 'Hypertensive Crisis',
        color: Color(0xFFB71C1C), // Deep Red
        rangeText: 'Systolic >180 or Diastolic >120',
        advice: 'Emergency! Your blood pressure reading indicates a hypertensive crisis. Please seek medical attention immediately.',
      );
    } else if (sys >= 140 || dia >= 90) {
      return const BPCategoryInfo(
        label: 'Stage 2 Hypertension',
        color: Color(0xFFE53935), // Red
        rangeText: 'Systolic >=140 or Diastolic >=90',
        advice: 'Your blood pressure is in Stage 2 Hypertension. Please check again and consult a healthcare professional.',
      );
    } else if ((sys >= 130 && sys <= 139) || (dia >= 80 && dia <= 89)) {
      return const BPCategoryInfo(
        label: 'Stage 1 Hypertension',
        color: Color(0xFFFF9800), // Orange
        rangeText: 'Systolic 130-139 or Diastolic 80-89',
        advice: 'Your blood pressure is in Stage 1 Hypertension. It is recommended to consult a doctor and monitor it regularly.',
      );
    } else if ((sys >= 120 && sys <= 129) && dia < 80) {
      return const BPCategoryInfo(
        label: 'Elevated',
        color: Color(0xFFF59E0B), // Amber/Yellow
        rangeText: 'Systolic 120-129 and Diastolic <80',
        advice: 'Your blood pressure is slightly elevated. Consider lifestyle adjustments like diet and exercise.',
      );
    } else if (sys < 90 || dia < 60) {
      return const BPCategoryInfo(
        label: 'Hypotension (Low)',
        color: Color(0xFF2196F3), // Blue
        rangeText: 'Systolic <90 or Diastolic <60',
        advice: 'Your blood pressure is lower than normal. Make sure you stay hydrated and consult a doctor if you feel dizzy.',
      );
    } else {
      return const BPCategoryInfo(
        label: 'Normal',
        color: Color(0xFF10B981), // Green
        rangeText: 'Systolic <120 and Diastolic <80',
        advice: 'No need to worry! Your blood pressure is in excellent condition. Keep it up by maintaining a healthy lifestyle.',
      );
    }
  }

  // Calculate Mean Arterial Pressure (MAP)
  double get mapValue {
    return dia + (sys - dia) / 3.0;
  }
}
