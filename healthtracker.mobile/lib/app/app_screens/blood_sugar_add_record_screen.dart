import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import '../app_models/blood_sugar_record.dart';
import '../app_database/db_helper.dart';
import 'edit_target_range_screen.dart';

class BloodSugarAddRecordScreen extends StatefulWidget {
  final Function(HealthRecord record)? onSave;
  final BloodSugarRecord? sugarRecordToEdit;

  const BloodSugarAddRecordScreen({
    super.key,
    this.onSave,
    this.sugarRecordToEdit,
  });

  @override
  State<BloodSugarAddRecordScreen> createState() => _BloodSugarAddRecordScreenState();
}

class _BloodSugarAddRecordScreenState extends State<BloodSugarAddRecordScreen> {
  late final TextEditingController _valueController;
  String _selectedState = 'Default';
  String _selectedUnit = 'mg/dL'; // 'mg/dL' or 'mmol/l'
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Custom Target Ranges (Default in mg/dL)
  final double _lowMax = 71.0;
  final double _normalMax = 98.0;
  final double _preDiabetesMax = 125.0;

  final List<String> _measurementStates = [
    'Default',
    'Fasting',
    'Before a meal',
    'After a meal (1h)',
    'After a meal (2h)',
    'Asleep',
    'Before Exercise',
    'After exercise',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.sugarRecordToEdit != null) {
      _valueController = TextEditingController(text: widget.sugarRecordToEdit!.value.toStringAsFixed(1));
      _selectedUnit = widget.sugarRecordToEdit!.unit;
      _selectedState = widget.sugarRecordToEdit!.state;
      _selectedDate = widget.sugarRecordToEdit!.date;
      _selectedTime = TimeOfDay.fromDateTime(widget.sugarRecordToEdit!.date);
    } else {
      _valueController = TextEditingController(text: "80.0");
    }
    _valueController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  double get _currentNumericValue {
    return double.tryParse(_valueController.text.trim()) ?? 0.0;
  }

  // Calculate current status (Low, Normal, Pre - Diabetes, Diabetes)
  Map<String, dynamic> get _statusInfo {
    final val = _currentNumericValue;

    bool isLow;
    bool isNormal;
    bool isPre;

    if (_selectedUnit == 'mmol/l') {
      isLow = val < 3.9;
      isNormal = val >= 3.9 && val <= 5.4;
      isPre = val >= 5.5 && val <= 6.9;
    } else {
      isLow = val < _lowMax;
      isNormal = val >= _lowMax && val <= _normalMax;
      isPre = val > _normalMax && val <= _preDiabetesMax;
    }

    if (isLow) {
      return {
        'status': 'Low',
        'color': const Color(0xFF2979FF),
        'bgColor': const Color(0xFFE3F2FD),
        'borderColor': const Color(0xFF90CAF9),
      };
    } else if (isNormal) {
      return {
        'status': 'Normal',
        'color': const Color(0xFF4CAF50),
        'bgColor': const Color(0xFFE8F5E9),
        'borderColor': const Color(0xFFA5D6A7),
      };
    } else if (isPre) {
      return {
        'status': 'Pre - Diabetes',
        'color': const Color(0xFFFBC02D),
        'bgColor': const Color(0xFFFFFDE7),
        'borderColor': const Color(0xFFFFE082),
      };
    } else {
      return {
        'status': 'Diabetes',
        'color': const Color(0xFFFF5722),
        'bgColor': const Color(0xFFFFEBEE),
        'borderColor': const Color(0xFFEF9A9A),
      };
    }
  }

