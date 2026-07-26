import 'package:flutter/material.dart';
import '../app_screens/about_vitals_list_screen.dart';

final List<ArticleItem> bpArticles = [
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
