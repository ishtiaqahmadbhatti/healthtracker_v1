import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/step_record.dart';
import '../app_database/db_helper.dart';

class StepAddRecordScreen extends StatefulWidget {
  final Function(HealthRecord record)? onSave;
  final StepRecord? recordToEdit;

  const StepAddRecordScreen({
    super.key,
    this.onSave,
    this.recordToEdit,
  });

  @override
  State<StepAddRecordScreen> createState() => _StepAddRecordScreenState();
}

class _StepAddRecordScreenState extends State<StepAddRecordScreen> {
  late final TextEditingController _stepsController;
  late final TextEditingController _goalController;
  late final TextEditingController _notesController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final rec = widget.recordToEdit!;
      _stepsController = TextEditingController(text: "${rec.steps}");
      _goalController = TextEditingController(text: "${rec.goalSteps}");
      _selectedDate = rec.date;
      _selectedTime = TimeOfDay.fromDateTime(rec.date);
      _notesController = TextEditingController(text: rec.note);
    } else {
      _stepsController = TextEditingController(text: "7500");
      _goalController = TextEditingController(text: "10000");
      _notesController = TextEditingController();
    }

    _stepsController.addListener(() => setState(() {}));
    _goalController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _goalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _currentSteps {
    return int.tryParse(_stepsController.text.trim()) ?? 0;
  }

  int get _currentGoal {
    return int.tryParse(_goalController.text.trim()) ?? 10000;
  }

  StepRecord get _previewRecord {
    return StepRecord(
      id: '',
      steps: _currentSteps,
      goalSteps: _currentGoal,
      date: _selectedDate,
      note: _notesController.text.trim(),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF10B981)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF10B981)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _onSaveRecord() async {
    final steps = _currentSteps;
    final goal = _currentGoal;
    if (steps < 0 || goal <= 0) return;

    final recordDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final recordId = widget.recordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final sRecord = StepRecord(
      id: recordId,
      steps: steps,
      goalSteps: goal,
      date: recordDateTime,
      note: _notesController.text.trim(),
    );

    if (widget.recordToEdit != null) {
      await DatabaseHelper.instance.updateStepRecord(sRecord);
    } else {
      await DatabaseHelper.instance.insertStepRecord(sRecord);
    }

    final healthRecord = HealthRecord(
      id: recordId,
      type: 'Step Tracker',
      value: "$steps steps",
      unit: 'steps',
      date: recordDateTime,
      note: "${sRecord.progressPercentage}% of $goal Goal",
      icon: Icons.directions_walk_rounded,
      iconColor: const Color(0xFF10B981),
    );

    if (widget.onSave != null) {
      widget.onSave!(healthRecord);
    }

    if (mounted) {
      Navigator.of(context).pop(sRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _previewRecord;
    final info = preview.categoryInfo;

    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Dark header area
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Log Daily Steps',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Date & Time Selector Pills Row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year.toString().substring(2)}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.black54, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Card 1: Step & Goal Inputs
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Steps Walked',
                                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _stepsController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFE8F5E9),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Goal',
                                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _goalController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF1F3F5),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 2: Automatic Calculated Metrics (Distance, Calories, Active Mins)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Estimated Activity Metrics',
                        style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.straighten_rounded, color: Color(0xFF2979FF), size: 24),
                            const SizedBox(height: 6),
                            Text(
                              "${preview.distanceKm.toStringAsFixed(2)} km",
                              style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const Text('Distance', style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                        Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),
                        Column(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF9800), size: 24),
                            const SizedBox(height: 6),
                            Text(
                              "${preview.calories.round()} kcal",
                              style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const Text('Calories', style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                        Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),
                        Column(
                          children: [
                            const Icon(Icons.timer_rounded, color: Color(0xFF9C27B0), size: 24),
                            const SizedBox(height: 6),
                            Text(
                              "${preview.activeMinutes} mins",
                              style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const Text('Active Time', style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 3: Status Indicator & Advice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: info.color.withAlpha(25),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: info.color.withAlpha(80), width: 1.5),
                      ),
                      child: Text(
                        info.label,
                        style: TextStyle(
                          color: info.color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${preview.progressPercentage}% of daily target completed",
                      style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        info.advice,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes Input
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notes', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Add activity note (e.g. Morning Walk)',
                        filled: true,
                        fillColor: const Color(0xFFF5F6F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Save Button
              GestureDetector(
                onTap: _onSaveRecord,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF34D399), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SAVE STEPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