  void _toggleUnit(String newUnit) {
    if (_selectedUnit == newUnit) return;
    final currentVal = _currentNumericValue;
    if (newUnit == 'mmol/l') {
      // mg/dL to mmol/l (/ 18.0)
      final converted = (currentVal / 18.0);
      _valueController.text = converted.toStringAsFixed(1);
    } else {
      // mmol/l to mg/dL (* 18.0)
      final converted = (currentVal * 18.0);
      _valueController.text = converted.toStringAsFixed(1);
    }
    setState(() {
      _selectedUnit = newUnit;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEF5350),
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
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEF5350),
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
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year.toString().substring(2)}";
  }

  String _formatTime(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }



  void _showTypeOfBloodSugarDialog() {
    String tempSelected = _selectedState;
    String tempUnit = _selectedUnit;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Range strings based on tempUnit
            final isMmol = tempUnit == 'mmol/l';
            final lowStr = isMmol ? "< 3.9 mmol/l" : "< 71.0 mg/dL";
            final normalStr = isMmol ? "4.0 - 5.4 mmol/l" : "72.0 - 98.0 mg/dL";
            final preStr = isMmol ? "5.5 - 6.9 mmol/l" : "99.0 - 125.0 mg/dL";
            final diabStr = isMmol ? "≥ 7.0 mmol/l" : "≥ 126.0 mg/dL";

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'Type of Blood Sugar',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Dropdown Container
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBDBDBD), width: 1.2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempSelected,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 6,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87, size: 26),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                tempSelected = newValue;
                              });
                            }
                          },
                          items: _measurementStates.map<DropdownMenuItem<String>>((String val) {
                            final isSelected = val == tempSelected;
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    val,
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFFEF5350) : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_rounded, color: Color(0xFFEF5350), size: 20),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Unit Segmented Switcher Row
                    Row(
                      children: [
                        const Text(
                          'Unit:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempUnit = 'mg/dL';
                              });
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: tempUnit == 'mg/dL' ? Colors.black : const Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'mg/dL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempUnit = 'mmol/l';
                              });
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: tempUnit == 'mmol/l' ? Colors.black : const Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'mmol/l',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4 Colored Status Range Cards
                    _buildDialogStatusCard(
                      bgColor: const Color(0xFFD6E4FF),
                      textColor: const Color(0xFF2979FF),
                      label: 'Low',
                      rangeStr: lowStr,
                    ),
                    const SizedBox(height: 10),
                    _buildDialogStatusCard(
                      bgColor: const Color(0xFFE2F7E2),
                      textColor: const Color(0xFF4CAF50),
                      label: 'Normal',
                      rangeStr: normalStr,
                    ),
                    const SizedBox(height: 10),
                    _buildDialogStatusCard(
                      bgColor: const Color(0xFFFFF7C2),
                      textColor: const Color(0xFFFBC02D),
                      label: 'Pre - Diabetes',
                      rangeStr: preStr,
                    ),
                    const SizedBox(height: 10),
                    _buildDialogStatusCard(
                      bgColor: const Color(0xFFFFDEC9),
                      textColor: const Color(0xFFFF5722),
                      label: 'Diabetes',
                      rangeStr: diabStr,
                    ),
                    const SizedBox(height: 24),

                    // GOT IT Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedUnit != tempUnit) {
                            _toggleUnit(tempUnit);
                          }
                          setState(() {
                            _selectedState = tempSelected;
                          });
                          Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF5350),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'GOT IT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogStatusCard({
    required Color bgColor,
    required Color textColor,
    required String label,
    required String rangeStr,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rangeStr,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSaveRecord() async {
    final valText = _valueController.text.trim();
    final doubleVal = double.tryParse(valText);
    if (doubleVal == null) return;

    final recordDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final recordId = widget.sugarRecordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final dbSugarRecord = BloodSugarRecord(
      id: recordId,
      value: doubleVal,
      unit: _selectedUnit,
      date: recordDateTime,
      state: _selectedState,
      note: '',
    );

    if (widget.sugarRecordToEdit != null) {
      await DatabaseHelper.instance.updateSugarRecord(dbSugarRecord);
    } else {
      await DatabaseHelper.instance.insertSugarRecord(dbSugarRecord);
    }

    final healthRecord = HealthRecord(
      id: recordId,
      type: 'Blood Sugar',
      value: "$valText $_selectedUnit",
      unit: _selectedUnit,
      date: recordDateTime,
      note: "$_selectedState - ${_statusInfo['status']}",
      icon: Icons.water_drop_rounded,
      iconColor: const Color(0xFF9C27B0),
    );

    if (widget.onSave != null) {
      widget.onSave!(healthRecord);
    }

    if (mounted) {
      Navigator.of(context).pop(dbSugarRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusData = _statusInfo;

    return Scaffold(
      backgroundColor: const Color(0xFF181818), // Dark top background
      body: SafeArea(
        child: Column(
          children: [
            // AppBar / Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'New record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Light Grey Body Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7), // Light grey body
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  child: Column(
                    children: [
                      // 1. Measurement State Dropdown Card
                      Container(
                        width: double.infinity,
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(8),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedState,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 6,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black87, size: 26),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedState = newValue;
                                });
                              }
                            },
                            items: _measurementStates.map<DropdownMenuItem<String>>((String val) {
                              final isSelected = val == _selectedState;
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      val,
                                      style: TextStyle(
                                        color: isSelected ? const Color(0xFFEF5350) : Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_rounded, color: Color(0xFFEF5350), size: 20),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Numeric Input & Unit Selector Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(8),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Input Box
                            Container(
                              width: 150,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _valueController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),

                            // Right: Units Toggle Options
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => _toggleUnit('mg/dL'),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 18,
                                        color: _selectedUnit == 'mg/dL' ? const Color(0xFF2979FF) : Colors.transparent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'mg/dL',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedUnit == 'mg/dL' ? const Color(0xFF2979FF) : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () => _toggleUnit('mmol/l'),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow_rounded,
                                        size: 18,
                                        color: _selectedUnit == 'mmol/l' ? const Color(0xFF2979FF) : Colors.transparent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'mmol/l',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedUnit == 'mmol/l' ? const Color(0xFF2979FF) : Colors.black87,
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

                      // 3. Dynamic Health Status Badge & Ranges Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(8),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Hexagonal / Pill Status Badge
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: statusData['bgColor'],
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: statusData['borderColor'], width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      statusData['status'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: statusData['color'],
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _showTypeOfBloodSugarDialog,
                                    child: Icon(
                                      Icons.help_outline_rounded,
                                      color: statusData['color'].withAlpha(200),
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Ranges Legend Table Container
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _buildRangeRow(
                                    color: const Color(0xFF2979FF),
                                    label: 'Low',
                                    range: _selectedUnit == 'mmol/l' ? '<3.9' : '<71.0',
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRangeRow(
                                    color: const Color(0xFF4CAF50),
                                    label: 'Normal',
                                    range: _selectedUnit == 'mmol/l' ? '4.0 - 5.4' : '72.0 - 98.0',
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRangeRow(
                                    color: const Color(0xFFFBC02D),
                                    label: 'Pre - Diabetes',
                                    range: _selectedUnit == 'mmol/l' ? '5.5 - 6.9' : '99.0 - 125.0',
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRangeRow(
                                    color: const Color(0xFFFF5722),
                                    label: 'Diabetes',
                                    range: _selectedUnit == 'mmol/l' ? '≥7.0' : '≥126.0',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Edit target range link button
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditTargetRangeScreen(
                                      initialUnit: _selectedUnit,
                                    ),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit_outlined, color: Color(0xFF2979FF), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Edit target range',
                                    style: TextStyle(
                                      color: Color(0xFF2979FF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Date & Time Selection Pill Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(8),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, color: Colors.black54, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatDate(_selectedDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectTime,
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(8),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time_rounded, color: Colors.black54, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(_selectedTime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // 5. Save Button
                      Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF5252),
                              Color(0xFFEF5350),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF5350).withAlpha(80),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _onSaveRecord,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29),
                            ),
                          ),
                          child: const Text(
                            'SAVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
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
      ),
    );
  }

  Widget _buildRangeRow({
    required Color color,
    required String label,
    required String range,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Text(
          range,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
