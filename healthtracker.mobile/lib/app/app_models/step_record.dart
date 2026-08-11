import 'package:flutter/material.dart';

class StepCategoryInfo {
  final String label;
  final Color color;
  final String advice;

  StepCategoryInfo({
    required this.label,
    required this.color,
    required this.advice,
  });
}

class StepRecord {
  final String id;
  final int steps;
  final int goalSteps;
  final DateTime date;
  final double distanceKm;
  final double calories;
  final int activeMinutes;
  final String note;

  StepRecord({
    required this.id,
    required this.steps,
    this.goalSteps = 10000,
    required this.date,
    double? distanceKm,
    double? calories,
    int? activeMinutes,
    this.note = '',
  })  : distanceKm = distanceKm ?? (steps * 0.00075), // Average stride ~0.75m per step
        calories = calories ?? (steps * 0.04),      // Average ~0.04 kcal per step
        activeMinutes = activeMinutes ?? (steps / 100).round(); // ~100 steps/min

  double get progressPercent => (steps / (goalSteps > 0 ? goalSteps : 10000)).clamp(0.0, 1.0);

  int get progressPercentage => (progressPercent * 100).round();

  StepCategoryInfo get categoryInfo {
    if (steps < 3000) {
      return StepCategoryInfo(
        label: 'Sedentary',
        color: const Color(0xFFFF9800),
        advice: 'You have taken a few steps today. Try taking a short walk to boost your activity level!',
      );
    } else if (steps < 7500) {
      return StepCategoryInfo(
        label: 'Moderately Active',
        color: const Color(0xFF2979FF),
        advice: 'Good progress! You are close to your target. Keep moving!',
      );
    } else if (steps < 10000) {
      return StepCategoryInfo(
        label: 'Target Achieved!',
        color: const Color(0xFF4CAF50),
        advice: 'Great job! You reached a healthy daily step milestone.',
      );
    } else {
      return StepCategoryInfo(
        label: 'Super Active!',
        color: const Color(0xFF10B981),
        advice: 'Outstanding! You exceeded your 10,000 daily step goal. Keep up the amazing work!',
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'steps': steps,
      'goalSteps': goalSteps,
      'date': date.toIso8601String(),
      'distanceKm': distanceKm,
      'calories': calories,
      'activeMinutes': activeMinutes,
      'note': note,
    };
  }

  factory StepRecord.fromMap(Map<String, dynamic> map) {
    return StepRecord(
      id: map['id'] as String,
      steps: map['steps'] as int,
      goalSteps: map['goalSteps'] as int? ?? 10000,
      date: DateTime.parse(map['date'] as String),
      distanceKm: (map['distanceKm'] as num?)?.toDouble(),
      calories: (map['calories'] as num?)?.toDouble(),
      activeMinutes: map['activeMinutes'] as int?,
      note: map['note'] as String? ?? '',
    );
  }
}
