import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/period_record.dart';
import '../app_database/db_helper.dart';

class PeriodAddRecordScreen extends StatefulWidget {
  final Function(HealthRecord record)? onSave;
  final PeriodRecord? recordToEdit;

  const PeriodAddRecordScreen({
    super.key,
    this.onSave,
    this.recordToEdit,
  });

  @override
  State<PeriodAddRecordScreen> createState() => _PeriodAddRecordScreenState();
}

class _PeriodAddRecordScreenState extends State<PeriodAddRecordScreen> {
  DateTime _startDate = DateTime.now();
  int _periodLength = 5;
  int _cycleLength = 28;
  String _flow = 'Medium';
  final List<String> _selectedSymptoms = [];
  String _selectedMood = 'Calm';
  late final TextEditingController _notesController;

  final List<String> _flows = ['Light', 'Medium', 'Heavy', 'Spotting'];
  final List<String> _allSymptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Mood Swings',
    'Fatigue',
    'Acne',
    'Backache',
    'Cravings'
  ];
  final List<String> _moods = ['Happy', 'Calm', 'Sad', 'Irritable', 'Anxious', 'Energetic'];

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final rec = widget.recordToEdit!;
      _startDate = rec.startDate;
      _periodLength = rec.periodLength;
      _cycleLength = rec.cycleLength;
      _flow = rec.flow;
      _selectedSymptoms.addAll(rec.symptoms);
      _selectedMood = rec.mood;
      _notesController = TextEditingController(text: rec.notes);
    } else {
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFE91E63)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _onSaveRecord() async {
    final recordId = widget.recordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final pRecord = PeriodRecord(
      id: recordId,
      startDate: _startDate,
      cycleLength: _cycleLength,
      periodLength: _periodLength,
      flow: _flow,
      symptoms: _selectedSymptoms,
      mood: _selectedMood,
      notes: _notesController.text.trim(),
    );

    if (widget.recordToEdit != null) {
      await DatabaseHelper.instance.updatePeriodRecord(pRecord);
    } else {
      await DatabaseHelper.instance.insertPeriodRecord(pRecord);
    }

    final healthRecord = HealthRecord(
      id: recordId,
      type: 'Period & Cycle',
      value: "Day 1 of $_periodLength Days",
      unit: 'Days',
      date: _startDate,
      note: "$_flow Flow - $_selectedMood",
      icon: Icons.calendar_month_rounded,
      iconColor: const Color(0xFFE91E63),
    );

    if (widget.onSave != null) {
      widget.onSave!(healthRecord);
    }

    if (mounted) {
      Navigator.of(context).pop(pRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Dark top header area
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Log Period & Symptoms',
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
              // Card 1: Start Date, Period Length & Cycle Length
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Period Start Date',
                      style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectStartDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE0E8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                              style: const TextStyle(
                                color: Color(0xFFC2185B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.calendar_month_rounded, color: Color(0xFFC2185B)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Period Length Stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Period Duration',
                          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFFE91E63)),
                              onPressed: _periodLength > 1 ? () => setState(() => _periodLength--) : null,
                            ),
                            Text(
                              "$_periodLength Days",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFE91E63)),
                              onPressed: _periodLength < 10 ? () => setState(() => _periodLength++) : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),

                    // Cycle Length Stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cycle Length',
                          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFFE91E63)),
                              onPressed: _cycleLength > 20 ? () => setState(() => _cycleLength--) : null,
                            ),
                            Text(
                              "$_cycleLength Days",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFE91E63)),
                              onPressed: _cycleLength < 45 ? () => setState(() => _cycleLength++) : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 2: Flow Level Selection
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
                    const Text(
                      'Flow Level',
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _flows.map((fl) {
                        final isSelected = _flow == fl;
                        return ChoiceChip(
                          label: Text(fl),
                          selected: isSelected,
                          selectedColor: const Color(0xFFE91E63),
                          backgroundColor: const Color(0xFFF5F6F8),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _flow = fl);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 3: Symptoms Multi-Selector
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
                    const Text(
                      'Symptoms',
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _allSymptoms.map((sym) {
                        final isSelected = _selectedSymptoms.contains(sym);
                        return FilterChip(
                          label: Text(sym),
                          selected: isSelected,
                          selectedColor: const Color(0xFFF06292),
                          backgroundColor: const Color(0xFFF5F6F8),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedSymptoms.add(sym);
                              } else {
                                _selectedSymptoms.remove(sym);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 4: Mood Selector
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
                    const Text(
                      'Mood',
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _moods.map((m) {
                        final isSelected = _selectedMood == m;
                        return ChoiceChip(
                          label: Text(m),
                          selected: isSelected,
                          selectedColor: const Color(0xFFBA68C8),
                          backgroundColor: const Color(0xFFF5F6F8),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedMood = m);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card 5: Notes
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
                    const Text(
                      'Notes',
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add any extra observations...',
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
                      colors: [Color(0xFFEC407A), Color(0xFFE91E63)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SAVE LOG',
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
