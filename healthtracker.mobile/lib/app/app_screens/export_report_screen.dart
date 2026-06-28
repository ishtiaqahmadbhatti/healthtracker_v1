import 'package:flutter/material.dart';

class ExportReportScreen extends StatefulWidget {
  const ExportReportScreen({super.key});

  @override
  State<ExportReportScreen> createState() => _ExportReportScreenState();
}

class _ExportReportScreenState extends State<ExportReportScreen> {
  String _selectedDateFilter = 'This month';
  String _selectedCategory = 'Heart Rate';
  String _selectedFormat = 'File PDF';

  final List<String> _categories = [
    'Blood Pressure',
    'Blood Sugar',
    'Heart Rate',
    'Weight & BMI',
  ];

  final List<String> _formats = [
    'File PDF',
    'File CSV',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Export report',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.black87, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            
            // Body Options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Filter Dropdown
                    _buildDropdownButton(),
                    const SizedBox(height: 24),

                    // Categories List
                    Column(
                      children: _categories.map((cat) {
                        final bool isSelected = _selectedCategory == cat;
                        return _buildRadioItem(
                          title: cat,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1, color: Colors.black12),
                    ),

                    // File Format List
                    Column(
                      children: _formats.map((fmt) {
                        final bool isSelected = _selectedFormat == fmt;
                        return _buildRadioItem(
                          title: fmt,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedFormat = fmt;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 48),

                    // Export Button
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFEF5350), // Red gradient start
                              Color(0xFFE53935), // Red gradient end
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE53935).withAlpha(60),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Report exported successfully as $_selectedFormat!',
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'EXPORT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedDateFilter = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return ['This week', 'This month', 'All Time'].map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_drop_down, color: Colors.black87, size: 24),
            const SizedBox(width: 8),
            Text(
              _selectedDateFilter,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F2F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _buildRadioButton(isSelected),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(bool isSelected) {
    if (isSelected) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE53935), width: 2),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black45, width: 2),
        ),
      );
    }
  }
}
