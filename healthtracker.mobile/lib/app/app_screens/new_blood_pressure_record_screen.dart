import 'package:flutter/material.dart';
import '../app_models/blood_pressure_record.dart';
import '../app_database/db_helper.dart';

class NewBloodPressureRecordScreen extends StatefulWidget {
  final BloodPressureRecord? recordToEdit;
  const NewBloodPressureRecordScreen({super.key, this.recordToEdit});

  @override
  State<NewBloodPressureRecordScreen> createState() => _NewBloodPressureRecordScreenState();
}

class _NewBloodPressureRecordScreenState extends State<NewBloodPressureRecordScreen> {
  // Value states
  int _sys = 119;
  int _dia = 79;
  int _pul = 62;

  // Controllers for ListWheelScrollView
  late FixedExtentScrollController _sysController;
  late FixedExtentScrollController _diaController;
  late FixedExtentScrollController _pulController;

  // Date and time states
  DateTime _selectedDate = DateTime.now();

  // Position, Arm and Tag states
  String _bodyPosition = 'None'; // 'None', 'Standing', 'Sitting', 'Lying'
  String _measuredArm = 'None';  // 'None', 'Left', 'Right'
  String _selectedTag = 'None';  // 'None', 'Before meal', 'After meal', etc.
  final String _note = '';

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      _sys = widget.recordToEdit!.sys;
      _dia = widget.recordToEdit!.dia;
      _pul = widget.recordToEdit!.pul;
      _selectedDate = widget.recordToEdit!.date;
      _bodyPosition = widget.recordToEdit!.bodyPosition;
      _measuredArm = widget.recordToEdit!.measuredArm;
      _selectedTag = widget.recordToEdit!.tag;
    }
    _sysController = FixedExtentScrollController(initialItem: _sys - 50);
    _diaController = FixedExtentScrollController(initialItem: _dia - 30);
    _pulController = FixedExtentScrollController(initialItem: _pul - 30);
  }

  @override
  void dispose() {
    _sysController.dispose();
    _diaController.dispose();
    _pulController.dispose();
    super.dispose();
  }

  // Helpers for formatting
  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFE53935)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFE53935)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  // Get current BP category details dynamically
  BPCategoryInfo _getCurrentBPInfo() {
    // Generate temporary model instance to leverage get categoryInfo helper
    final tempRecord = BloodPressureRecord(
      id: '',
      sys: _sys,
      dia: _dia,
      pul: _pul,
      date: _selectedDate,
      bodyPosition: _bodyPosition,
      measuredArm: _measuredArm,
      tag: _selectedTag,
      note: _note,
    );
    return tempRecord.categoryInfo;
  }

  // Show tags selection dialog
  void _showTagPickerDialog() {
    final tags = ['None', 'Before meal', 'After meal', 'Before sleep', 'After sleep', 'Before exercise', 'After exercise'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Tag', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                return ListTile(
                  title: Text(tag, style: const TextStyle(color: Colors.black87)),
                  trailing: _selectedTag == tag ? const Icon(Icons.check_rounded, color: Color(0xFFE53935)) : null,
                  onTap: () {
                    setState(() => _selectedTag = tag);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Custom ListWheelScrollView builder
  Widget _buildWheelPicker({
    required String title,
    required String unit,
    required FixedExtentScrollController controller,
    required int min,
    required int max,
    required int currentValue,
    required ValueChanged<int> onChanged,
    required Color activeColor,
  }) {
    final itemsCount = max - min + 1;

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        Text(
          "($unit)",
          style: const TextStyle(fontSize: 11, color: Colors.black38),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 36,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(min + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final val = min + index;
                final isSelected = val == currentValue;

                return Center(
                  child: Text(
                    val.toString(),
                    style: TextStyle(
                      fontSize: isSelected ? 22 : 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? activeColor : Colors.black26,
                    ),
                  ),
                );
              },
              childCount: itemsCount,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bpInfo = _getCurrentBPInfo();

    return Scaffold(
      backgroundColor: const Color(0xFF1E293B), // Dark Header Background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.recordToEdit != null ? 'Edit record' : 'New record',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey panel
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // SYS, DIA, PUL Wheel Pickers Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Selected item visual marker lines
                          Positioned(
                            top: 50,
                            bottom: 12,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildWheelPicker(
                                  title: 'SYS',
                                  unit: 'mmHg',
                                  controller: _sysController,
                                  min: 50,
                                  max: 250,
                                  currentValue: _sys,
                                  onChanged: (val) => setState(() => _sys = val),
                                  activeColor: bpInfo.color,
                                ),
                              ),
                              Container(width: 1, height: 100, color: Colors.grey[100]),
                              Expanded(
                                child: _buildWheelPicker(
                                  title: 'DIA',
                                  unit: 'mmHg',
                                  controller: _diaController,
                                  min: 30,
                                  max: 150,
                                  currentValue: _dia,
                                  onChanged: (val) => setState(() => _dia = val),
                                  activeColor: bpInfo.color,
                                ),
                              ),
                              Container(width: 1, height: 100, color: Colors.grey[100]),
                              Expanded(
                                child: _buildWheelPicker(
                                  title: 'PUL',
                                  unit: 'BPM',
                                  controller: _pulController,
                                  min: 30,
                                  max: 200,
                                  currentValue: _pul,
                                  onChanged: (val) => setState(() => _pul = val),
                                  activeColor: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Badge Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Status Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              color: bpInfo.color.withAlpha(20),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: bpInfo.color.withAlpha(60), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  bpInfo.label,
                                  style: TextStyle(
                                    color: bpInfo.color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.help_outline_rounded, color: bpInfo.color, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Range Subtitle
                          Text(
                            bpInfo.rangeText,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Advisory Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F3F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bpInfo.advice,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date & Time Pills
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, color: Colors.black54, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(_selectedDate),
                                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, color: Colors.black54, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTime(_selectedDate),
                                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Position, Arm and Tag Selectors Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Body Position
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Body position',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _bodyPosition,
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildPositionIconButton('Standing', Icons.person_outline_rounded),
                              const SizedBox(width: 12),
                              _buildPositionIconButton('Sitting', Icons.chair_alt_rounded),
                              const SizedBox(width: 12),
                              _buildPositionIconButton('Lying', Icons.airline_seat_flat_rounded),
                            ],
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F3F5)),

                          // Measured Arm
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Measured arm',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _measuredArm,
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildArmIconButton('Left', Icons.back_hand_rounded),
                              const SizedBox(width: 12),
                              _buildArmIconButton('Right', Icons.back_hand_outlined),
                            ],
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F3F5)),

                          // Tag Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tag',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showTagPickerDialog,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECEFF1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _selectedTag,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Save Button
                    GestureDetector(
                      onTap: () async {
                        final recordId = widget.recordToEdit != null
                            ? widget.recordToEdit!.id
                            : DateTime.now().millisecondsSinceEpoch.toString();

                        final record = BloodPressureRecord(
                          id: recordId,
                          sys: _sys,
                          dia: _dia,
                          pul: _pul,
                          date: _selectedDate,
                          bodyPosition: _bodyPosition,
                          measuredArm: _measuredArm,
                          tag: _selectedTag,
                          note: _getCurrentBPInfo().advice,
                        );

                        final navigator = Navigator.of(context);
                        if (widget.recordToEdit != null) {
                          await DatabaseHelper.instance.updateRecord(record);
                        } else {
                          await DatabaseHelper.instance.insertRecord(record);
                        }
                        navigator.pop(true);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF8A65),
                              Color(0xFFE53935),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53935).withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
        ],
      ),
    );
  }

  // Selector icon button helpers
  Widget _buildPositionIconButton(String position, IconData icon) {
    final isSelected = _bodyPosition == position;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bodyPosition = isSelected ? 'None' : position;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935).withAlpha(20) : const Color(0xFFECEFF1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFE53935) : Colors.black54,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildArmIconButton(String arm, IconData icon) {
    final isSelected = _measuredArm == arm;
    return GestureDetector(
      onTap: () {
        setState(() {
          _measuredArm = isSelected ? 'None' : arm;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935).withAlpha(20) : const Color(0xFFECEFF1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFE53935) : Colors.black54,
          size: 24,
        ),
      ),
    );
  }
}
