import 'package:flutter/material.dart';

class HeartRateCategoryInfo {
  final String label;
  final Color color;
  final String rangeText;
  final String advice;

  HeartRateCategoryInfo({
    required this.label,
    required this.color,
    required this.rangeText,
    required this.advice,
  });
}

class HeartRateRecord {
  final String id;
  final int bpm;
  final DateTime date;
  final String status; // 'RESTING' or 'EXERCISE'
  final String gender; // 'Male' or 'Female'
  final int age;
  final String note;

  HeartRateRecord({
    required this.id,
    required this.bpm,
    required this.date,
    this.status = 'RESTING',
    this.gender = 'Male',
    this.age = 26,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bpm': bpm,
      'date': date.toIso8601String(),
      'status': status,
      'gender': gender,
      'age': age,
      'note': note,
    };
  }

  factory HeartRateRecord.fromMap(Map<String, dynamic> map) {
    return HeartRateRecord(
      id: map['id'] as String,
      bpm: map['bpm'] as int,
      date: DateTime.parse(map['date'] as String),
      status: map['status'] as String? ?? 'RESTING',
      gender: map['gender'] as String? ?? 'Male',
      age: map['age'] as int? ?? 26,
      note: map['note'] as String? ?? '',
    );
  }

  HeartRateCategoryInfo get categoryInfo {
    if (bpm < 60) {
      return HeartRateCategoryInfo(
        label: 'Slow',
        color: const Color(0xFF2979FF),
        rangeText: '< 60 BPM',
        advice: 'Your resting heart rate is low. If you experience dizziness or fatigue, please consult a doctor.',
      );
    } else if (bpm <= 100) {
      return HeartRateCategoryInfo(
        label: 'Normal',
        color: const Color(0xFF4CAF50),
        rangeText: 'Resting Heart Rate 60-100 BPM',
        advice: 'Great! Your heart rate is within the normal range.',
      );
    } else {
      return HeartRateCategoryInfo(
        label: 'Fast',
        color: const Color(0xFFEF5350),
        rangeText: '> 100 BPM',
        advice: 'Your heart rate is elevated. Try to rest and stay hydrated, or consult your physician.',
      );
    }
  }
}
