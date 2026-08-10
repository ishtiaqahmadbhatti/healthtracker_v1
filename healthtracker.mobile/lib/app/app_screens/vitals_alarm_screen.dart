import 'package:flutter/material.dart';
import '../app_models/alarm_record.dart';
import '../app_database/db_helper.dart';
import '../app_services/notification_helper.dart';

enum VitalAlarmType { bloodPressure, bloodSugar, heartRate, medicine, custom }

class VitalsAlarmScreen extends StatefulWidget {
  final VitalAlarmType type;
  final AlarmRecord? existingAlarm;

  const VitalsAlarmScreen({
    super.key,
    required this.type,
    this.existingAlarm,
  });

  @override
  State<VitalsAlarmScreen> createState() => _VitalsAlarmScreenState();
}

class _VitalsAlarmScreenState extends State<VitalsAlarmScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  final List<TimeOfDay> _times = [];
  final List<bool> _repeatDays = [true, true, true, true, true, true, false]; // S, M, T, W, T, F, S
  final List<String> _dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _neverEnd = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingAlarm != null) {
      final alarm = widget.existingAlarm!;
      _titleController = TextEditingController(text: alarm.title);
      _descController = TextEditingController(text: alarm.description);
      _times.add(TimeOfDay(hour: alarm.hour, minute: alarm.minute));
      _neverEnd = alarm.neverEnd;
    } else {
      switch (widget.type) {
        case VitalAlarmType.bloodPressure:
          _titleController = TextEditingController(text: "It's time to measure your blood pressure.");
          _descController = TextEditingController(text: "Make sure to take your measurements before taking your medication.");
          break;
        case VitalAlarmType.bloodSugar:
          _titleController = TextEditingController(text: "Time to measure your Blood Sugar.");
          _descController = TextEditingController(text: "Take your measurements before meals or as directed by your doctor.");
          break;
        case VitalAlarmType.heartRate:
          _titleController = TextEditingController(text: "Time to measure your Heart Rate.");
          _descController = TextEditingController(text: "Remember to take your measurements before you take your medicines.");
          break;
        case VitalAlarmType.medicine:
          _titleController = TextEditingController(text: "Time to take your medication.");
          _descController = TextEditingController(text: "Take with water after food or according to your prescription.");
          break;
        case VitalAlarmType.custom:
          _titleController = TextEditingController(text: "Alarm reminder.");
          _descController = TextEditingController(text: "Set custom details for this alarm.");
          break;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _times.isNotEmpty ? _times.first : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (!_times.contains(picked)) {
          _times.add(picked);
        }
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _neverEnd = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return "$day/$month/$year";
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  Future<void> _onSave() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final String frequency = _times.isEmpty 
        ? "Once per day" 
        : "${_times.length} times per day";

    final now = DateTime.now();
    final TimeOfDay targetTime = _times.isNotEmpty
        ? _times.first
        : TimeOfDay(hour: (now.hour + (now.minute >= 59 ? 1 : 0)) % 24, minute: (now.minute + 1) % 60);

    DateTime scheduledDate = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      targetTime.hour,
      targetTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = DateTime(now.year, now.month, now.day, targetTime.hour, targetTime.minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    final String alarmId = widget.existingAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final String typeStr = widget.type.name;

    final AlarmRecord alarmRecord = AlarmRecord(
      id: alarmId,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      type: typeStr,
      frequency: frequency,
      nextExecution: "Next, ${_formatDate(scheduledDate)}\n${_formatTimeOfDay(targetTime)}",
      hour: targetTime.hour,
      minute: targetTime.minute,
      startDate: _formatDate(_startDate),
      endDate: _neverEnd ? 'Never' : _formatDate(_endDate),
      neverEnd: _neverEnd,
      isEnabled: true,
    );

    // Save to persistent database
    if (widget.existingAlarm != null) {
      await DatabaseHelper.instance.updateAlarm(alarmRecord);
    } else {
      await DatabaseHelper.instance.insertAlarm(alarmRecord);
    }

    if (!mounted) return;

    // Schedule notification + ringing alert
    NotificationHelper.instance.scheduleAlarm(
      id: alarmRecord.id.hashCode,
      title: alarmRecord.title,
      body: alarmRecord.description.isNotEmpty
          ? alarmRecord.description
          : "It is time for your scheduled vital measurement!",
      targetDateTime: scheduledDate,
      context: context,
    );

    Navigator.of(context).pop(alarmRecord);
  }

  @override
  Widget build(BuildContext context) {
    final String screenTitle;
    final String assetPath;
    final Widget fallbackIcon;

    switch (widget.type) {
      case VitalAlarmType.bloodPressure:
        screenTitle = 'Blood Pressure';
        assetPath = 'assets/images/bp.png';
        fallbackIcon = const Icon(Icons.health_and_safety_rounded, color: Color(0xFF1E8D89), size: 48);
        break;
      case VitalAlarmType.bloodSugar:
        screenTitle = 'Blood Sugar';
        assetPath = 'assets/images/blood_sugar.png';
        fallbackIcon = const Icon(Icons.water_drop_rounded, color: Color(0xFF9C27B0), size: 48);
        break;
      case VitalAlarmType.heartRate:
        screenTitle = 'Heart Rate';
        assetPath = 'assets/images/heart_rate.png';
        fallbackIcon = const Icon(Icons.favorite_rounded, color: Color(0xFFE54A4A), size: 48);
        break;
      case VitalAlarmType.medicine:
        screenTitle = 'Medicine';
        assetPath = 'assets/images/medicine.png';
        fallbackIcon = const Icon(Icons.vaccines_rounded, color: Color(0xFFFA9314), size: 48);
        break;
      case VitalAlarmType.custom:
        screenTitle = 'Custom';
        assetPath = 'assets/images/custom.png';
        fallbackIcon = const Icon(Icons.notifications_active_rounded, color: Color(0xFF1E7BFA), size: 48);
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      body: Column(
        children: [
          // AppBar / Header Section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.existingAlarm != null ? 'Edit $screenTitle Alarm' : screenTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Graphic Logo Badge
          Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return fallbackIcon;
                    },
                  ),
                ),
              ),
            ),
          ),

          // Form body card
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${_titleController.text.length}/50',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      maxLines: null,
                      onChanged: (text) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Description field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Description (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${_descController.text.length}/150',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLength: 150,
                      maxLines: 4,
                      onChanged: (text) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Set time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Set time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context),
                          child: const Text(
                            '+ADD TIME',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Times chip list
                    if (_times.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _times.map((time) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE53935),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTimeOfDay(time),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _times.remove(time);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),

                    // Repeat every
                    const Text(
                      'Repeat every',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final isSelected = _repeatDays[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _repeatDays[index] = !_repeatDays[index];
                            });
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2979FF) : Colors.black12,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _dayNames[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Start Date
                    const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectStartDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(_startDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(Icons.calendar_today_rounded, color: Colors.black54, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // End Date Option
                    const Text(
                      'End',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Never Radio
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _neverEnd = true;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _neverEnd ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: const Color(0xFF1E8D89),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Never',
                            style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Date Radio
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _neverEnd = false;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                !_neverEnd ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: const Color(0xFF1E8D89),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'On',
                                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectEndDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(_endDate),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today_rounded, color: Colors.black54, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Save Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEF5350),
                            Color(0xFFE53935),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
