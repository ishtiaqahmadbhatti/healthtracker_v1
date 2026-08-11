import 'package:flutter/material.dart';

class PeriodPhaseInfo {
  final String phaseName;
  final String description;
  final Color color;
  final String pregnancyChance;

  PeriodPhaseInfo({
    required this.phaseName,
    required this.description,
    required this.color,
    required this.pregnancyChance,
  });
}

class PeriodRecord {
  final String id;
  final DateTime startDate;
  final int cycleLength;  // e.g. 28 days
  final int periodLength; // e.g. 5 days
  final String flow;       // 'Light', 'Medium', 'Heavy', 'Spotting'
  final List<String> symptoms; // e.g. ['Cramps', 'Headache', 'Bloating']
  final String mood;       // 'Happy', 'Calm', 'Sad', 'Irritable', 'Anxious', 'Energetic'
  final String notes;

  PeriodRecord({
    required this.id,
    required this.startDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.flow = 'Medium',
    this.symptoms = const [],
    this.mood = 'Calm',
    this.notes = '',
  });

  DateTime get nextPeriodDate => startDate.add(Duration(days: cycleLength));

  DateTime get estimatedOvulationDate => startDate.add(Duration(days: cycleLength - 14));

  DateTime get fertileWindowStart => estimatedOvulationDate.subtract(const Duration(days: 4));

  DateTime get fertileWindowEnd => estimatedOvulationDate.add(const Duration(days: 1));

  int get currentCycleDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final diff = today.difference(start).inDays + 1;
    return diff <= 0 ? 1 : diff;
  }

  PeriodPhaseInfo get currentPhaseInfo {
    final day = currentCycleDay;

    if (day <= periodLength) {
      return PeriodPhaseInfo(
        phaseName: 'Menstrual Phase (Period)',
        description: 'Day $day of $periodLength. Your uterus is shedding its lining. Stay hydrated and rest.',
        color: const Color(0xFFE91E63),
        pregnancyChance: 'Low',
      );
    } else if (day < (cycleLength - 14 - 4)) {
      return PeriodPhaseInfo(
        phaseName: 'Follicular Phase',
        description: 'Your body is preparing for ovulation. Energy levels usually increase during this phase.',
        color: const Color(0xFF8E24AA),
        pregnancyChance: 'Medium',
      );
    } else if (day <= (cycleLength - 14 + 1)) {
      return PeriodPhaseInfo(
        phaseName: 'Ovulation Phase (Fertile Window)',
        description: 'Peak fertile window. An egg is released from the ovary.',
        color: const Color(0xFFD81B60),
        pregnancyChance: 'High',
      );
    } else {
      return PeriodPhaseInfo(
        phaseName: 'Luteal Phase',
        description: 'Post-ovulation phase. Progesterone levels rise as your body prepares for the next cycle.',
        color: const Color(0xFFF4511E),
        pregnancyChance: 'Low',
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'flow': flow,
      'symptoms': symptoms.join(','),
      'mood': mood,
      'notes': notes,
    };
  }

  factory PeriodRecord.fromMap(Map<String, dynamic> map) {
    final symStr = map['symptoms'] as String? ?? '';
    return PeriodRecord(
      id: map['id'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      cycleLength: map['cycleLength'] as int? ?? 28,
      periodLength: map['periodLength'] as int? ?? 5,
      flow: map['flow'] as String? ?? 'Medium',
      symptoms: symStr.isNotEmpty ? symStr.split(',') : [],
      mood: map['mood'] as String? ?? 'Calm',
      notes: map['notes'] as String? ?? '',
    );
  }
}
