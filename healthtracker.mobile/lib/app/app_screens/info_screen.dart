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
            title: 'Understanding Blood Pressure Categories',
            body: 'To determine your blood pressure category, you can refer to the following:',
          ),
          ArticleSection(
            title: '1. Hypotension',
            body: 'If your blood pressure readings are consistently below 90/60 mmHg, you may have hypotension. Typically, low blood pressure causes no harm and shows no symptoms. However, if you experience sudden drops of it (more than 20 mmHg), sudden drops due to medication, or symptoms such as dizziness, fainting, or fatigue, seek treatment.',
          ),
          ArticleSection(
            title: '2. Normal Blood Pressure',
            body: 'Blood pressure readings below 120/80 mmHg are considered normal. If your results fall into this category, maintain a lean healthy lifestyle by following a balanced diet and exercising regularly.',
          ),
          ArticleSection(
            title: '3. Elevated Blood Pressure',
            body: 'Elevated blood pressure refers to sustained readings ranging from 120–129 systolic and less than 80 mmHg diastolic. People with elevated blood pressure are at risk of developing high blood pressure unless they take steps to control the condition.',
          ),
          ArticleSection(
            title: '4. High Blood Pressure - Stage 1',
            body: 'Hypertension Stage 1 occurs when blood pressure consistently ranges from 130–139 systolic or 80–89 mmHg diastolic. At this stage, doctors may prescribe lifestyle changes and consider adding blood pressure medication based on the patient\'s risk of atherosclerotic cardiovascular disease (ASCVD), such as heart attack or stroke.',
          ),
          ArticleSection(
            title: '5. High Blood Pressure - Stage 2',
            body: 'Hypertension Stage 2 is when blood pressure consistently ranges at 140/90 mmHg or higher. At this stage, doctors are likely to prescribe a combination of blood pressure medications and lifestyle changes to manage the condition.',
          ),
          ArticleSection(
            title: '6. Dangerously High Blood Pressure',
            body: 'Medical attention is necessary for this stage of high blood pressure. If your blood pressure readings suddenly exceed 180/120 mmHg, wait for five minutes and then measure your blood pressure again. If your readings are still unusually high, immediately contact your doctor, as you may be experiencing a hypertensive crisis.',
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
            title: '',
            body: 'If you are looking for drug-free ways to control, prevent, and treat hypertension, this is the right place. This article will provide you with some exercises that can help lower your blood pressure, which can have a significant impact on your overall health.',
          ),
          ArticleSection(
            title: '1. Aerobic Exercise',
            body: 'Aerobic exercise is an effective way to lower blood pressure. Regular aerobic exercise can increase heart rate and respiration, which helps boost cardiovascular fitness, and improve blood flow. Consistent aerobic exercise can lower resting systolic blood pressure by an average of 5 to 8 mmHg.\n\nHow much aerobic exercise is needed?\nConsistency is key when it comes to using regular aerobic activity as a way to manage blood pressure. It is important to remember that stopping exercise can result in a loss of progress.\nTo see significant reductions in blood pressure, it is recommended that people with hypertension engage in moderate aerobic activity 3 to 4 days per week. A daily session average of 30 to 40 minutes is ideal for achieving beneficial results. If completing a full 30 minutes without a break is challenging, breaking it up into 10-minute sessions throughout the day can be just as effective.\n\nExamples of aerobic exercises:\nThese are several examples of aerobic exercises that involve the use of large muscle groups, including climbing stairs, walking, jogging, cycling, swimming, and dancing.',
          ),
          ArticleSection(
            title: '2. Strength training',
            body: 'Strength training can be used in conjunction with aerobic exercise to help lower blood pressure, or in other words, to naturally and steadily lower blood pressure. In order to engage in strength training, you will typically need weights or equipment such as resistance training machines.\n\nPrecautions\nStrength training can temporarily increase blood pressure, so it is important to seek professional guidance on the ideal parameters, movements, and weights for you.\nFewer repetitions and lower resistance can prevent excessive increases in blood pressure. Begin with one set and gradually work up to a maximum of three sets.\nMake sure to rest for at least 60 seconds between each set if your exercise routine includes more than one set.\nResistance exercise should be done at a moderate pace, not too slowly.\nHolding your breath can cause your blood pressure to rise.\n\nHow much resistance exercise is necessary?\nIt is recommended to perform resistance training two to three times per week at a moderate level of intensity, deliberately and repeatedly exercising the same muscle group in doing the same resistance exercises. Performing the exercises over time helps lower blood pressure.\n\nExamples of equipment-based resistance training\n- Chest press\n- Shoulder press\n- Triceps extension\n- Bicep curl\n- Pull down\n- Lower back extension/Abdominal crunch\n- Quadriceps extension\n- Leg curls\n- Calf raise',
          ),
          ArticleSection(
            title: '3. Exercise for flexibility',
            body: 'For individuals with hypertension, simple flexibility exercises or stretches can be beneficial. These can help relax muscles and joints, improve blood flow, and reduce stress. Therefore, stretching should be a part of your daily routine.\n\nHow many flexibility exercises are necessary?\nStudies have shown that exercising 2 to 3 days a week can lower blood pressure. It is necessary to hold each stretch for 10 to 30 seconds to achieve benefits.\n\nExamples of flexibility exercises\n- Yoga\n- Pilates',
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
            title: 'What is pregnancy-related hypertension?',
            body: 'Blood pressure is the amount of force your blood exerts on your artery walls when it is being pumped through them. When this pressure is too high, you have high blood pressure, also known as hypertension. Pregnancy-related high blood pressure can take several forms:',
          ),
          ArticleSection(
            title: '1. Gestational hypertension',
            body: 'Gestational hypertension is high blood pressure that develops during pregnancy, typically after 20 weeks. It usually does not have any other symptoms. Gestational hypertension often has no adverse effects on you or your unborn child and resolves within 12 weeks after delivery. However, it increases your risk of developing high blood pressure later on. In some cases, it can be severe and lead to low birth weight or preterm delivery. Some pregnant women may go on to develop preeclampsia.',
          ),
          ArticleSection(
            title: '2. Chronic hypertension',
            body: 'High blood pressure that existed before the 20th week of pregnancy or before pregnancy itself. Some women may have had it for a long time before becoming pregnant but were unaware of it until their blood pressure was tested during prenatal visits. Preeclampsia can develop as a result of chronic hypertension.',
          ),
          ArticleSection(
            title: '3. Preeclampsia',
            body: 'A sudden increase in blood pressure after the 20th week of pregnancy is known as preeclampsia. It typically occurs in the third trimester. In rare cases, symptoms may not appear until after delivery. Preeclampsia may also present symptoms of liver or kidney dysfunction. Two possible symptoms are protein in the urine and extremely high blood pressure. Preeclampsia can be dangerous or even fatal for you and your unborn child.',
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
            title: 'Age:',
            body: 'The likelihood of getting high blood pressure increases with age. As we age, our blood vessels gradually lose their elasticity, which can lead to increased blood pressure. However, high blood pressure can also develop in children.',
          ),
          ArticleSection(
            title: 'Race/Ethnicity:',
            body: 'African-Americans are more prone to developing high blood pressure than people of any other racial background in the United States. High blood pressure also tends to be more severe in African Americans, and some medications are less effective in treating high blood pressure in blacks.',
          ),
          ArticleSection(
            title: 'Weight:',
            body: 'People who are overweight or have obesity are more likely to develop high blood pressure.',
          ),
          ArticleSection(
            title: 'Gender:',
            body: 'Men are more likely to develop high blood pressure than women until age 64. After age 65, women are more prone to high blood pressure.',
          ),
          ArticleSection(
            title: 'Lifestyle:',
            body: 'Certain lifestyle habits can increase the risk of high blood pressure, such as consuming unhealthy foods with high sodium and low potassium, drinking excessive alcohol or caffeine, lack of physical activity, smoking, or using illegal drugs such as cocaine, bath salts, and methamphetamine. Poor sleep quality can also increase the risk of high blood pressure.',
          ),
          ArticleSection(
            title: 'Family History:',
            body: 'If your parents or other close blood relatives have high blood pressure, you have an increased chance of developing it too.',
          ),
        ],
      ),
      ArticleItem(
        title: 'How to prevent high Blood Pressure?',
        description: 'A healthy lifestyle is crucial in preventing high blood pressure. If you already have the condition, it\'s important to stop it from worsening or leading to complications.',
        icon: Icons.favorite_rounded,
        gradientColors: [const Color(0xFFEF5350), const Color(0xFFD32F2F)],
        sections: [
          ArticleSection(
            title: 'Introduction:',
            body: 'A healthy lifestyle is crucial in preventing high blood pressure. If you already have the condition, it\'s important to stop it from worsening or leading to complications. Regular medical checkups and adherence to the recommended treatment plan are essential. The plan may include suggestions for healthy lifestyle practices and prescription drugs.',
          ),
          ArticleSection(
            title: 'Eating a healthy diet:',
            body: 'To control your blood pressure, reduce your sodium intake and increase your potassium consumption. Eating plenty of nutritious grains, fruits, and vegetables, as well as low-fat foods, is also essential. The DASH diet is an example of a diet that can lower blood pressure.',
          ),
          ArticleSection(
            title: 'Getting regular exercise:',
            body: 'Exercise can help lower your blood pressure and maintain a healthy weight. The goal should be at least two and a half hours of moderate-intensity aerobic exercise per week or one hour and fifteen minutes of vigorous-intensity aerobic exercise. Any activity that elevates your heart rate and oxygen consumption, such as brisk walking, is considered aerobic activity.',
          ),
          ArticleSection(
            title: 'Maintaining a Healthy Weight',
            body: 'If you are overweight or obese, your risk of high blood pressure increases. However, you can reduce your risk of high blood pressure and other health problems by maintaining a healthy weight.',
          ),
          ArticleSection(
            title: 'Limiting Alcohol Intake',
            body: 'Excessive alcohol consumption can cause an increase in blood pressure and can also lead to weight gain due to the additional calories. It is recommended that women limit their alcohol intake to only one drink per day, and men should not have more than two drinks per day.',
          ),
          ArticleSection(
            title: 'Avoiding Smoking',
            body: 'Smoking cigarettes is known to increase blood pressure and the risk of heart attack and stroke. If you do not smoke, do not start. If you are currently a smoker, talk to your healthcare provider to determine the best method to quit.',
          ),
          ArticleSection(
            title: 'Managing Stress',
            body: 'Reducing stress levels through relaxation techniques, such as exercise, listening to music, focusing on calming activities, and meditation, can improve both physical and emotional health and lower blood pressure.',
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
            title: 'What is DASH?',
            body: 'DASH stands for Dietary Approaches to Stop Hypertension. This eating regimen was based on research studies funded by the National Heart, Lung, and Blood Institute (NHLBI) which demonstrated how DASH can decrease high blood pressure and raise cholesterol levels. By following the DASH diet, you are less likely to develop heart disease.',
          ),
          ArticleSection(
            title: 'The DASH diet plan:',
            body: '- Emphasizes fruits, vegetables, and whole grains.\n\n- Includes fat-free or low-fat dairy products, fish, poultry, beans, nuts, and vegetable oils.\n\n- Limits the consumption of foods high in saturated fat such as fatty meats, dairy items with all the fat, and tropical oils like coconut, palm kernel, and palm oils.\n\n- Sets limits on foods and drinks with added sugar.\n\nIn addition to the DASH diet, other lifestyle modifications such as maintaining a healthy weight, exercising regularly, and quitting smoking can also help to lower your blood pressure.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Blood Sugar (6 contents)
    final sugarArticles = [
      ArticleItem(
        title: 'Understand diabetes',
        description: 'The chronic disease known as diabetes mellitus is a serious and complex condition without a cure, but it can be managed.',
        icon: Icons.health_and_safety_rounded,
        gradientColors: [const Color(0xFFBA68C8), const Color(0xFF7B1FA2)],
        sections: [
          ArticleSection(
            title: 'What is diabetes?',
            body: 'Diabetes is a chronic condition where the body cannot properly process glucose (sugar) from food. This happens either because the pancreas does not produce enough insulin, or the body cannot effectively use the insulin it produces. Over time, high blood glucose levels can lead to serious health complications affecting the heart, blood vessels, eyes, kidneys, and nerves.',
          ),
          ArticleSection(
            title: 'Types of Diabetes',
            body: 'Type 1 Diabetes: An autoimmune reaction where the body stops making insulin. It is usually diagnosed in children and young adults.\n\nType 2 Diabetes: The most common type, where the body does not use insulin well and cannot keep blood sugar at normal levels. It develops over many years and is closely linked to lifestyle factors.\n\nGestational Diabetes: Develops in pregnant women who have never had diabetes, and usually goes away after delivery but increases the risk of type 2 diabetes later.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Understand the normal range for blood sugar',
        description: 'Understanding the typical blood sugar levels is a crucial aspect of self-managing diabetes. Blood sugar ranges help guide treatment decisions.',
        icon: Icons.speed_rounded,
        gradientColors: [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
        sections: [
          ArticleSection(
            title: 'Fasting Blood Sugar Ranges',
            body: 'For someone without diabetes, a normal fasting blood sugar level is typically under 100 mg/dL (5.6 mmol/L). A level between 100 and 125 mg/dL indicates prediabetes, while 126 mg/dL or higher on two separate tests indicates diabetes.',
          ),
          ArticleSection(
            title: 'Post-Meal Blood Sugar Ranges',
            body: 'A normal blood sugar level two hours after eating is typically less than 140 mg/dL (7.8 mmol/L). For people with diabetes, the target post-meal level is usually less than 180 mg/dL, though targets are individualized based on age and overall health status.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Diabetes\'s Primary Warning Signs',
        description: 'Early identification of diabetes can reduce the likelihood of serious complications. Therefore, it is crucial to recognize warning symptoms.',
        icon: Icons.warning_amber_rounded,
        gradientColors: [const Color(0xFFFF8A65), const Color(0xFFD84315)],
        sections: [
          ArticleSection(
            title: 'Common Warning Symptoms',
            body: 'Early signs of diabetes may seem harmless but should never be ignored. They include:\n\n- Polyuria (Frequent urination)\n- Polydipsia (Excessive thirst)\n- Polyphagia (Extreme hunger)\n- Unexplained weight loss\n- Fatigue and irritability\n- Blurry vision\n- Slow-healing sores or cuts\n- Frequent infections',
          ),
          ArticleSection(
            title: 'When to Consult a Doctor',
            body: 'If you or a family member experiences any of these symptoms persistently, scheduling a simple blood test with your healthcare provider is highly recommended. Early detection and management can prevent damage to vital organs.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Blood Sugar Checking at Home',
        description: 'Blood sugar self-testing can be particularly beneficial for the elderly and those with diabetes. Testing regularly keeps track of blood sugar changes.',
        icon: Icons.home_work_rounded,
        gradientColors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        sections: [
          ArticleSection(
            title: 'Why Monitor at Home?',
            body: 'Self-monitoring provides real-time information about your blood glucose levels. It helps you see how meals, physical activity, stress, and medications affect your sugar levels. This enables you and your healthcare team to make necessary adjustments to your treatment plan.',
          ),
          ArticleSection(
            title: 'Steps for Accurate Checking',
            body: '1. Wash your hands thoroughly with warm water and soap.\n2. Insert a test strip into your blood glucose meter.\n3. Prick the side of your finger with the lancing device.\n4. Apply the blood drop to the edge of the test strip.\n5. Wait for the meter to display your results and record the reading.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Methods for Diagnosing Diabetes',
        description: 'How is diabetes diagnosed? Doctors use blood tests to diagnose and treat diabetes. Typical testing protocols include A1C, fasting, and oral tests.',
        icon: Icons.biotech_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00695C)],
        sections: [
          ArticleSection(
            title: 'Standard Diagnostic Tests',
            body: 'Doctors use several blood tests to diagnose diabetes:\n\n- Fasting Plasma Glucose (FPG) Test: Measures blood sugar after an overnight fast.\n- A1C Test: Measures your average blood sugar level over the past 2 to 3 months. An A1C of 6.5% or higher on two separate tests indicates diabetes.\n- Oral Glucose Tolerance Test (OGTT): Measures blood sugar before and 2 hours after drinking a sweet liquid.',
          ),
          ArticleSection(
            title: 'Understanding Prediabetes',
            body: 'Prediabetes means your blood sugar levels are higher than normal but not high enough to be classified as type 2 diabetes. Detecting prediabetes early gives you a chance to reverse it through lifestyle adjustments before it progresses.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Methods for Preventing Diabetes',
        description: 'Although type 1 diabetes is unavoidable, changing your lifestyle could significantly contribute to preventing or delaying type 2 diabetes.',
        icon: Icons.favorite_rounded,
        gradientColors: [const Color(0xFFFFD54F), const Color(0xFFF57F17)],
        sections: [
          ArticleSection(
            title: 'Lifestyle Habits that Protect You',
            body: 'Preventing type 2 diabetes involves making simple, sustainable daily changes:\n\n- Eat a balanced, nutrient-dense diet rich in fiber and whole grains.\n- Engage in regular physical activity (at least 150 minutes of moderate exercise per week).\n- Achieve and maintain a healthy body weight.\n- Limit sugary drinks, highly processed foods, and trans fats.\n- Avoid smoking and manage chronic stress levels.',
          ),
          ArticleSection(
            title: 'The Importance of Early Action',
            body: 'Small shifts in diet and activity can lower your risk of developing type 2 diabetes by up to 60%. Starting early, especially if you have a family history, is key to lifelong glycemic health.',
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
