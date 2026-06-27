import 'package:flutter/material.dart';
import '../app_models/health_record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<HealthRecord> _records = [
    HealthRecord(
      id: '1',
      type: 'Heart Rate',
      value: '72',
      unit: 'bpm',
      date: DateTime.now().subtract(const Duration(hours: 1)),
      note: 'Resting heart rate in morning',
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFFEF4444),
    ),
    HealthRecord(
      id: '2',
      type: 'Blood Pressure',
      value: '120/80',
      unit: 'mmHg',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      note: 'Normal reading after walk',
      icon: Icons.speed_rounded,
      iconColor: const Color(0xFF06B6D4),
    ),
    HealthRecord(
      id: '3',
      type: 'Blood Sugar',
      value: '95',
      unit: 'mg/dL',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      note: 'Fasting blood sugar level',
      icon: Icons.water_drop_rounded,
      iconColor: const Color(0xFFF59E0B),
    ),
    HealthRecord(
      id: '4',
      type: 'Steps',
      value: '5420',
      unit: 'steps',
      date: DateTime.now().subtract(const Duration(hours: 8)),
      note: 'Walked in park',
      icon: Icons.directions_walk_rounded,
      iconColor: const Color(0xFF10B981),
    ),
  ];

  // Quick stats computed
  String get _latestHeartRate {
    final hr = _records.firstWhere((r) => r.type == 'Heart Rate',
        orElse: () => HealthRecord(
              id: '',
              type: 'Heart Rate',
              value: '--',
              unit: 'bpm',
              date: DateTime.now(),
              note: '',
              icon: Icons.favorite,
              iconColor: Colors.red,
            ));
    return '${hr.value} ${hr.unit}';
  }

  String get _latestBloodPressure {
    final bp = _records.firstWhere((r) => r.type == 'Blood Pressure',
        orElse: () => HealthRecord(
              id: '',
              type: 'Blood Pressure',
              value: '--/--',
              unit: 'mmHg',
              date: DateTime.now(),
              note: '',
              icon: Icons.speed,
              iconColor: Colors.cyan,
            ));
    return '${bp.value} ${bp.unit}';
  }

  String get _latestBloodSugar {
    final bs = _records.firstWhere((r) => r.type == 'Blood Sugar',
        orElse: () => HealthRecord(
              id: '',
              type: 'Blood Sugar',
              value: '--',
              unit: 'mg/dL',
              date: DateTime.now(),
              note: '',
              icon: Icons.water_drop,
              iconColor: Colors.amber,
            ));
    return '${bs.value} ${bs.unit}';
  }

  String get _latestSteps {
    final st = _records.firstWhere((r) => r.type == 'Steps',
        orElse: () => HealthRecord(
              id: '',
              type: 'Steps',
              value: '--',
              unit: 'steps',
              date: DateTime.now(),
              note: '',
              icon: Icons.directions_walk,
              iconColor: const Color(0xFF10B981),
            ));
    return '${st.value} ${st.unit}';
  }

  void _addRecord(HealthRecord record) {
    setState(() {
      _records.insert(0, record);
    });
  }

  void _deleteRecord(String id) {
    setState(() {
      _records.removeWhere((r) => r.id == id);
    });
  }

  void _showAddRecordSheet() {
    final valueController = TextEditingController();
    final noteController = TextEditingController();
    String selectedType = 'Heart Rate';

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
                            'Steps'
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
                        backgroundColor: const Color(0xFFEF4444),
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
                            iconColor = const Color(0xFFEF4444);
                            unit = 'bpm';
                            break;
                          case 'Blood Pressure':
                            icon = Icons.speed_rounded;
                            iconColor = const Color(0xFF06B6D4);
                            unit = 'mmHg';
                            break;
                          case 'Blood Sugar':
                            icon = Icons.water_drop_rounded;
                            iconColor = const Color(0xFFF59E0B);
                            unit = 'mg/dL';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        title: const Text(
          'Health Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0B0F19),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting banner
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF1E293B),
                    child: const Icon(Icons.person, color: Color(0xFFEF4444), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back, User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Keep monitoring your vitals',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dashboard stats grid
              const Text(
                'Latest Vitals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard(
                    'Heart Rate',
                    _latestHeartRate,
                    Icons.favorite_rounded,
                    const Color(0xFFEF4444),
                  ),
                  _buildStatCard(
                    'Blood Pressure',
                    _latestBloodPressure,
                    Icons.speed_rounded,
                    const Color(0xFF06B6D4),
                  ),
                  _buildStatCard(
                    'Blood Sugar',
                    _latestBloodSugar,
                    Icons.water_drop_rounded,
                    const Color(0xFFF59E0B),
                  ),
                  _buildStatCard(
                    'Daily Steps',
                    _latestSteps,
                    Icons.directions_walk_rounded,
                    const Color(0xFF10B981),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // History list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Logs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    '${_records.length} records',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _records.isEmpty ? 1 : _records.length,
                itemBuilder: (context, index) {
                  if (_records.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No health records logged yet.',
                          style: TextStyle(color: Colors.white.withAlpha(100)),
                        ),
                      ),
                    );
                  }

                  final record = _records[index];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: record.iconColor.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          record.icon,
                          color: record.iconColor,
                        ),
                      ),
                      title: Text(
                        record.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (record.note.isNotEmpty)
                            Text(
                              record.note,
                              style: TextStyle(color: Colors.white.withAlpha(160)),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${record.date.hour.toString().padLeft(2, '0')}:${record.date.minute.toString().padLeft(2, '0')} - '
                            '${record.date.day}/${record.date.month}/${record.date.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${record.value} ${record.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: record.iconColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white38),
                            onPressed: () => _deleteRecord(record.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEF4444),
        onPressed: _showAddRecordSheet,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(180),
                ),
              ),
              Icon(icon, color: color, size: 24),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
