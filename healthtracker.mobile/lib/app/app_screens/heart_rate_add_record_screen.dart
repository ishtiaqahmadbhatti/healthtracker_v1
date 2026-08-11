import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/heart_rate_record.dart';
import '../app_database/db_helper.dart';

class HeartRateAddRecordScreen extends StatefulWidget {
  final Function(HealthRecord record)? onSave;
  final HeartRateRecord? heartRateRecordToEdit;

  const HeartRateAddRecordScreen({
    super.key,
    this.onSave,
    this.heartRateRecordToEdit,
  });

  @override
  State<HeartRateAddRecordScreen> createState() => _HeartRateAddRecordScreenState();
}

class _HeartRateAddRecordScreenState extends State<HeartRateAddRecordScreen> {
  int _bpm = 60;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedStatus = 'RESTING'; // 'RESTING' or 'EXERCISE'
  String _selectedGender = 'Male';
  int _selectedAge = 26;

  late final FixedExtentScrollController _wheelController;

  @override
  void initState() {
    super.initState();
    if (widget.heartRateRecordToEdit != null) {
      final rec = widget.heartRateRecordToEdit!;
      _bpm = rec.bpm;
      _selectedDate = rec.date;
      _selectedTime = TimeOfDay.fromDateTime(rec.date);
      _selectedStatus = rec.status;
      _selectedGender = rec.gender;
      _selectedAge = rec.age;
    }

    // BPM wheel range starts from 30, so index = _bpm - 30
    _wheelController = FixedExtentScrollController(initialItem: (_bpm - 30).clamp(0, 190));
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  HeartRateCategoryInfo get _statusInfo {
    final tempRec = HeartRateRecord(
      id: '',
      bpm: _bpm,
      date: DateTime.now(),
      status: _selectedStatus,
    );
    return tempRec.categoryInfo;
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
            colorScheme: const ColorScheme.light(primary: Color(0xFFEF5350)),
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
            colorScheme: const ColorScheme.light(primary: Color(0xFFEF5350)),
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
    final recordDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final recordId = widget.heartRateRecordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final hrRecord = HeartRateRecord(
      id: recordId,
      bpm: _bpm,
      date: recordDateTime,
      status: _selectedStatus,
      gender: _selectedGender,
      age: _selectedAge,
      note: '',
    );

    if (widget.heartRateRecordToEdit != null) {
      await DatabaseHelper.instance.updateHeartRateRecord(hrRecord);
    } else {
      await DatabaseHelper.instance.insertHeartRateRecord(hrRecord);
    }

    final healthRecord = HealthRecord(
      id: recordId,
      type: 'Heart Rate',
      value: "$_bpm BPM",
      unit: 'BPM',
      date: recordDateTime,
      note: "$_selectedStatus - ${_statusInfo.label}",
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFFEF5350),
    );

    if (widget.onSave != null) {
      widget.onSave!(healthRecord);
    }

    if (mounted) {
      Navigator.of(context).pop(hrRecord);
    }
  }

  void _showInfoModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFFEF5350)),
            SizedBox(width: 8),
            Text('Heart Rate Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Slow (Low): < 60 BPM', style: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 6),
            Text('• Normal: 60 - 100 BPM', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 6),
            Text('• Fast (High): > 100 BPM', style: TextStyle(color: Color(0xFFEF5350), fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFFEF5350), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _statusInfo;

    return Scaffold(
      backgroundColor: const Color(0xFF212121), // Dark header container
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New record',
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
              // 1. Choose your heart rate Wheel Selector Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                        'Choose you heart rate',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Heart Rate (BPM)',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // BPM Wheel Scroll View (Horizontal feel)
                    SizedBox(
                      height: 80,
                      child: ListWheelScrollView.useDelegate(
                        controller: _wheelController,
                        itemExtent: 54,
                        perspective: 0.003,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _bpm = 30 + index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 191, // 30 to 220
                          builder: (context, index) {
                            final itemBpm = 30 + index;
                            final isSelected = itemBpm == _bpm;

                            return Center(
                              child: Text(
                                "$itemBpm",
                                style: TextStyle(
                                  fontSize: isSelected ? 36 : 24,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                                  color: isSelected
                                      ? info.color
                                      : Colors.black26,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Dynamic Status Box Card
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
                    // Status Badge Pill
                    GestureDetector(
                      onTap: _showInfoModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: info.color.withAlpha(25),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: info.color.withAlpha(80), width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              info.label,
                              style: TextStyle(
                                color: info.color,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.help_outline_rounded, color: info.color, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info.rangeText,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Advisory Box
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
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Date & Time Selection Pills
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 20),
                            const SizedBox(width: 10),
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
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.black54, size: 20),
                            const SizedBox(width: 10),
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

              // 4. Status Switcher Row (RESTING vs EXERCISE)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedStatus = 'RESTING'),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: _selectedStatus == 'RESTING' ? const Color(0xFFEF5350) : const Color(0xFFF4F5F7),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.accessibility_new_rounded,
                                    color: _selectedStatus == 'RESTING' ? Colors.white : Colors.black45,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'RESTING',
                                    style: TextStyle(
                                      color: _selectedStatus == 'RESTING' ? Colors.white : Colors.black54,
                                      fontSize: 14,
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
                            onTap: () => setState(() => _selectedStatus = 'EXERCISE'),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: _selectedStatus == 'EXERCISE' ? const Color(0xFFEF5350) : const Color(0xFFF4F5F7),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_run_rounded,
                                    color: _selectedStatus == 'EXERCISE' ? Colors.white : Colors.black45,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'EXERCISE',
                                    style: TextStyle(
                                      color: _selectedStatus == 'EXERCISE' ? Colors.white : Colors.black54,
                                      fontSize: 14,
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 5. Gender & Age Row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle_outlined, color: Colors.black87, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      _selectedGender,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(width: 1, height: 20, color: Colors.black26),
                    const SizedBox(width: 16),
                    Text(
                      "Age: $_selectedAge",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 6. Save Button
              GestureDetector(
                onTap: _onSaveRecord,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7043), Color(0xFFEF5350)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF5350).withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SAVE',
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
