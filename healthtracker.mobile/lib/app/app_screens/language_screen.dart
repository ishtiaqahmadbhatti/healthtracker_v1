import 'package:flutter/material.dart';

class LanguageOption {
  final String name;
  final String nativeName;
  final String code;

  LanguageOption({
    required this.name,
    required this.nativeName,
    required this.code,
  });
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode = 'en';

  final List<LanguageOption> _languages = [
    LanguageOption(name: 'English', nativeName: 'English', code: 'en'),
    LanguageOption(name: 'Urdu', nativeName: 'اردو', code: 'ur'),
    LanguageOption(name: 'Indonesia', nativeName: 'Bahasa Indonesia', code: 'id'),
    LanguageOption(name: 'German', nativeName: 'Deutsch', code: 'de'),
    LanguageOption(name: 'Spanish', nativeName: 'Español', code: 'es'),
    LanguageOption(name: 'Filipino', nativeName: 'Filipino', code: 'fil'),
    LanguageOption(name: 'French', nativeName: 'Français', code: 'fr'),
    LanguageOption(name: 'Italian', nativeName: 'Italiano', code: 'it'),
    LanguageOption(name: 'Dutch', nativeName: 'Nederlands', code: 'nl'),
    LanguageOption(name: 'Portuguese', nativeName: 'Português', code: 'pt'),
    LanguageOption(name: 'Vietnamese', nativeName: 'Tiếng Việt', code: 'vi'),
    LanguageOption(name: 'Turkish', nativeName: 'Türkçe', code: 'tr'),
    LanguageOption(name: 'Arabic', nativeName: 'عربي', code: 'ar'),
    LanguageOption(name: 'Hindi', nativeName: 'हिन्दी', code: 'hi'),
    LanguageOption(name: 'Thai', nativeName: 'ภาษาไทย', code: 'th'),
    LanguageOption(name: 'Chinese', nativeName: '中国语訳', code: 'zh'),
    LanguageOption(name: 'Japanese', nativeName: '日本語', code: 'ja'),
    LanguageOption(name: 'Korean', nativeName: '한국어', code: 'ko'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header red color
      body: Column(
        children: [
          // Custom Header/AppBar
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
                    'Language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      // Simulates save settings and pop
                      Navigator.of(context).pop(_selectedLanguageCode);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Scrollable content panel
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8), // Light grey body background
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final option = _languages[index];
                  final bool isSelected = _selectedLanguageCode == option.code;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = option.code;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE0E0E0) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildRadioButton(isSelected),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              option.name,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            option.nativeName,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
