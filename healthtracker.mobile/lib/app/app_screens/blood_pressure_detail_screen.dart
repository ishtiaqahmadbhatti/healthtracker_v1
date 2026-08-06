import 'package:flutter/material.dart';
import '../app_models/blood_pressure_record.dart';
import '../app_database/db_helper.dart';
import 'blood_pressure_crud_screen.dart';
import 'about_vital_details_screen.dart';
import 'about_vitals_list_screen.dart';
import '../app_models/bp_articles_data.dart';

class BloodPressureDetailScreen extends StatefulWidget {
  final BloodPressureRecord record;
  final VoidCallback onDeleteCompleted;

  const BloodPressureDetailScreen({
    super.key,
    required this.record,
    required this.onDeleteCompleted,
  });

  @override
  State<BloodPressureDetailScreen> createState() => _BloodPressureDetailScreenState();
}

class _BloodPressureDetailScreenState extends State<BloodPressureDetailScreen> {
  late BloodPressureRecord _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
  }

  // Helpers for formatting
  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Delete',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: const Text(
            'Are you sure to delete the record?',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteRecord(_currentRecord.id);
                if (context.mounted) {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // close detail screen
                  widget.onDeleteCompleted(); // trigger refresh
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFE53935), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLCDRow(String label, String value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "($unit)",
              style: const TextStyle(color: Colors.white38, fontSize: 9),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = _currentRecord;
    final bpInfo = record.categoryInfo;

    return Scaffold(
      backgroundColor: const Color(0xFF1E293B), // Dark app bar background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BloodPressureCrudScreen(
                    recordToEdit: _currentRecord,
                  ),
                ),
              );
              if (result == true) {
                final updated = await DatabaseHelper.instance.getRecordById(_currentRecord.id);
                if (updated != null && mounted) {
                  setState(() {
                    _currentRecord = updated;
                  });
                  widget.onDeleteCompleted();
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing record details...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            onPressed: () => _showDeleteDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey panel background
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Wrist Monitor Device Mockup Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Column(
                        children: [
                          // Graphic watch base
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Horizonal Strap Band Mockup
                              Container(
                                width: 280,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECEFF1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // Watch Body Frame
                              Container(
                                width: 180,
                                height: 190,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: const Color(0xFFCFD8DC), width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(8),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF263238), // LCD screen dark background
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildLCDRow('SYS', record.sys.toString(), 'mmHg'),
                                      _buildLCDRow('DIA', record.dia.toString(), 'mmHg'),
                                      _buildLCDRow('PUL', record.pul.toString(), 'BPM'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Mean Arterial Pressure (MAP) display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Mean Arterial Pressure (MAP) ',
                                style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const Icon(Icons.help_outline_rounded, color: Colors.black38, size: 16),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            record.mapValue.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category pill badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.help_outline_rounded, color: bpInfo.color, size: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Category Subtitle
                          Text(
                            bpInfo.rangeText,
                            style: const TextStyle(color: Colors.black38, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFF1F3F5)),
                          const SizedBox(height: 12),

                          // Date/Time selection details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Colors.black45, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _formatDate(record.date),
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.access_time_rounded, color: Colors.black45, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _formatTime(record.date),
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down_rounded, color: Colors.black45, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recommend Reading Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommend reading',
                          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...bpArticles.map((article) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildArticleCard(context, article),
                          );
                        }),
                      ],
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

  // Article card helper
  Widget _buildArticleCard(BuildContext context, ArticleItem article) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic visual representing article image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: article.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(article.icon, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutVitalDetailsScreen(
                            vitalName: 'Blood Pressure',
                            article: article,
                            allArticles: bpArticles,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Read more',
                        style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
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
