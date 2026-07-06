import 'package:flutter/material.dart';
import 'about_vitals_list_screen.dart';

class AboutVitalDetailsScreen extends StatelessWidget {
  final String vitalName;
  final ArticleItem article;
  final List<ArticleItem> allArticles;

  const AboutVitalDetailsScreen({
    super.key,
    required this.vitalName,
    required this.article,
    required this.allArticles,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out the current article to build recommended readings
    final recommended = allArticles.where((a) => a != article).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header background (vibrant red matching screenshot)
      body: Column(
        children: [
          // AppBar / Header Section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  // English Flag Indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🇬🇧 ',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Text(
                        'English',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white.withAlpha(200),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Body Content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Gradient Banner image representation
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: article.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Icon(
                          article.icon,
                          color: Colors.white.withAlpha(220),
                          size: 72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Article Title
                    Center(
                      child: Text(
                        article.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // List of Sections
                    ...article.sections.map((section) => _buildSectionCard(section)),

                    const SizedBox(height: 32),

                    // Recommended Reading Title
                    const Text(
                      'Recommend reading',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recommended items list
                    ...recommended.map((recArticle) => _buildRecommendedCard(context, recArticle)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(ArticleSection section) {
    final headerColor = _getSectionHeaderColor(section.title);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Clip the colored banner header
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerColor != null)
            Container(
              width: double.infinity,
              color: headerColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Text(
                section.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          else if (section.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                section.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.body,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                if (section.title == 'Understanding Blood Pressure Categories') ...[
                  const SizedBox(height: 16),
                  _buildBpCategoriesList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? _getSectionHeaderColor(String title) {
    if (title.contains('1. Hypotension') || title.contains('1. Aerobic Exercise') || title.contains('1. Gestational hypertension')) return const Color(0xFF2979FF); // Blue
    if (title.contains('2. Normal') || title.contains('2. Strength training') || title.contains('2. Chronic hypertension')) return const Color(0xFF4CAF50); // Green
    if (title.contains('3. Elevated')) return const Color(0xFFFFD54F); // Yellow/Amber
    if (title.contains('3. Exercise for flexibility')) return const Color(0xFFFB8C00); // Orange
    if (title.contains('3. Preeclampsia')) return const Color(0xFFEC407A); // Pink
    if (title.contains('4. High Blood Pressure - Stage 1')) return const Color(0xFFFF9100); // Light Orange
    if (title.contains('5. High Blood Pressure - Stage 2')) return const Color(0xFFFF3D00); // Dark Orange
    if (title.contains('6. Dangerously')) return const Color(0xFFD50000); // Red
    return null;
  }

  Widget _buildBpCategoriesList() {
    final categories = [
      _BpCategoryData('Hypotension', '<90/60 or DIA <60 mmHg', const Color(0xFFE3F2FD), const Color(0xFF1E88E5)),
      _BpCategoryData('Normal', 'SYS <120 and DIA <80 mmHg', const Color(0xFFE8F5E9), const Color(0xFF43A047)),
      _BpCategoryData('Elevated', 'SYS 120-129 and DIA <80 mmHg', const Color(0xFFFFFDE7), const Color(0xFFFDD835)),
      _BpCategoryData('High Pressure Stage 1', 'SYS 130-139 or DIA 80-89 mmHg', const Color(0xFFFFF3E0), const Color(0xFFFB8C00)),
      _BpCategoryData('High Pressure Stage 2', 'SYS >=140 or DIA >=90 mmHg', const Color(0xFFFBE9E7), const Color(0xFFF4511E)),
      _BpCategoryData('Hypertensive Crisis', 'SYS >180 or DIA >120 mmHg', const Color(0xFFFFEBEE), const Color(0xFFE53935)),
    ];

    return Column(
      children: categories.map((cat) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: cat.bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat.name,
                  style: TextStyle(
                    color: cat.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat.valueRange,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, ArticleItem recArticle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: recArticle.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(
              child: Icon(
                recArticle.icon,
                color: Colors.white.withAlpha(220),
                size: 48,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recArticle.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recArticle.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to this details screen, replacing or pushing
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalDetailsScreen(
                              vitalName: vitalName,
                              article: recArticle,
                              allArticles: allArticles,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        side: const BorderSide(color: Color(0xFF1976D2), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BpCategoryData {
  final String name;
  final String valueRange;
  final Color bgColor;
  final Color textColor;

  _BpCategoryData(this.name, this.valueRange, this.bgColor, this.textColor);
}
