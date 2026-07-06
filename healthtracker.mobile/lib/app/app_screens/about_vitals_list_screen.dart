import 'package:flutter/material.dart';
import 'about_vital_details_screen.dart';

class ArticleSection {
  final String title;
  final String body;

  ArticleSection({
    required this.title,
    required this.body,
  });
}

class ArticleItem {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final List<ArticleSection> sections;

  ArticleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.sections,
  });
}

class AboutVitalsListScreen extends StatelessWidget {
  final String vitalName;
  final List<ArticleItem> articles;

  const AboutVitalsListScreen({
    super.key,
    required this.vitalName,
    required this.articles,
  });

  Color _getHeaderColor() {
    if (vitalName.toLowerCase().contains('pressure')) {
      return const Color(0xFFE53935); // BP Red
    }
    if (vitalName.toLowerCase().contains('sugar')) {
      return const Color(0xFFFA9314); // Blood Sugar Amber
    }
    if (vitalName.toLowerCase().contains('heart') || vitalName.toLowerCase().contains('pulse')) {
      return const Color(0xFFEC407A); // Heart Rate Pink
    }
    if (vitalName.toLowerCase().contains('weight') || vitalName.toLowerCase().contains('bmi')) {
      return const Color(0xFF5C6BC0); // Weight/BMI Indigo
    }
    return const Color(0xFF1E8D89); // Default Teal
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = _getHeaderColor();
    return Scaffold(
      backgroundColor: headerColor,
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
                  Expanded(
                    child: Text(
                      'About $vitalName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return _buildArticleCard(context, article);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleItem article) {
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
          // Top: Gradient Banner image representation
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: article.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(
              child: Icon(
                article.icon,
                color: Colors.white.withAlpha(220),
                size: 64,
              ),
            ),
          ),
          
          // Bottom: Article Details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  article.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                // Read More Button align bottom right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalDetailsScreen(
                              vitalName: vitalName,
                              article: article,
                              allArticles: articles,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1976D2),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        side: const BorderSide(color: Color(0xFF1976D2), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 15,
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
