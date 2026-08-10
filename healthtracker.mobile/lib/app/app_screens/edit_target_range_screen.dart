import 'package:flutter/material.dart';

class TargetRangeItem {
  final String title;
  double lowMax;
  double normalMax;
  double preDiabetesMax;

  TargetRangeItem({
    required this.title,
    required this.lowMax,
    required this.normalMax,
    required this.preDiabetesMax,
  });
}

class EditTargetRangeScreen extends StatefulWidget {
  final String initialUnit;
  final Function(String unit, Map<String, TargetRangeItem> ranges)? onSave;

  const EditTargetRangeScreen({
    super.key,
    this.initialUnit = 'mg/dL',
    this.onSave,
  });

  @override
  State<EditTargetRangeScreen> createState() => _EditTargetRangeScreenState();
}

class _EditTargetRangeScreenState extends State<EditTargetRangeScreen> {
  late String _currentUnit;

  late Map<String, TargetRangeItem> _mgRanges;
  late Map<String, TargetRangeItem> _mmolRanges;

  final Map<String, bool> _expandedMap = {};

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.initialUnit;

    // Default mg/dL ranges
    _mgRanges = {
      'Default': TargetRangeItem(title: 'Default', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
      'Fasting': TargetRangeItem(title: 'Fasting', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
      'Before a meal': TargetRangeItem(title: 'Before a meal', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
      'After a meal (1h)': TargetRangeItem(title: 'After a meal (1h)', lowMax: 71.0, normalMax: 139.0, preDiabetesMax: 152.0),
      'After a meal (2h)': TargetRangeItem(title: 'After a meal (2h)', lowMax: 71.0, normalMax: 84.0, preDiabetesMax: 125.0),
      'Asleep': TargetRangeItem(title: 'Asleep', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
      'Before Exercise': TargetRangeItem(title: 'Before Exercise', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
      'After exercise': TargetRangeItem(title: 'After exercise', lowMax: 71.0, normalMax: 98.0, preDiabetesMax: 125.0),
    };

    // Default mmol/l ranges
    _mmolRanges = {
      'Default': TargetRangeItem(title: 'Default', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
      'Fasting': TargetRangeItem(title: 'Fasting', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
      'Before a meal': TargetRangeItem(title: 'Before a meal', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
      'After a meal (1h)': TargetRangeItem(title: 'After a meal (1h)', lowMax: 3.9, normalMax: 7.7, preDiabetesMax: 8.4),
      'After a meal (2h)': TargetRangeItem(title: 'After a meal (2h)', lowMax: 3.9, normalMax: 4.6, preDiabetesMax: 6.9),
      'Asleep': TargetRangeItem(title: 'Asleep', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
      'Before Exercise': TargetRangeItem(title: 'Before Exercise', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
      'After exercise': TargetRangeItem(title: 'After exercise', lowMax: 3.9, normalMax: 5.4, preDiabetesMax: 6.9),
    };

    for (var key in _mgRanges.keys) {
      _expandedMap[key] = true;
    }
  }

  Map<String, TargetRangeItem> get _activeRangesMap {
    return _currentUnit == 'mg/dL' ? _mgRanges : _mmolRanges;
  }

  void _showEditRangeModal(String title) {
    final item = _activeRangesMap[title]!;
    final step = _currentUnit == 'mmol/l' ? 0.1 : 1.0;

    final lowCtrl = TextEditingController(text: item.lowMax.toStringAsFixed(1));
    final normalCtrl = TextEditingController(text: item.normalMax.toStringAsFixed(1));
    final preCtrl = TextEditingController(text: item.preDiabetesMax.toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final curLow = double.tryParse(lowCtrl.text) ?? item.lowMax;
            final curNormal = double.tryParse(normalCtrl.text) ?? item.normalMax;
            final curPre = double.tryParse(preCtrl.text) ?? item.preDiabetesMax;

            final normalStart = (curLow + step).toStringAsFixed(1);
            final preStart = (curNormal + step).toStringAsFixed(1);

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Bar: Default          Unit: mg/dL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Unit: $_currentUnit',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 20),

                    // Row 1: Low
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2979FF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Low',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('< ', style: TextStyle(fontSize: 16, color: Colors.black87)),
                            Container(
                              width: 72,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: lowCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                                onChanged: (v) => setModalState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row 2: Normal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Normal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('$normalStart - ', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                            Container(
                              width: 72,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: normalCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                                onChanged: (v) => setModalState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row 3: Pre - Diabetes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFBC02D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pre - Diabetes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$preStart - ${curPre.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row 4: Diabetes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5722),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Diabetes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('≥ ', style: TextStyle(fontSize: 16, color: Colors.black87)),
                            Container(
                              width: 72,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: preCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                                onChanged: (v) => setModalState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Reset to suggest value Link
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          if (_currentUnit == 'mg/dL') {
                            lowCtrl.text = "71.0";
                            normalCtrl.text = "98.0";
                            preCtrl.text = "125.0";
                          } else {
                            lowCtrl.text = "3.9";
                            normalCtrl.text = "5.4";
                            preCtrl.text = "6.9";
                          }
                        });
                      },
                      child: const Text(
                        'Reset to suggest value',
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons Row (Cancel | Save)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              item.lowMax = double.tryParse(lowCtrl.text) ?? item.lowMax;
                              item.normalMax = double.tryParse(normalCtrl.text) ?? item.normalMax;
                              item.preDiabetesMax = double.tryParse(preCtrl.text) ?? item.preDiabetesMax;
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Color(0xFFEF5350),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  void _showDoctorInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Avatar Icon
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: Color(0xFFECEFF1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.face_3_rounded,
                          color: Color(0xFF78909C),
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Doctor Advice Explanation Text
                    const Expanded(
                      child: Text(
                        'Blood sugar ranges can vary from person to person due to age, being diabetic, etc. You can adjust the range after consulting your doctor.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Right Aligned "Got it" Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        color: Color(0xFFEF5350),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5350), // Red header background
      body: SafeArea(
        child: Column(
          children: [
            // 1. Red Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Edit target range',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline_rounded, color: Colors.white, size: 24),
                        onPressed: _showDoctorInfoDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Unit Switcher Row
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      const Text(
                        'Unit:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Segmented Buttons: mg/dL | mmol/l
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentUnit = 'mg/dL';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentUnit == 'mg/dL' ? Colors.white : Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'mg/dL',
                                      style: TextStyle(
                                        color: _currentUnit == 'mg/dL' ? Colors.black87 : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentUnit = 'mmol/l';
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentUnit == 'mmol/l' ? Colors.white : Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'mmol/l',
                                      style: TextStyle(
                                        color: _currentUnit == 'mmol/l' ? Colors.black87 : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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

            // 2. Light Body with Expandable Cards List
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: _activeRangesMap.length,
                  itemBuilder: (context, index) {
                    final key = _activeRangesMap.keys.elementAt(index);
                    final item = _activeRangesMap[key]!;
                    final isExpanded = _expandedMap[key] ?? true;

                    return _buildStateCard(key, item, isExpanded);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCard(String key, TargetRangeItem item, bool isExpanded) {
    final step = _currentUnit == 'mmol/l' ? 0.1 : 1.0;
    final lowStr = "<${item.lowMax.toStringAsFixed(1)}";
    final normalStr = "${(item.lowMax + step).toStringAsFixed(1)} - ${item.normalMax.toStringAsFixed(1)}";
    final preStr = "${(item.normalMax + step).toStringAsFixed(1)} - ${item.preDiabetesMax.toStringAsFixed(1)}";
    final diabetesStr = "≥${(item.preDiabetesMax + step).toStringAsFixed(1)}";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showEditRangeModal(key),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_outlined, color: Colors.black54, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedMap[key] = !isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBEBEB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Content
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: Column(
                children: [
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),
                  _buildRangeRow(color: const Color(0xFF2979FF), label: 'Low', range: lowStr),
                  const SizedBox(height: 10),
                  _buildRangeRow(color: const Color(0xFF4CAF50), label: 'Normal', range: normalStr),
                  const SizedBox(height: 10),
                  _buildRangeRow(color: const Color(0xFFFBC02D), label: 'Pre - Diabetes', range: preStr),
                  const SizedBox(height: 10),
                  _buildRangeRow(color: const Color(0xFFFF5722), label: 'Diabetes', range: diabetesStr),
                ],
              ),
            ),
        ],
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
