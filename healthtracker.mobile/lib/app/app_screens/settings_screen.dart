import 'package:flutter/material.dart';

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
                              onTap: () {},
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
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsItem(
                              icon: const Icon(Icons.folder_open_rounded, color: Colors.black87, size: 24),
                              title: 'Import data',
                              onTap: () {},
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
                              onTap: () {},
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
}
