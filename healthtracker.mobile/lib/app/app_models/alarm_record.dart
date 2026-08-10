class AlarmRecord {
  final String id;
  final String title;
  final String description;
  final String type; // 'bloodPressure', 'bloodSugar', 'heartRate', 'medicine', 'custom'
  final String frequency;
  final String nextExecution;
  final int hour;
  final int minute;
  final String startDate;
  final String endDate;
  final bool neverEnd;
  bool isEnabled;

  AlarmRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.frequency,
    required this.nextExecution,
    required this.hour,
    required this.minute,
    required this.startDate,
    required this.endDate,
    required this.neverEnd,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'frequency': frequency,
      'nextExecution': nextExecution,
      'hour': hour,
      'minute': minute,
      'startDate': startDate,
      'endDate': endDate,
      'neverEnd': neverEnd ? 1 : 0,
      'isEnabled': isEnabled ? 1 : 0,
    };
  }

  factory AlarmRecord.fromMap(Map<String, dynamic> map) {
    return AlarmRecord(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      type: map['type'] as String,
      frequency: map['frequency'] as String,
      nextExecution: map['nextExecution'] as String,
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      startDate: map['startDate'] as String? ?? '',
      endDate: map['endDate'] as String? ?? '',
      neverEnd: (map['neverEnd'] as int?) == 1,
      isEnabled: (map['isEnabled'] as int) == 1,
    );
  }
}
