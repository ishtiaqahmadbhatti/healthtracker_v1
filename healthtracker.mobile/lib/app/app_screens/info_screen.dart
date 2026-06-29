import 'package:flutter/material.dart';
import 'about_vitals_list_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic articles list for Blood Pressure (7 contents)
    final bpArticles = [
      ArticleItem(
        title: 'Understanding Blood Pressure',
        description: 'Blood pressure disorders often have no visible symptoms, which can be dangerous because high or low blood pressure can lead to serious complications.',
        icon: Icons.insights_rounded,
        gradientColors: [const Color(0xFF00BFA5), const Color(0xFF00796B)],
        sections: [
          ArticleSection(
            title: 'Introduction',
            body: 'Blood pressure disorders often have no visible symptoms, which can be dangerous because high or low blood pressure can lead to life-threatening conditions like heart attack or stroke. However, you can prevent or treat them early through monitoring your blood pressure levels. Early diagnosis and healthy lifestyle changes can help you maintain good blood pressure and prevent health problems.',
          ),
          ArticleSection(
            title: 'What is Blood Pressure?',
            body: 'Blood pressure refers to the force that blood exerts against the walls of your arteries after it is pumped out from the heart. Checking your blood pressure regularly can provide an indication of how hard your heart is working and is an essential part of a general health assessment. Proper medication management and blood pressure monitoring are critical for people with high blood pressure.',
          ),
          ArticleSection(
            title: 'How is High Blood Pressure Diagnosed?',
            body: 'The only way to know if you have high blood pressure is to get regular checks from a healthcare provider. If your blood pressure is normal, your provider should check it at every annual checkup. If your readings are high, your provider may ask you to monitor your blood pressure at home several times a day or once a week.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Is My Blood Pressure Normal?',
        description: 'To determine your blood pressure category, you can refer to standard ranges for systolic and diastolic measurements.',
        icon: Icons.speed_rounded,
        gradientColors: [const Color(0xFF00E676), const Color(0xFF388E3C)],
        sections: [
          ArticleSection(
            title: 'Blood Pressure Categories',
            body: 'Blood pressure is classified into categories ranging from Normal to Hypertensive Crisis. A normal reading is less than 120/80 mmHg. Elevated is between 120-129 systolic, and Stage 1 Hypertension is 130-139 systolic or 80-89 diastolic. Understanding your numbers is key to taking action.',
          ),
          ArticleSection(
            title: 'Systolic vs. Diastolic',
            body: 'The top number (systolic) measures the pressure in your blood vessels when your heart beats. The bottom number (diastolic) measures the pressure in your blood vessels when your heart rests between beats. Both numbers are critical to health monitoring.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Lowering Blood Pressure through Exercise',
        description: 'If you are looking for drug-free ways to control, prevent, and treat hypertension, active exercise is the right place to start.',
        icon: Icons.directions_run_rounded,
        gradientColors: [const Color(0xFF2979FF), const Color(0xFF1565C0)],
        sections: [
          ArticleSection(
            title: 'Aerobic Activity Benefits',
            body: 'Regular aerobic exercise, such as walking, jogging, cycling, or swimming, strengthens the heart muscle. A stronger heart pumps blood with less effort, reducing pressure on the arteries and lowering blood pressure levels naturally.',
          ),
          ArticleSection(
            title: 'Recommended Routine',
            body: 'Aim for at least 150 minutes of moderate-intensity exercise per week, or about 30 minutes on most days. Consistent, daily activity is much more effective at lowering blood pressure than short bursts of extreme workouts.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Pregnancy-related high Blood Pressure',
        description: 'Blood pressure is the amount of force your blood exerts on your artery walls when it is being pumped, which changes significantly during pregnancy.',
        icon: Icons.pregnant_woman_rounded,
        gradientColors: [const Color(0xFFEC407A), const Color(0xFFC2185B)],
        sections: [
          ArticleSection(
            title: 'Gestational Hypertension',
            body: 'High blood pressure that develops after 20 weeks of pregnancy is known as gestational hypertension. While it usually resolves after delivery, close monitoring is critical to prevent complications for both mother and child.',
          ),
          ArticleSection(
            title: 'Preeclampsia Risks',
            body: 'Preeclampsia is a serious condition characterized by high blood pressure and signs of damage to other organ systems, often kidneys (protein in urine). Early prenatal care and frequent monitoring of blood pressure are crucial.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Who is susceptible to high Blood Pressure?',
        description: 'The likelihood of getting high blood pressure increases with age. As we age, our blood vessels gradually lose elasticity.',
        icon: Icons.group_rounded,
        gradientColors: [const Color(0xFFFFA726), const Color(0xFFF57C00)],
        sections: [
          ArticleSection(
            title: 'Age and Lifestyle Factors',
            body: 'Susceptibility to high blood pressure increases with age as arteries naturally stiffen. However, lifestyle choices such as a high-sodium diet, lack of physical activity, smoking, and chronic stress play a massive role.',
          ),
          ArticleSection(
            title: 'Genetics and Medical History',
            body: 'A family history of high blood pressure, diabetes, or kidney disease significantly increases your likelihood. Individuals with these risk factors should start monitoring their vitals earlier in life.',
          ),
        ],
      ),
      ArticleItem(
        title: 'How to prevent high Blood Pressure?',
        description: 'A healthy lifestyle is crucial in preventing high blood pressure. If you already have hypertension, modifications can control it.',
        icon: Icons.favorite_rounded,
        gradientColors: [const Color(0xFFEF5350), const Color(0xFFD32F2F)],
        sections: [
          ArticleSection(
            title: 'Healthy Dietary Choices',
            body: 'Preventing hypertension begins in the kitchen. Reduce sodium intake, limit processed foods, and increase potassium-rich options (bananas, spinach) to support healthy vessel relaxation.',
          ),
          ArticleSection(
            title: 'Stress Management & Sleep',
            body: 'Practicing mindfulness, getting 7-9 hours of quality sleep, and maintaining a healthy body weight keep stress hormones in check, protecting your blood vessels from chronic constriction.',
          ),
        ],
      ),
      ArticleItem(
        title: 'DASH Diet Plan to Prevent Hypertension',
        description: 'DASH stands for Dietary Approaches to Stop Hypertension. This eating regimen was based on research to lower clinical blood pressure.',
        icon: Icons.restaurant_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00695C)],
        sections: [
          ArticleSection(
            title: 'Core Principles of DASH',
            body: 'The DASH diet is rich in vegetables, fruits, whole grains, and low-fat dairy products. It includes fish, poultry, beans, and nuts, while limiting saturated fats, red meats, and sugary beverages.',
          ),
          ArticleSection(
            title: 'Sodium Reduction Targets',
            body: 'Standard DASH limits sodium to 2,300 mg per day, while the lower-sodium version restricts intake to 1,500 mg per day, which has been shown to reduce blood pressure even further.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Blood Sugar (6 contents)
    final sugarArticles = [
      ArticleItem(
        title: 'Understanding Blood Sugar',
        description: 'Glucose is the main source of energy for your body, but keeping it in the target range is essential to avoid diabetes complications.',
        icon: Icons.water_drop_rounded,
        gradientColors: [const Color(0xFFBA68C8), const Color(0xFF7B1FA2)],
        sections: [
          ArticleSection(
            title: 'What is Glucose?',
            body: 'Glucose is the main source of energy for your body\'s cells. When you eat, carbohydrates are broken down into glucose, which enters your bloodstream. Monitoring target ranges prevents spikes and crashes.',
          ),
          ArticleSection(
            title: 'Why It Matters',
            body: 'Consistently high blood sugar can damage blood vessels and nerves over time, increasing the risk of heart disease, kidney problems, and vision loss.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Symptoms of High Sugar Levels',
        description: 'Common symptoms of high blood sugar (hyperglycemia) include increased thirst, frequent urination, and fatigue.',
        icon: Icons.warning_amber_rounded,
        gradientColors: [const Color(0xFFFF8A65), const Color(0xFFD84315)],
        sections: [
          ArticleSection(
            title: 'Recognizing Hyperglycemia',
            body: 'Key indicators include extreme thirst, dry mouth, frequent urination, blurry vision, and feeling unusually tired or lethargic.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Healthy Diet for Glycemic Control',
        description: 'Limiting high-glycemic index foods and focusing on fiber-rich vegetables, lean proteins, and whole grains stabilizes blood glucose.',
        icon: Icons.restaurant_menu_rounded,
        gradientColors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        sections: [
          ArticleSection(
            title: 'Low Glycemic Index Diet',
            body: 'Focusing on complex carbohydrates like oats, quinoa, legumes, and green vegetables ensures slower digestion, preventing steep glucose spikes.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Exercise and Glucose Metabolism',
        description: 'Physical activity helps your muscles use blood glucose for energy, lowering your overall blood sugar levels effectively.',
        icon: Icons.directions_bike_rounded,
        gradientColors: [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
        sections: [
          ArticleSection(
            title: 'Insulin Sensitivity Benefits',
            body: 'Exercise helps insulin work more efficiently. Regular workouts can keep your blood sugar lower for up to 24 hours after physical activity.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Checking Your Vitals: Sugar Monitoring Tips',
        description: 'Consistent monitoring with a glucometer before and after meals gives valuable insights into how food and activity affect your sugar.',
        icon: Icons.biotech_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00695C)],
        sections: [
          ArticleSection(
            title: 'Timing and Recording Readings',
            body: 'Test fasting levels upon waking, and post-prandial levels 2 hours after the start of a meal. Log these variables to discuss with your physician.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Hypoglycemia: Knowing the Signs',
        description: 'Low blood sugar is dangerous. Knowing signs like shakiness, sweating, and confusion helps you react quickly by eating quick sugar.',
        icon: Icons.new_releases_rounded,
        gradientColors: [const Color(0xFFFFD54F), const Color(0xFFF57F17)],
        sections: [
          ArticleSection(
            title: 'Treating Hypoglycemia',
            body: 'If your blood sugar drops below 70 mg/dL, apply the 15-15 rule: consume 15 grams of fast-acting sugar (e.g. fruit juice), wait 15 minutes, and re-test.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Heart Rate (8 contents)
    final heartArticles = [
      ArticleItem(
        title: 'Resting Heart Rate Explained',
        description: 'Your resting heart rate is the number of times your heart beats per minute when you are at rest. A normal range is 60 to 100 bpm.',
        icon: Icons.favorite_border_rounded,
        gradientColors: [const Color(0xFFEF5350), const Color(0xFFC62828)],
        sections: [
          ArticleSection(
            title: 'Resting Pulse Metrics',
            body: 'Your resting heart rate refers to the beats per minute when you are completely relaxed. A lower resting pulse typically indicates better cardiovascular fitness.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Understanding Maximum Heart Rate',
        description: 'Max heart rate is the upper limit of what your cardiovascular system can handle during physical activity, estimated by subtracting your age from 220.',
        icon: Icons.trending_up_rounded,
        gradientColors: [const Color(0xFFFF7043), const Color(0xFFD84315)],
        sections: [
          ArticleSection(
            title: 'Max Heart Rate Zones',
            body: 'Calculate your limit using standard calculations. Train at 50-70% of max heart rate for moderate activity, and 70-85% for vigorous activity.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Tachycardia: Fast Heart Rate Signs',
        description: 'Tachycardia occurs when your resting heart rate exceeds 100 beats per minute. Consult your doctor if this is accompanied by chest pain or dizziness.',
        icon: Icons.offline_bolt_rounded,
        gradientColors: [const Color(0xFFAB47BC), const Color(0xFF6A1B9A)],
        sections: [
          ArticleSection(
            title: 'High Pulse Symptoms',
            body: 'Common indicators include shortness of breath, lightheadedness, chest pounding, and heart palpitations during resting periods.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Bradycardia: Slow Heart Rate Signs',
        description: 'Bradycardia is a condition where the heart beats fewer than 60 times per minute. While common in athletes, it can indicate issues in older adults.',
        icon: Icons.timer_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00695C)],
        sections: [
          ArticleSection(
            title: 'Low Pulse Symptoms',
            body: 'If pulse falls below 60 and you experience fainting, extreme fatigue, memory issues, or chest pain, seek medical evaluation.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Cardiovascular Workouts for Heart Strength',
        description: 'Aerobic exercises like swimming, running, and cycling train your heart muscle, improving oxygen delivery throughout your body.',
        icon: Icons.fitness_center_rounded,
        gradientColors: [const Color(0xFF42A5F5), const Color(0xFF1565C0)],
        sections: [
          ArticleSection(
            title: 'Aerobic Conditioning',
            body: 'Engage in heart-rate elevating workouts 3-4 times per week to reduce resting arterial load and increase stroke volume.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Stress and Its Impact on Pulse',
        description: 'Chronic stress triggers stress hormones like cortisol and adrenaline, raising your baseline heart rate and blood pressure over time.',
        icon: Icons.psychology_rounded,
        gradientColors: [const Color(0xFF26C6DA), const Color(0xFF00838F)],
        sections: [
          ArticleSection(
            title: 'Fight or Flight Response',
            body: 'Stress triggers neurotransmitters that elevate heart contraction rates. Deep breathing and meditation exercises immediately reverse these spikes.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Heart Rate Training Zones',
        description: 'Target heart rate zones determine exercise intensity. Zone 2 promotes fat burn, while Zone 4-5 targets anaerobic threshold.',
        icon: Icons.layers_rounded,
        gradientColors: [const Color(0xFF9CCC65), const Color(0xFF558B2F)],
        sections: [
          ArticleSection(
            title: 'Understanding Zones 1-5',
            body: 'Zone 1 is recovery, Zone 2 builds endurance, Zone 3 improves aerobic capacity, Zone 4 targets lactate threshold, and Zone 5 is maximal effort.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Pulse Monitoring Wearables',
        description: 'Smartwatches and chest straps use optical or electrical sensors to track heart rate throughout the day, recording metrics to notice trends.',
        icon: Icons.watch_rounded,
        gradientColors: [const Color(0xFF78909C), const Color(0xFF37474F)],
        sections: [
          ArticleSection(
            title: 'Wearables Accuracy',
            body: 'Chest straps capture electrical heart signals (ECG style) and are highly accurate. Smartwatches use optical PPG sensors, which are good for general trends.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Weight & BMI (6 contents)
    final weightArticles = [
      ArticleItem(
        title: 'Understanding BMI: Body Mass Index',
        description: 'BMI calculates a person\'s weight categories relative to their height. Ranges: under 18.5 is underweight, 18.5 to 24.9 is healthy.',
        icon: Icons.monitor_weight_rounded,
        gradientColors: [const Color(0xFF42A5F5), const Color(0xFF0D47A1)],
        sections: [
          ArticleSection(
            title: 'Calculating Body Mass Index',
            body: 'BMI is calculated by dividing your weight in kilograms by your height in meters squared. While useful for general groupings, it doesn\'t account for muscle-to-fat ratios.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Sustainable Strategies for Weight Loss',
        description: 'A caloric deficit combined with strength training and healthy sleep is the most sustainable approach to losing excess fat tissue.',
        icon: Icons.directions_walk_rounded,
        gradientColors: [const Color(0xFF66BB6A), const Color(0xFF1B5E20)],
        sections: [
          ArticleSection(
            title: 'Habitual Adjustments',
            body: 'Prioritize protein intake and strength training to maintain lean muscle mass while operating in a moderate caloric deficit (300-500 kcal).',
          ),
        ],
      ),
      ArticleItem(
        title: 'Muscle Mass vs. Fat Percentage',
        description: 'Weight alone is not a comprehensive health metric. Body composition (muscle vs fat) is a more accurate predictor of metabolic health.',
        icon: Icons.accessibility_new_rounded,
        gradientColors: [const Color(0xFFFFA726), const Color(0xFFE65100)],
        sections: [
          ArticleSection(
            title: 'Body Recomposition',
            body: 'Body fat release can occur simultaneously with muscle hypertrophy. Scale weight may stay flat while your body measurements and metabolic indicators improve.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Basal Metabolic Rate: BMR Explained',
        description: 'BMR measures the calories your body burns at rest to maintain vital functions like breathing, circulation, and cell production.',
        icon: Icons.bolt_rounded,
        gradientColors: [const Color(0xFFFFD54F), const Color(0xFFF57F17)],
        sections: [
          ArticleSection(
            title: 'BMR and Energy Expenditure',
            body: 'BMR accounts for 60-75% of your total daily calorie burn. Increasing skeletal muscle tissue increases your baseline BMR, boosting metabolism.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Healthy Portion Control Guide',
        description: 'Eating mindfully and sizing portions using simple hand-measurement tricks prevent accidental overeating during meals.',
        icon: Icons.flatware_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF004D40)],
        sections: [
          ArticleSection(
            title: 'Mindful Sizing',
            body: 'Use visual metrics: palm size for protein, fist size for veggies, cupped hand for complex carbs, and thumb size for fats to regulate calories without strict logging.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Creating a Long-term Fitness Routine',
        description: 'Consistency beats intensity. Set realistic weight targets and find activities you enjoy to maintain long-term metabolic health.',
        icon: Icons.sports_gymnastics_rounded,
        gradientColors: [const Color(0xFFEC407A), const Color(0xFF880E4F)],
        sections: [
          ArticleSection(
            title: 'Establishing Consistency',
            body: 'Start small with 2-3 workouts a week. Focus on creating healthy identity habits rather than looking for immediate drastic weight changes.',
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Header background (vibrant red)
      body: Column(
        children: [
          // AppBar / Header Section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Info',
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
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  children: [
                    _buildInfoCard(
                      title: 'Blood Pressure',
                      subtitle: '${bpArticles.length} contents',
                      badgeColor: const Color(0xFF1E8D89),
                      badgeWidget: _buildBloodPressureBadge(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalsListScreen(
                              vitalName: 'Blood Pressure',
                              articles: bpArticles,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Blood Sugar',
                      subtitle: '${sugarArticles.length} contents',
                      badgeColor: const Color(0xFFFA9314),
                      badgeWidget: _buildBloodSugarBadge(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalsListScreen(
                              vitalName: 'Blood Sugar',
                              articles: sugarArticles,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Heart Rate',
                      subtitle: '${heartArticles.length} contents',
                      badgeColor: const Color(0xFFE54A4A),
                      badgeWidget: _buildHeartRateBadge(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalsListScreen(
                              vitalName: 'Heart Rate',
                              articles: heartArticles,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'Weight & BMI',
                      subtitle: '${weightArticles.length} contents',
                      badgeColor: const Color(0xFF1E7BFA),
                      badgeWidget: _buildWeightBmiBadge(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutVitalsListScreen(
                              vitalName: 'Weight & BMI',
                              articles: weightArticles,
                            ),
                          ),
                        );
                      },
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

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required Color badgeColor,
    required Widget badgeWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Left: Colored Badge
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(child: badgeWidget),
            ),
            const SizedBox(width: 20),
            // Right: Content info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black26,
              size: 28,
            ),
            const SizedBox(width: 16),
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

  // Graphical badges
  Widget _buildBloodPressureBadge() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // White circular backdrop
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ),
          ),
          // Stethoscope icon
          const Icon(
            Icons.health_and_safety_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildBloodSugarBadge() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(
            Icons.bloodtype_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateBadge() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightBmiBadge() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(
            Icons.monitor_weight_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }
}
