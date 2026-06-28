import 'package:flutter/material.dart';
import 'language_screen.dart';
import 'feedback_screen.dart';
import 'export_report_screen.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header background (vibrant red)
      body: Column(
        children: [
          // AppBar / Header Section
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Main Body Panel
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey panel
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // General Section
                    const Text(
                      'General',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              icon: _buildFlagIcon(),
                              title: 'Language option',
                              hasChevron: true,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LanguageScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.alarm_rounded, color: Colors.black87, size: 24),
                              title: 'Set Alarm',
                              hasChevron: true,
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.ios_share_rounded, color: Colors.black87, size: 24),
                              title: 'Export report',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ExportReportScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.folder_open_rounded, color: Colors.black87, size: 24),
                              title: 'Import data',
                              onTap: () => _showImportDataSheet(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // About Section
                    const Text(
                      'About',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              icon: const Icon(Icons.star_outline_rounded, color: Colors.black87, size: 24),
                              title: 'Rate us',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87, size: 22),
                              title: 'Feedback',
                              hasChevron: true,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const FeedbackScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.verified_user_outlined, color: Colors.black87, size: 24),
                              title: 'Privacy policy',
                              hasChevron: true,
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.apps_rounded, color: Colors.black87, size: 24),
                              title: 'Version',
                              trailingText: '1.9.1',
                              onTap: () {},
                            ),
                          ],
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

  Widget _buildSettingsItem({
    required Widget icon,
    required String title,
    bool hasChevron = false,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (hasChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildFlagIcon() {
    return Container(
      width: 26,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFF00247D), // Royal blue
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // White diagonal cross
          Transform.rotate(
            angle: 0.6,
            child: Container(width: 32, height: 3, color: Colors.white),
          ),
          Transform.rotate(
            angle: -0.6,
            child: Container(width: 32, height: 3, color: Colors.white),
          ),
          // White vertical cross
          Container(width: 5, height: 18, color: Colors.white),
          Container(width: 26, height: 5, color: Colors.white),
          // Red diagonal cross
          Transform.rotate(
            angle: 0.6,
            child: Container(width: 32, height: 1.2, color: const Color(0xFFCF142B)), // Red
          ),
          Transform.rotate(
            angle: -0.6,
            child: Container(width: 32, height: 1.2, color: const Color(0xFFCF142B)), // Red
          ),
          // Red vertical cross
          Container(width: 2.5, height: 18, color: const Color(0xFFCF142B)),
          Container(width: 26, height: 2.5, color: const Color(0xFFCF142B)),
        ],
      ),
    );
  }

  void _showImportDataSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose File to Import',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Mock files list
                _buildMockFileItem(
                  context,
                  fileName: 'health_data_backup_202606.json',
                  fileSize: '42 KB',
                ),
                const SizedBox(height: 12),
                _buildMockFileItem(
                  context,
                  fileName: 'healthtracker_export.csv',
                  fileSize: '12 KB',
                ),
                const SizedBox(height: 12),
                _buildMockFileItem(
                  context,
                  fileName: 'my_health_records.json',
                  fileSize: '188 KB',
                ),
                const SizedBox(height: 20),
                
                // Browse button
                GestureDetector(
                  onTap: () => _browseFileFromDevice(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE53935),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFFFEBEE),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded, color: Color(0xFFE53935)),
                        SizedBox(width: 8),
                        Text(
                          'Browse other file from device',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  }

  Widget _buildMockFileItem(
    BuildContext context, {
    required String fileName,
    required String fileSize,
  }) {
    return GestureDetector(
      onTap: () => _simulateFileImport(context, fileName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file_rounded, color: Colors.grey, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileSize,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.download_rounded, color: Color(0xFFE53935), size: 24),
          ],
        ),
      ),
    );
  }

  void _simulateFileImport(BuildContext context, String fileName) {
    // Pop choose file sheet
    Navigator.of(context).pop();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    'Importing $fileName...',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate import processing time
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!context.mounted) return;
      
      // Dismiss dialog
      Navigator.of(context).pop();

      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fileName imported successfully! 14 records loaded.'),
          backgroundColor: Colors.green[700],
        ),
      );
    });
  }

  Future<void> _browseFileFromDevice(BuildContext context) async {
    try {
      // Pop the choose file sheet
      Navigator.of(context).pop();

      // Pick file using file_picker
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        final String fileName = result.files.single.name;
        if (!context.mounted) return;
        _simulateFileImport(context, fileName);
      } else {
        // User canceled the picker
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File selection cancelled.')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error choosing file: $e')),
      );
    }
  }
}
