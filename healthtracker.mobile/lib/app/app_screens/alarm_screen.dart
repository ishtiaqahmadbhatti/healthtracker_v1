// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'vitals_alarm_screen.dart';

class AlarmItem {
  final String title;
  final String frequency;
  final String nextExecution;
  final Widget icon;
  bool isEnabled;

  AlarmItem({
    required this.title,
    required this.frequency,
    required this.nextExecution,
    required this.icon,
    this.isEnabled = false,
  });
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late final List<AlarmItem> _alarms;

  @override
  void initState() {
    super.initState();
    _alarms = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header background (vibrant red)
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
                  const Text(
                    'Alarm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Body Panel
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey panel background
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _alarms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAlarmClockGraphic(),
                          const SizedBox(height: 24),
                          const Text(
                            'No reminder yet. Add your first\nreminder',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 80), // Offset slightly for FAB balance
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
                      itemCount: _alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = _alarms[index];
                        return _buildAlarmCard(alarm);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFEF5350), // Red
              Color(0xFFE53935), // Dark Red
            ],
          ),
        ),
        child: FloatingActionButton(
          onPressed: () => _showSelectTypeDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  Widget _buildAlarmCard(AlarmItem alarm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Grey card background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: White circle icon background
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: alarm.icon),
          ),
          const SizedBox(width: 16),
          // Middle: Text descriptions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarm.frequency,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarm.nextExecution,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Right: Toggle Switch
          Switch(
            value: alarm.isEnabled,
            onChanged: (newValue) {
              setState(() {
                alarm.isEnabled = newValue;
              });
            },
            activeThumbColor: const Color(0xFFE53935),
            activeTrackColor: const Color(0xFFFFCDD2),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black26,
          ),
        ],
      ),
    );
  }

  // Badges
  Widget _buildBpIcon() {
    return const Icon(
      Icons.health_and_safety_rounded,
      color: Color(0xFF1E8D89),
      size: 32,
    );
  }

  Widget _buildHeartRateIcon() {
    return const Icon(
      Icons.favorite_rounded,
      color: Color(0xFFE54A4A),
      size: 32,
    );
  }

  Widget _buildMedicationIcon() {
    return const Icon(
      Icons.vaccines_rounded,
      color: Color(0xFFFA9314),
      size: 32,
    );
  }

  void _showSelectTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24), // Extends dialog width on small devices
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias, // Clips the header gradient container to dialog shape
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red gradient header banner
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEF5350), // Red
                      Color(0xFFE53935), // Dark Red
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select type',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Body card choices list
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    _buildTypeItem(
                      context,
                      title: 'Blood Pressure',
                      icon: _buildBpDialogIcon(),
                      onTap: () => _handleTypeSelected(context, 'Blood Pressure'),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeItem(
                      context,
                      title: 'Blood Sugar',
                      icon: _buildBloodSugarDialogIcon(),
                      onTap: () => _handleTypeSelected(context, 'Blood Sugar'),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeItem(
                      context,
                      title: 'Heart Rate',
                      icon: _buildHeartRateDialogIcon(),
                      onTap: () => _handleTypeSelected(context, 'Heart Rate'),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeItem(
                      context,
                      title: 'Medicine',
                      icon: _buildMedicationDialogIcon(),
                      onTap: () => _handleTypeSelected(context, 'Medicine'),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeItem(
                      context,
                      title: 'Custom',
                      icon: _buildCustomDialogIcon(),
                      onTap: () => _handleTypeSelected(context, 'Custom'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeItem(
    BuildContext context, {
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8), // Soft off-white for list card rows
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(child: icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTypeSelected(BuildContext context, String type) async {
    Navigator.of(context).pop();
    
    if (type == 'Blood Pressure' || 
        type == 'Blood Sugar' || 
        type == 'Heart Rate' || 
        type == 'Medicine' || 
        type == 'Custom') {
        
      final VitalAlarmType vitalType;
      switch (type) {
        case 'Blood Pressure':
          vitalType = VitalAlarmType.bloodPressure;
          break;
        case 'Blood Sugar':
          vitalType = VitalAlarmType.bloodSugar;
          break;
        case 'Heart Rate':
          vitalType = VitalAlarmType.heartRate;
          break;
        case 'Medicine':
          vitalType = VitalAlarmType.medicine;
          break;
        case 'Custom':
        default:
          vitalType = VitalAlarmType.custom;
          break;
      }

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VitalsAlarmScreen(type: vitalType),
        ),
      );
      
      if (result is AlarmItem) {
        setState(() {
          _alarms.add(result);
        });
      }
    }
  }

  Widget _buildBpDialogIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E8D89).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.health_and_safety_rounded,
        color: Color(0xFF1E8D89),
        size: 24,
      ),
    );
  }

  Widget _buildBloodSugarDialogIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.water_drop_rounded,
        color: Color(0xFF9C27B0),
        size: 24,
      ),
    );
  }

  Widget _buildHeartRateDialogIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE54A4A).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.favorite_rounded,
        color: Color(0xFFE54A4A),
        size: 24,
      ),
    );
  }

  Widget _buildMedicationDialogIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFFA9314).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.vaccines_rounded,
        color: Color(0xFFFA9314),
        size: 24,
      ),
    );
  }

  Widget _buildCustomDialogIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E7BFA).withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_active_rounded,
        color: Color(0xFF1E7BFA),
        size: 24,
      ),
    );
  }

  Widget _buildAlarmClockGraphic() {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sound waves left
          Positioned(
            left: 20,
            top: 30,
            child: Transform.rotate(
              angle: -0.4,
              child: CustomPaint(
                size: const Size(30, 60),
                painter: _SoundWavePainter(isLeft: true),
              ),
            ),
          ),
          // Sound waves right
          Positioned(
            right: 20,
            top: 30,
            child: Transform.rotate(
              angle: 0.4,
              child: CustomPaint(
                size: const Size(30, 60),
                painter: _SoundWavePainter(isLeft: false),
              ),
            ),
          ),
          
          // Shadow
          Positioned(
            bottom: 5,
            child: Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(20),
                borderRadius: const BorderRadius.all(Radius.elliptical(60, 6)),
              ),
            ),
          ),

          // Clock legs
          Positioned(
            bottom: 10,
            left: 60,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(width: 8, height: 18, color: Colors.grey[800]),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 60,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(width: 8, height: 18, color: Colors.grey[800]),
            ),
          ),

          // Left Bell
          Positioned(
            top: 36,
            left: 48,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 40,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBC02D), // Gold/yellow
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
            ),
          ),
          // Right Bell
          Positioned(
            top: 36,
            right: 48,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 40,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBC02D), // Gold/yellow
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
            ),
          ),

          // Main Clock Body
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F), // Bright Yellow
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFBC02D), width: 6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Hour indicator dots
                    for (int i = 0; i < 12; i++)
                      Transform.rotate(
                        angle: i * 30 * 3.14159 / 180,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Center pin
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Hour hand
                    Transform.rotate(
                      angle: -0.8,
                      child: Align(
                        alignment: const Alignment(0, -0.5),
                        child: Container(
                          width: 3,
                          height: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Minute hand
                    Transform.rotate(
                      angle: 0.2,
                      child: Align(
                        alignment: const Alignment(0, -0.6),
                        child: Container(
                          width: 2,
                          height: 26,
                          color: Colors.black87,
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

class _SoundWavePainter extends CustomPainter {
  final bool isLeft;
  _SoundWavePainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Small wave
    canvas.drawArc(
      Rect.fromLTWH(isLeft ? 10 : -20, 10, 40, 40),
      isLeft ? 2.3 : -0.8,
      1.6,
      false,
      paint,
    );

    // Large wave
    canvas.drawArc(
      Rect.fromLTWH(isLeft ? 0 : -30, 0, 60, 60),
      isLeft ? 2.3 : -0.8,
      1.6,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
