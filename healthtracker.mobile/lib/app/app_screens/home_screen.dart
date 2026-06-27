import 'package:flutter/material.dart';
import '../app_models/health_record.dart';
import 'blood_pressure_screen.dart';
import 'blood_sugar_screen.dart';
import 'heart_rate_screen.dart';
import 'weight_bmi_screen.dart';
import 'info_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HealthRecord> _records = [];

  String _selectedCategory = 'Heart Rate';
  int _currentTabIndex = 0;

  void _addRecord(HealthRecord record) {
    setState(() {
      _records.insert(0, record);
    });
  }

  HealthRecord? _getLatestRecordOf(String type) {
    try {
      return _records.firstWhere((r) => r.type == type);
    } catch (_) {
      return null;
    }
  }

  void _showAddRecordSheet({String? initialType}) {
    final valueController = TextEditingController();
    final noteController = TextEditingController();
    String selectedType = initialType ?? 'Heart Rate';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log Health Record',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white60),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Record Type Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0F19),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedType,
                          dropdownColor: const Color(0xFF0B0F19),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          items: <String>[
                            'Heart Rate',
                            'Blood Pressure',
                            'Blood Sugar',
                            'Weight & BMI'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                selectedType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Value Input
                    TextField(
                      controller: valueController,
                      decoration: InputDecoration(
                        labelText: selectedType == 'Blood Pressure' ? 'Value (e.g. 120/80)' : 'Value',
                        labelStyle: const TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: const Color(0xFF0B0F19),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: selectedType == 'Blood Pressure'
                          ? TextInputType.text
                          : const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    // Note Input
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: 'Note (Optional)',
                        labelStyle: const TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: const Color(0xFF0B0F19),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (valueController.text.trim().isEmpty) return;

                        IconData icon;
                        Color iconColor;
                        String unit;

                        switch (selectedType) {
                          case 'Heart Rate':
                            icon = Icons.favorite_rounded;
                            iconColor = const Color(0xFFE54A4A);
                            unit = 'bpm';
                            break;
                          case 'Blood Pressure':
                            icon = Icons.speed_rounded;
                            iconColor = const Color(0xFF1E8D89);
                            unit = 'mmHg';
                            break;
                          case 'Blood Sugar':
                            icon = Icons.water_drop_rounded;
                            iconColor = const Color(0xFFFA9314);
                            unit = 'mg/dL';
                            break;
                          case 'Weight & BMI':
                            icon = Icons.monitor_weight_rounded;
                            iconColor = const Color(0xFF1E7BFA);
                            unit = 'kg';
                            break;
                          default:
                            icon = Icons.directions_walk_rounded;
                            iconColor = const Color(0xFF10B981);
                            unit = 'steps';
                        }

                        final newRecord = HealthRecord(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: selectedType,
                          value: valueController.text.trim(),
                          unit: unit,
                          date: DateTime.now(),
                          note: noteController.text.trim(),
                          icon: icon,
                          iconColor: iconColor,
                        );

                        _addRecord(newRecord);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Save Record',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrackerBody() {
    return Column(
      children: [
        // Header Section
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tracker',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                _buildJewelIconButton(),
              ],
            ),
          ),
        ),
        // Main content container with rounded top corners
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F6F8), // Light grey background
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                children: [
                  // Lastest record card
                  _buildLatestRecordCard(),
                  const SizedBox(height: 16),
                  // Blood Pressure Card
                  _buildCategoryButton(
                    title: 'Blood Pressure',
                    color: const Color(0xFF1E8D89),
                    icon: _buildBloodPressureIcon(),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BloodPressureScreen(
                          records: _records,
                          onAddRecordTap: () => _showAddRecordSheet(initialType: 'Blood Pressure'),
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                  const SizedBox(height: 12),
                  // Blood Sugar Card
                  _buildCategoryButton(
                    title: 'Blood Sugar',
                    color: const Color(0xFFFA9314),
                    icon: _buildBloodSugarIcon(),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BloodSugarScreen(
                          records: _records,
                          onAddRecordTap: () => _showAddRecordSheet(initialType: 'Blood Sugar'),
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                  const SizedBox(height: 12),
                  // Heart Rate Card
                  _buildCategoryButton(
                    title: 'Heart Rate',
                    color: const Color(0xFFE54A4A),
                    icon: _buildHeartRateIcon(),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HeartRateScreen(
                          records: _records,
                          onAddRecordTap: () => _showAddRecordSheet(initialType: 'Heart Rate'),
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                  const SizedBox(height: 12),
                  // Weight & BMI Card
                  _buildCategoryButton(
                    title: 'Weight & BMI',
                    color: const Color(0xFF1E7BFA),
                    icon: _buildWeightBmiIcon(),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WeightBmiScreen(
                          records: _records,
                          onAddRecordTap: () => _showAddRecordSheet(initialType: 'Weight & BMI'),
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeBody;
    switch (_currentTabIndex) {
      case 0:
        activeBody = _buildTrackerBody();
        break;
      case 1:
        activeBody = const InfoScreen();
        break;
      case 2:
        activeBody = const SettingsScreen();
        break;
      default:
        activeBody = _buildTrackerBody();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Vibrant red background for header area
      body: activeBody,
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Tracker',
              isActive: _currentTabIndex == 0,
              onTap: () => setState(() => _currentTabIndex = 0),
            ),
            _buildNavItem(
              icon: Icons.chrome_reader_mode_outlined,
              label: 'Info',
              isActive: _currentTabIndex == 1,
              onTap: () => setState(() => _currentTabIndex = 1),
            ),
            _buildNavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              isActive: _currentTabIndex == 2,
              onTap: () => setState(() => _currentTabIndex = 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJewelIconButton() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFEE58), // Gold/Yellow
            Color(0xFFEC407A), // Pink/Rose
            Color(0xFFAB47BC), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.diamond_rounded,
          color: Color(0xFFFFD54F),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLatestRecordCard() {
    final latestRecord = _getLatestRecordOf(_selectedCategory);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lastest record',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                    items: <String>[
                      'Heart Rate',
                      'Blood Pressure',
                      'Blood Sugar',
                      'Weight & BMI'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: latestRecord == null
                ? const Text(
                    'No record found.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        '${latestRecord.value} ${latestRecord.unit}',
                        style: TextStyle(
                          color: latestRecord.iconColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Logged on ${latestRecord.date.day}/${latestRecord.date.month} at ${latestRecord.date.hour.toString().padLeft(2, '0')}:${latestRecord.date.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required String title,
    required Color color,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 96,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? const Color(0xFFE53935) : Colors.grey[500]!;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'Tracker')
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.home_rounded, color: color, size: 28),
                  Positioned(
                    bottom: 5,
                    child: Icon(Icons.favorite_rounded, color: Colors.white, size: 10),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Icon(Icons.favorite_rounded, color: color, size: 8),
                  ),
                ],
              )
            else
              Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodPressureIcon() {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF147A77).withAlpha(100),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Color(0xFF4DB6AC),
              size: 40,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 44,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00ACC1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Center(
                        child: Text(
                          '120',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 6,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 3,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodSugarIcon() {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE67E22).withAlpha(80),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 12,
            child: Container(
              width: 32,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBDC3C7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Center(
                      child: Text(
                        '95',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 14,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.water_drop_rounded,
                  color: Color(0xFFF1C40F),
                  size: 26,
                ),
                Positioned(
                  top: 8,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateIcon() {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: Colors.white.withAlpha(40),
            size: 60,
          ),
          Icon(
            Icons.favorite_rounded,
            color: Colors.white.withAlpha(80),
            size: 46,
          ),
          const Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 32,
          ),
          Positioned(
            child: Icon(
              Icons.show_chart_rounded,
              color: const Color(0xFFE54A4A),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightBmiIcon() {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withAlpha(80),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]!),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -0.4,
                  child: Align(
                    alignment: const Alignment(0, -0.6),
                    child: Container(
                      width: 2,
                      height: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
