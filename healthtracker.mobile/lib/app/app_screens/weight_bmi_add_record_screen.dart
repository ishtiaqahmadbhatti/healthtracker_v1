import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/weight_bmi_record.dart';
import '../app_database/db_helper.dart';

class WeightBmiAddRecordScreen extends StatefulWidget {
  final Function(HealthRecord record)? onSave;
  final WeightBmiRecord? recordToEdit;

  const WeightBmiAddRecordScreen({
    super.key,
    this.onSave,
    this.recordToEdit,
  });

  @override
  State<WeightBmiAddRecordScreen> createState() => _WeightBmiAddRecordScreenState();
}

class _WeightBmiAddRecordScreenState extends State<WeightBmiAddRecordScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedGender = 'Male';
  int _selectedAge = 26;

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final rec = widget.recordToEdit!;
      _weightController = TextEditingController(text: rec.weightKg.toStringAsFixed(1));
      _heightController = TextEditingController(text: rec.heightCm.toStringAsFixed(1));
      _selectedDate = rec.date;
      _selectedTime = TimeOfDay.fromDateTime(rec.date);
      _selectedGender = rec.gender;
      _selectedAge = rec.age;
    } else {
      _weightController = TextEditingController(text: "64.0");
      _heightController = TextEditingController(text: "170.0");
    }

    _weightController.addListener(() => setState(() {}));
    _heightController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  double get _currentWeight {
    return double.tryParse(_weightController.text.trim()) ?? 0.0;
  }

  double get _currentHeight {
    return double.tryParse(_heightController.text.trim()) ?? 0.0;
  }

  double get _calculatedBmi {
    final w = _currentWeight;
    final h = _currentHeight;
    if (h <= 0) return 0.0;
    final hM = h / 100.0;
    return w / (hM * hM);
  }

  WeightBmiCategoryInfo get _statusInfo {
    final tempRec = WeightBmiRecord(
      id: '',
      weightKg: _currentWeight,
      heightCm: _currentHeight,
      bmi: _calculatedBmi,
      date: DateTime.now(),
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

  void _showBmiTypesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Type of BMI',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBmiCategoryBadge('Very severely underweight', 'BMI:<16.0', const Color(0xFFE040FB)),
                _buildBmiCategoryBadge('Severely underweight', 'BMI:16.0–16.9', const Color(0xFFAB47BC)),
                _buildBmiCategoryBadge('Underweight', 'BMI:17.0–18.4', const Color(0xFF42A5F5)),
                _buildBmiCategoryBadge('Normal', 'BMI:18.5–24.9', const Color(0xFF4CAF50)),
                _buildBmiCategoryBadge('Overweight', 'BMI:25.0–29.9', const Color(0xFFFFB74D)),
                _buildBmiCategoryBadge('Obese Class 1', 'BMI:30.0–34.9', const Color(0xFFFF9800)),
                _buildBmiCategoryBadge('Obese Class 2', 'BMI:35.0–39.9', const Color(0xFFFF7043)),
                _buildBmiCategoryBadge('Obese Class 3', 'BMI:>=40.0', const Color(0xFFEF5350)),
                const SizedBox(height: 12),
                const Text(
                  '*This result does not apply to pregnant women and athletes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7043), Color(0xFFEF5350)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'GOT IT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBmiCategoryBadge(String label, String range, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            range,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSaveRecord() async {
    final w = _currentWeight;
    final h = _currentHeight;
    if (w <= 0 || h <= 0) return;

    final recordDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final recordId = widget.recordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final wbRecord = WeightBmiRecord(
      id: recordId,
      weightKg: w,
      heightCm: h,
      bmi: _calculatedBmi,
      date: recordDateTime,
      gender: _selectedGender,
      age: _selectedAge,
      note: '',
    );

    if (widget.recordToEdit != null) {
      await DatabaseHelper.instance.updateWeightBmiRecord(wbRecord);
    } else {
      await DatabaseHelper.instance.insertWeightBmiRecord(wbRecord);
    }

    final healthRecord = HealthRecord(
      id: recordId,
      type: 'Weight & BMI',
      value: "${_calculatedBmi.toStringAsFixed(1)} BMI",
      unit: 'BMI',
      date: recordDateTime,
      note: "${w.toStringAsFixed(1)} kg - ${_statusInfo.label}",
      icon: Icons.monitor_weight_rounded,
      iconColor: const Color(0xFF1E7BFA),
    );

    if (widget.onSave != null) {
      widget.onSave!(healthRecord);
    }

    if (mounted) {
      Navigator.of(context).pop(wbRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _statusInfo;
    final bmiVal = _calculatedBmi;

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
              // Date & Time Selector Pills (Top Row matching Screenshot 2)
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
                              "${_selectedDate.year} ${_selectedDate.month.toString().padLeft(2, '0')}",
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

              // Main Card 1: Your BMI Display & Weight/Height Inputs
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
                    // Top Header Row: Your BMI
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Your BMI',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          bmiVal.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Inputs Row (Weight kg & Height cm)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Weight(kg)',
                                    style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.unfold_more_rounded, color: Colors.black45, size: 16),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _weightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Height(cm)',
                                    style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.unfold_more_rounded, color: Colors.black45, size: 16),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _heightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
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
                    const SizedBox(height: 16),

                    // Age & Gender Sub-row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_circle_outlined, color: Colors.black54, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "Age: $_selectedAge",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(width: 1, height: 16, color: Colors.black26),
                        const SizedBox(width: 14),
                        Text(
                          _selectedGender,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Card 2: BMI Category Indicator & Normal Weight Box
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
                    // Status Hexagonal/Pill Badge
                    GestureDetector(
                      onTap: _showBmiTypesDialog,
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

                    // Healthy Weight Range Recommendation Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Normal Weight:',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info.normalWeightRangeText,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
