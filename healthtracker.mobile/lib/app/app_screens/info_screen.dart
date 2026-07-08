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
            title: '',
            body: 'The chronic disease known as diabetes mellitus is a serious and complex condition without a cure. Once diagnosed, individuals must manage it for life. To learn important information about this disease, continue reading.',
          ),
          ArticleSection(
            title: 'What exactly is diabetes?',
            body: 'High blood sugar levels in the body is caused by diabetes, a metabolic disease resulting from various factors such as insulin deficiency and insulin resistance.\n\nFood consumption leads to the entry of sugar into the bloodstream, and insulin, which is secreted by the pancreas, plays a crucial role in removing sugar from the bloodstream and converting it into energy for the body.\n\nThe function of insulin is to facilitate the transfer of sugar into cells instead of the bloodstream, where it can be converted into the energy that the body needs.\n\nHowever, in individuals with diabetes, the body cannot effectively convert sugar into energy due to inadequate insulin levels or dysfunctional insulin production, leading to high blood sugar levels.',
          ),
          ArticleSection(
            title: 'How widespread is diabetes?',
            body: 'A prevalent and chronic disease affecting a significant number of individuals is diabetes. In 2018, the American Diabetes Association reported that one in ten Americans had diabetes, while the British Diabetic Association found that one in fifteen people in the UK were affected by the disease.\n\nDiabetes is becoming increasingly common. Type 2 diabetes is the fastest growing of the three types of diabetes (type 1, type 2, and gestational diabetes).',
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
            title: '',
            body: 'Understanding the normal blood sugar levels is a crucial aspect of self-managing diabetes. Blood sugar ranges may vary depending on the situation and age group, such as before or after a meal, in children or adults, or during fasting. The blood sugar target range is the one individuals with diabetes strive to maintain as much as possible. This article will provide an overview of both the typical blood sugar ranges and the blood sugar goals for those with diabetes.',
          ),
          ArticleSection(
            title: 'Adults Blood Sugar Ranges',
            body: 'Normal Ranges\n\nBlood sugar levels that are considered normal for adults according to diabetes.co.uk and American Diabetes are as follows:\n\n- Prior to meals or during a period of fasting: between 4.0 and 5.9 mmol/L (72 to 106 mg/dL).\n- At least 90 minutes after a meal: less than 7.8 mmol/L (140 mg/dL).\n\nDiabetic Ranges\n\nTo maintain healthy blood sugar levels, adults with diabetes should aim for the following ranges:\n\nType 1 diabetes:\n- Upon waking: between 5.0 and 7.0 mmol/L (90 to 126 mg/dL).\n- Before meals or during a period of fasting: between 4.0 and 7.0 mmol/L (72 to 126 mg/dL).\n- 90 minutes or more after a meal: between 5.0 and 9.0 mmol/L (90 to 162 mg/dL).\n\nType 2 diabetes:\n- Prior to meals or during a period of fasting: between 4.0 and 7.0 mmol/L (72 to 126 mg/dL).\n- 90 minutes or more after a meal: under 8.5 mmol/L (153 mg/dL).',
          ),
          ArticleSection(
            title: 'Children Blood Sugar Ranges',
            body: 'Children\'s normal blood sugar levels under 6:\n- 4.0 to 11.1 mmol/L (72 to 200 mg/dL) each day.\n\nFor children between the ages of 6 and 12, the normal blood sugar level range is:\n- During a period of fasting: between 4.5 and 10 mmol/L (80 to 180 mg/dL).\n- Prior to meals: between 5 and 10 mmol/L (90 to 180 mg/dL).\n- Between one and two hours after meals: under 7.8 mmol/L (140 mg/dL).\n\nFor teenagers between the ages of 13 and 19, the normal blood sugar level range is:\n- During a period of fasting: between 3.9 and 8.3 mmol/L (70 to 150 mg/dL).\n- Prior to meals: between 5 and 7.2 mmol/L (90 to 130 mg/dL).\n- Between one and two hours after meals: under 7.8 mmol/L (140 mg/dL).\n\nIn addition to normal and diabetic blood sugar limits, hypoglycemia can occur when blood sugar levels drop below 3.89 mmol/L (70 mg/dL). However, symptoms only appear when blood sugar levels drop below 3 mmol/L (55 mg/dL).\n\nIt is important to note that the blood sugar level goals mentioned above may not be suitable for individuals with other health conditions or circumstances. Therefore, it is important to discuss your goals with your healthcare provider.',
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
            title: '',
            body: 'Early identification of diabetes can reduce the likelihood of serious complications. Therefore, it is crucial to understand the primary indicators of diabetes. Here are some examples of common diabetic symptoms for your reference.',
          ),
          ArticleSection(
            title: 'What are the primary diabetic symptoms?',
            body: 'If you have type 1 diabetes, you will experience acute, life-threatening symptoms, which can be easily identified.\n\nHowever, symptoms of type 2 diabetes may take several years to appear or not show any symptoms at all. If you are experiencing the following signs, you may already have diabetic problems.',
          ),
          ArticleSection(
            title: 'Some common symptoms of diabetes include:',
            body: '- Genital itching or thrush\n\n- Slow-healing cuts\n\n- Weight gain over time (Type 2)\n\n- Unintentional weight loss (Type 1)\n\n- Frequent urination, especially at night.\n\n- Numbness and tingling in the hands and feet (Type 2)\n\nGestational diabetes during pregnancy is often asymptomatic, but routine prenatal screenings between weeks 24 and 28 can detect the condition.\n\nMen with diabetes may also experience erectile dysfunction (ED), reduced libido, and weak muscles, while women may be prone to urinary tract infections (UTIs), yeast infections, and dry, itchy skin.',
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
            title: 'Why test your blood sugar',
            body: 'Blood sugar self-testing can be particularly beneficial for the elderly and those with diabetes (Type 1 or Type 2) or diabetic complications as it enables monitoring of blood sugar levels, preventing severe complications, and seeking treatment at an earlier stage. Specifically, it can assist in the following ways:\n\n- Monitor the effect of diabetes medications.\n\n- Track your progress on overall treatment.\n\n- Reveal how other factors, such as diet and key illness and stress, affect blood sugar levels.\n\nDepending on the type of diabetes and treatment plan, the timing of blood sugar measurements may vary.',
          ),
          ArticleSection(
            title: 'Type 1 diabetes',
            body: 'Usually, a doctor will suggest you check 4 to 10 times a day. Recommendation timing to be:\n\n- Before you eat\n- Before and after exercise\n- Before you sleep\n- At night\n\nIf you are sickly, changing your daily routine, or taking a new medication, it is recommended to check your blood sugar more frequently.',
          ),
          ArticleSection(
            title: 'Type 2 diabetes',
            body: 'The frequency depends on what you take to treat your diabetes.\n\nInsulin:\nYour doctor may ask you to check several times a day depending on the type and amount of insulin you use.\n\n- If you use administering daily injections, it is recommended to test your sugar level twice: before eating and before going to bed.\n\n- If you are only using intermediate or long-acting insulin, it may be sufficient to check blood sugar levels twice a day: before breakfast and dinner.\n\n- Oral insulin medications or lifestyle changes (diet and exercise):\nYou may not be asked to check your blood sugar on a daily basis.\n\nYour way will be guided to check your blood sugar, or in both ways.',
          ),
          ArticleSection(
            title: 'How to test your blood sugar at home',
            body: 'There are two main ways you can use to check blood sugar at home:\n\nContinuous glucose monitoring\n\nA CGM (Continuous Glucose Monitor) is a sensor placed under the skin to continuously monitor your blood sugar levels throughout the day, showing trends every few minutes.\n\nIf you are pregnant, on dialysis, or critically ill, it is important to consult with your doctor to determine if a CGM can be used, as these conditions may impact the accuracy of the machines.\n\nFinger-prick test\n\nThe finger-prick provides a more accurate and precise representation of blood sugar changes compared to other parts of the body. This is particularly true when blood sugar levels are fluctuating rapidly, such as after a meal or physical activity.\n\nYou will need these things to run the test:\n- Blood testing device\n- Test strips\n- Finger-prick devices and lancets\n\nIt is important to dispose of lancets safely using a sharp container.\n\nTo check your blood sugar level:\n1. Thoroughly wash and dry your hands, removing any substances that affect the accuracy of the reading.\n2. Insert a test strip into your meter.\n3. Use a lancet to prick the side of your fingertip.\n4. Touch the edge of the test strip to the blood droplet.\n5. After a few seconds, the meter will display your blood sugar level.\n6. Record the results for future reference.\n\nDifferences:\nFlash glucose monitoring detects sugar levels in the interstitial fluid around your cells, rather than in your blood, which may lead to delay sensor readings than a finger-prick glucose test. However, it can definitely help identify patterns and trends in your blood sugar levels.\nWith a CGM, you no longer need to perform regular finger-prick tests, but if your symptoms do not match the readings you should still confirm them with a finger-prick blood glucose test.\n\nPlease note that the steps for using your device may differ depending on the model. You can find specific instructions in your device user manual.\n\nRemember to check all your readings systematically or manually as most glucose meters now come with memory. Bring records to every appointment with your doctor so that they can adjust your treatment plan as needed.',
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
            title: '',
            body: 'How is diabetes diagnosed? Doctors use blood tests to diagnose and treat diabetes. Typically, at least two tests are ordered to identify diabetes. However, if you have typical diabetic symptoms, a second test may not be necessary.',
          ),
          ArticleSection(
            title: 'Glycated Hemoglobin (A1C) Test',
            body: 'This is the most common test used to diagnose both prediabetes and diabetes. The test can be done without fasting or drinking any fluids. The A1C test measures the amount of blood sugar that has bound to hemoglobin over a period of two to three months. Your A1C level is based on your normal blood sugar level and serves as the basis for your diagnosis.\n\nAn A1C result of 6.5% or higher indicates diabetes. If you have prediabetes, your A1C level should be between 5.7 and 6.4%. A1C results less than 5.7% indicate normal blood sugar levels.',
          ),
          ArticleSection(
            title: 'Fasting Plasma Sugar (FPG) Test',
            body: 'This test is used to diagnose type 1 diabetes and involves drawing blood at random without fasting. If your test results show a blood sugar level of 200 mg/dL or higher, you may have diabetes.',
          ),
          ArticleSection(
            title: 'Oral Glucose Tolerance Test (OGTT)',
            body: 'The OGTT measures your blood sugar level after you\'ve fasted for at least eight hours. You\'ll then drink a sugary liquid and have your blood sugar tested every two to three hours to determine whether you have diabetes or prediabetes.',
          ),
          ArticleSection(
            title: 'Diabetes Diagnosis during Pregnancy',
            body: 'Pregnant women may wonder which of the aforementioned tests is applicable to them. Oral sugar tolerance testing and a sugar challenge test are the answers.\n\nBetween the 24th and 28th weeks of pregnancy, it is typical to check your blood sugar levels.\n\nFirstly, a sugar challenge test will be conducted, and fasting is not required. After drinking a sugary beverage, your blood sugar will be tested one hour later. If your results indicate that your blood sugar is too high (above 140 mg/dL), your OGTT may be skipped.\n\nIf you suspect that you may be developing diabetes, it is advisable to visit a hospital and get tested as soon as possible. An earlier diabetes diagnosis can facilitate quicker treatment initiation.',
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
            title: '',
            body: 'Although type 1 diabetes is unavoidable, changing your lifestyle could significantly contribute to the prevention of type 2 diabetes. You can take action right now. Follow the suggestions provided below to prevent future serious health problems related to diabetes.',
          ),
          ArticleSection(
            title: 'Maintain a Nutritious Diet',
            body: 'Choosing foods with fewer calories and less fat while increasing fiber can help regulate your blood sugar levels. Consuming foods that contain fewer calories can help with weight loss. To reduce your sugar intake, opt for whole foods like fruits, vegetables, whole grains, fish, and water. Avoid saturated fats such as butter, animal fat, coconut oil, and palm oil. Try to consume small meals throughout the day.',
          ),
          ArticleSection(
            title: 'Engage in Physical Activity',
            body: 'Gradually incorporate physical activity into your daily routine for at least 30 minutes, five days a week. You can choose from a variety of moderate aerobic activities, such as biking, brisk walking, hiking, and more.',
          ),
          ArticleSection(
            title: 'Maintain a Healthy Weight',
            body: 'Use a BMI calculator to determine your ideal weight range. If you are overweight, reducing your weight by 7% can have a significant impact. However, if you have gestational diabetes, seek medical advice before attempting to lose weight.\n\nMaintaining a healthy lifestyle can prevent diabetes and improve overall health.',
          ),
          ArticleSection(
            title: 'Stop smoking.',
            body: 'Smoking increases the risk of developing diabetes. If you wish to prevent diabetes, it is advisable to quit smoking.',
          ),
          ArticleSection(
            title: 'Manage blood pressure',
            body: 'Maintaining a normal blood pressure level is equally important in preventing diabetes as controlling blood sugar levels, as individuals with high blood pressure have a higher risk of developing type 2 diabetes.\n\nBy implementing these changes, those at risk of the disease can delay or prevent its onset, and also reap other health benefits.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Heart Rate (8 contents)
    final heartArticles = [
      ArticleItem(
        title: 'Understanding Heart Rate',
        description: 'Your heart rate is simply the count of how many times your heart beats in one minute. It\'s amazing...',
        icon: Icons.favorite_border_rounded,
        gradientColors: [const Color(0xFFBA68C8), const Color(0xFF7B1FA2)],
        sections: [
          ArticleSection(
            title: 'What is heart rate?',
            body: 'Your heart rate is simply the count of how many times your heart beats in one minute. It\'s amazing how your body can adjust your heart rate according to your activities and surroundings without you even noticing. For instance, your heart beats faster when you are doing something active, excited, or frightened. Conversely, it slows down when you are feeling relaxed or comfortable.\n\nYour heart rate plays a crucial role in determining your overall health. If your heart rate is too fast or too slow, it might suggest that there are underlying health issues. Doctors can also use the sensation of your heart rate throughout your body as a potential way to identify certain medical conditions.',
          ),
          ArticleSection(
            title: 'How is heart rate different from pulse rate?',
            body: 'Heart rate and pulse rate are often used interchangeably, but they are not exactly the same thing.\n\nHeart rate refers to the number of times your heart beats per minute, which is usually measured by using an electrocardiogram (ECG) or a heart rate monitor.\n\nOn the other hand, pulse rate refers to the number of times your arteries expand and contract in response to the pressure of the blood being pumped through them by your heart. This expansion and contraction can be felt in various parts of your body where arteries are located, such as your wrist, neck, or groin.\n\nIn other words, heart rate is a measure of the heart\'s activity, while pulse rate is a measure of the arterial activity. While they are related, they can sometimes provide different information about a person\'s health. For example, a person with an irregular heartbeat may have a normal pulse rate, but an abnormal heart rate.',
          ),
          ArticleSection(
            title: 'How is heart rate measured?',
            body: 'Heart rate can be measured in several ways, including:\n\n1. Taking your pulse manually: You can check your pulse by placing two fingers (usually the index and middle fingers) on the artery at the wrist, neck, or groin. Count the number of beats you feel in 15 seconds and then multiply that number by four to get your heart rate per minute.\n\n2. Using a heart rate monitor: A heart rate monitor is an electronic device that can be worn on the wrist, chest, or finger. It uses sensors to detect and record the heart\'s electrical signals and displays the heart rate in real time.\n\n3. Our application can also help measure heart rate. You just need to follow our instructions.\n\nIn addition, more sophisticated methods, such as an Electrocardiogram (ECG or EKG) and Holter monitor can be used. However, these methods require specialized equipment and are typically used for medical diagnosis and monitoring.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Normal Heart Rate',
        description: 'A normal heart rate for adults at rest is typically between 60 and 100 beats per minute (bpm). How...',
        icon: Icons.health_and_safety_rounded,
        gradientColors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        sections: [
          ArticleSection(
            title: 'What is a normal pulse rate?',
            body: 'A normal heart rate for adults at rest is typically between 60 and 100 beats per minute (bpm). However, this can vary depending on factors such as age, fitness level, and overall health. It\'s amazing how your body can adjust your heart rate according to your activities and surroundings without you even noticing. For instance, your heart beats faster when you are doing something active, excited, or frightened. Conversely, it slows down when you are feeling relaxed or comfortable.\n\nA normal heart rate for adults at rest is typically between 60 and 100 beats per minute (bpm). However, this can vary depending on factors such as age, fitness level, and overall health. It\'s amazing how your body can adjust your heart rate according to your activities and surroundings without you even noticing. For instance, your heart beats faster when you are doing something active, excited, or frightened. Conversely, it slows down when you are feeling relaxed or comfortable.',
          ),
          ArticleSection(
            title: 'What heart rate should I expect to have?',
            body: 'Your resting heart rate is determined by your age and overall health. Generally, younger people tend to have higher heart rates at rest. The expected range for resting heart rates in children varies by age:\n\nNewborns (birth to 4 weeks): 100 - 205 bpm\n\nInfants (4 weeks to 1 year): 100 - 180 bpm\n\nToddlers (1 to 3 years): 98 - 140 bpm\n\nPreschoolers (3 to 5 years): 80 - 120 bpm\n\nSchool-age children (5 to 12 years): 75 - 118 bpm\n\nAdolescents (13 to 18 years): 60 - 100 bpm\n\nFor adults over 18 years old, a normal resting heart rate range is 60 - 100 bpm. However, the heart rate of children is likely to be lower when they are asleep.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Factors that Affect Heart Rate',
        description: 'When you engage in physical activity, your body requires more oxygen and nutrients, which incre...',
        icon: Icons.trending_up_rounded,
        gradientColors: [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
        sections: [
          ArticleSection(
            title: 'Physical activity',
            body: 'When you engage in physical activity, your body requires more oxygen and nutrients, which increases your heart rate to supply the demand. Exercise, sports, and even household chores can all cause your heart rate to go up.',
          ),
          ArticleSection(
            title: 'Emotions',
            body: 'Strong emotions such as anxiety, stress, or excitement can trigger the release of hormones that stimulate your heart and increase your heart rate. Conversely, relaxation techniques like deep breathing or meditation can help slow down your heart rate.',
          ),
          ArticleSection(
            title: 'Medications',
            body: 'Certain medications, such as beta-blockers, can slow down your heart rate. Others, such as some decongestants or asthma inhalers, can increase it.',
          ),
          ArticleSection(
            title: 'Diet habits',
            body: 'Consuming caffeine or other stimulants, as well as eating large meals, can cause your heart rate to increase. On the other hand, certain nutrients like omega-3 fatty acids may help to lower heart rate.',
          ),
          ArticleSection(
            title: 'Stimulant use',
            body: 'Smoking or using other stimulants like nicotine or cocaine can increase heart rate and put more stress on the heart.',
          ),
          ArticleSection(
            title: 'Medical conditions',
            body: 'Various medical conditions, such as anemia, thyroid disorders, and heart disease can impact heart rate. For example, anemia can cause your heart to work harder to circulate oxygen-rich blood throughout your body, leading to a faster heart rate.',
          ),
          ArticleSection(
            title: 'Age',
            body: 'As you age, your heart rate tends to slow down. Newborns and infants have a faster heart rate than adults, while older adults may have a resting heart rate of less than 60 beats per minute.',
          ),
          ArticleSection(
            title: 'Overall health',
            body: 'Poor overall health can increase the risk of developing heart disease and other conditions that can affect heart rate.',
          ),
          ArticleSection(
            title: 'Environment',
            body: 'Temperature, humidity, and altitude can all affect heart rate. For example, exercising in high altitudes can cause your heart rate to increase due to the lower oxygen levels.',
          ),
          ArticleSection(
            title: 'Genetics',
            body: 'Some people may have a genetic predisposition to certain heart conditions that can affect their heart rate, such as familial dysautonomia or long QT syndrome. Family history of heart disease may also increase the risk of heart problems and abnormal heart rate.',
          ),
        ],
      ),
      ArticleItem(
        title: 'How to Control Heart Rate (Temporary Measures)?',
        description: 'A fast heart rate, also known as tachycardia, is generally defined as a heart rate greater than 100 b...',
        icon: Icons.control_point_rounded,
        gradientColors: [const Color(0xFFFF8A65), const Color(0xFFD84315)],
        sections: [
          ArticleSection(
            title: 'What is a fast heart rate?',
            body: 'A fast heart rate, also known as tachycardia, is generally defined as a heart rate greater than 100 beats per minute (bpm) at rest. However, the exact threshold for what is considered a fast heart rate can vary depending on individual factors such as age, fitness level, and overall health.\n\nIn some cases, a fast heart rate may be a normal response to physical activity, stress, or certain medications. However, in other cases, it may be a sign of an underlying medical condition, such as anemia, thyroid disorders, heart disease, or other cardiovascular problems.\n\nIf you are experiencing a consistently fast heart rate or other symptoms such as shortness of breath, dizziness, or chest pain, it\'s important to consult with a healthcare professional to determine the underlying cause and appropriate treatment.',
          ),
          ArticleSection(
            title: 'How to lower heart rate (temporary measures)?',
            body: 'There are several temporary measures that can help lower your heart rate, including:\n\nDeep breathing: Taking slow, deep breaths can help to slow down your heart rate and also calm your body.\n\nMeditation: Practicing meditation or mindfulness can help to reduce stress and anxiety, which can lower your heart rate.\n\nCold water: Splashing cold water on your face or taking a cold shower can stimulate the body\'s natural dive reflex and help to slow down your heart rate.',
          ),
          ArticleSection(
            title: 'What is a slow heart rate?',
            body: 'When your heart beats fewer than 60 times per minute while you are resting, it is called a slow heart rate (bradycardia).\n\nFor some people, having a slow heart rate can be normal. This can include athletes, young, and healthy individuals, or people who take certain medications. For example, individuals who exercise frequently may have a resting heart rate of 40 beats per minute or less.\n\nHowever, if a slow heart rate is not typical for you, particularly if you feel unwell with it, this could indicate a problem with your heart. If you notice your heart rate is slower than usual and you are feeling faint, fatigued, or dizzy, it\'s important to speak with your doctor.',
          ),
          ArticleSection(
            title: 'How to increase heart rate (temporary measures)?',
            body: 'If you need to increase your heart rate temporarily, there are a few things you can do:\n\nExercise: Engaging in physical activity, such as jogging, jumping jacks, or climbing stairs, can raise your heart rate.\n\nCaffeine: Drinking a caffeinated beverage like coffee or tea can also temporarily increase your heart rate.\n\nDeep breathing: Taking deep breaths and holding them for a few seconds before exhaling can help to stimulate your nervous system and increase your heart rate.\n\nMedications: Some over-the-counter medications, such as decongestants, cold and allergy medicine, can increase your heart rate as a side effect. However, you should always consult with your doctor before taking any new medications.',
          ),
          ArticleSection(
            title: 'Recommendations',
            body: 'It\'s important to note that these measures should only be used in specific situations and under the guidance of a healthcare professional. If you have concerns about your heart rate or need to make sustained changes to your heart rate, you should speak with your doctor.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Impact of Heart Rate on Health',
        description: 'When heart rate is consistently high, it can lead to an increased risk of cardiovascular diseases s...',
        icon: Icons.medical_services_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00695C)],
        sections: [
          ArticleSection(
            title: 'Cardiovascular risks',
            body: 'When heart rate is consistently high, it can lead to an increased risk of cardiovascular diseases such as coronary artery disease, heart attack, and stroke. The heart has to work harder to pump blood through the body, which can cause the heart muscle to become thicker and less efficient over time. This can lead to an increased risk of heart failure, as well as damage to the blood vessels, which can increase the risk of heart attack and stroke. Additionally, high heart rate is often associated with other cardiovascular risk factors, such as high blood pressure and high cholesterol, which can further increase the risk of heart disease.',
          ),
          ArticleSection(
            title: 'High blood pressure',
            body: 'A high heart rate can increase blood pressure, which can put additional strain on the heart and blood vessels over time. High blood pressure, also known as hypertension, is a major risk factor for several cardiovascular diseases, including stroke, heart attack, and heart failure.',
          ),
          ArticleSection(
            title: 'Heart diseases',
            body: 'A consistently high or irregular heart rate can be a symptom or cause of several heart diseases, such as arrhythmias, heart failure, and valve disorders. When the heart rate is too fast, it may not be able to efficiently pump blood, leading to heart failure over time. Additionally, an irregular heart rate can increase the risk of blood clots and stroke.',
          ),
          ArticleSection(
            title: 'Mental health issues',
            body: 'A high heart rate may be associated with mental health issues such as anxiety or panic disorder. Additionally, experiencing an irregular heart rate can cause anxiety and stress, which can worsen the condition.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Changes to Improve Cardiovascular Health',
        description: 'Smoking is a major risk factor for heart disease. If you smoke, quitting is the single most import...',
        icon: Icons.star_rounded,
        gradientColors: [const Color(0xFFFFD54F), const Color(0xFFF57F17)],
        sections: [
          ArticleSection(
            title: '',
            body: 'There are many lifestyle changes that can improve cardiovascular health. Here are some of the most important ones:',
          ),
          ArticleSection(
            title: 'Quit smoking',
            body: 'Smoking is a major risk factor for heart disease. If you smoke, quitting is the single most important thing you can do to improve your heart health.',
          ),
          ArticleSection(
            title: 'Exercise regularly',
            body: 'Regular physical activity can help improve heart health by reducing blood pressure, improving cholesterol levels, and decreasing the risk of heart disease. Aim for at least 150 minutes of moderate-intensity exercise per week.',
          ),
          ArticleSection(
            title: 'Eat a healthy diet',
            body: 'Eating a diet that is low in saturated and trans fats, cholesterol, salt, and added sugars, and high in fruits, vegetables, whole grains, lean proteins, and healthy fats can help improve heart health.',
          ),
          ArticleSection(
            title: 'Maintain a healthy weight',
            body: 'Being overweight or obese increases the risk of heart disease. Losing weight can help improve heart health and reduce the risk of heart diseases.',
          ),
          ArticleSection(
            title: 'Manage stress',
            body: 'Chronic stress can have a negative impact on heart health. Finding ways to manage stress, such as through relaxation techniques, exercise, or counseling, can help improve heart health.',
          ),
          ArticleSection(
            title: 'Get enough sleep',
            body: 'Lack of sleep can increase the risk of high blood pressure, heart disease, and stroke. Aim for seven to eight hours of sleep per night.',
          ),
          ArticleSection(
            title: 'Limit alcohol intake',
            body: 'Drinking too much alcohol can increase blood pressure and contribute to heart disease. Limit alcohol intake to no more than one drink per day for women and two drinks per day for men.',
          ),
          ArticleSection(
            title: '',
            body: 'By making these lifestyle changes, you can significantly improve your cardiovascular health and reduce your risk of heart disease.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Resting Heart Rate & Exercise Heart Rate',
        description: 'Resting heart rate is the number of times your heart beats per minute when you are at rest. This means...',
        icon: Icons.speed_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF00838F)],
        sections: [
          ArticleSection(
            title: 'What is resting heart rate?',
            body: 'Resting heart rate is the number of times your heart beats per minute when you are at rest. This means that you are not engaging in any physical activity or experiencing any stress or excitement that could increase your heart rate. Resting heart rate is an important indicator of overall heart health, as a higher resting heart rate can be a sign of an increased risk for cardiovascular diseases, including heart attack and stroke. Typically, a normal resting heart rate for adults is between 60 and 100 beats per minute, with lower rates generally reflecting better cardiovascular health. Factors such as age, fitness level, and certain medical conditions can also impact your resting heart rate. It is recommended to regularly monitor your resting heart rate and discuss any concerns with your healthcare provider.',
          ),
          ArticleSection(
            title: 'What is exercise heart rate?',
            body: 'Exercise heart rate refers to the number of times your heart beats per minute while you\'re engaging in physical activity. It is also commonly referred to as your training heart rate. Your exercise heart rate can vary depending on a variety of factors, including your age, fitness level, and the intensity of the activity you\'re doing. Generally, during exercise, your heart rate will increase to help deliver oxygen and nutrients to your muscles and organs more efficiently. Monitoring your exercise heart rate can help you optimize your workout intensity and ensure that you\'re getting the most out of your exercise routine.',
          ),
          ArticleSection(
            title: 'Why is it important to know Resting Heart Rate and Exercise Heart Rate?',
            body: 'It is important to know your resting heart rate and exercise heart rate because they provide valuable information about your overall health and fitness level.\n\nResting heart rate, which is the number of times your heart beats per minute while at rest, can be an indicator of your cardiovascular health. A lower resting heart rate typically indicates a healthier heart and better fitness level. Regular exercise can help to lower your resting heart rate, which in turn can reduce your risk of heart disease, stroke, and other cardiovascular problems.\n\nExercise heart rate is important because it can help you determine the appropriate intensity level for your workouts. When you exercise at the right intensity level, you can maximize the benefits of your workouts and avoid overexertion, which can lead to injury or other health problems. Your exercise heart rate can be used to calculate your target heart rate zone, which is the range of heart rates that you should aim for during exercise in order to achieve the desired health and fitness benefits.\n\nBy monitoring your resting heart rate and exercise heart rate over time, you can track changes in your cardiovascular health and fitness level. This information can help you adjust your exercise routine and lifestyle habits to optimize your health and wellbeing.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Target Exercise Heart Rate',
        description: 'Target exercise heart rate is the range of heart rates that you should aim for during physical act...',
        icon: Icons.center_focus_strong_rounded,
        gradientColors: [const Color(0xFF5C6BC0), const Color(0xFF3F51B5)],
        sections: [
          ArticleSection(
            title: 'What is target exercise heart rate?',
            body: 'Target exercise heart rate is the range of heart rates that you should aim for during physical activity in order to achieve the desired health and fitness benefits. This range is based on your maximum heart rate, which is calculated by subtracting your age from 220. The target heart rate zone is typically 50% to 85% of your maximum heart rate, depending on the intensity of the exercise.',
          ),
          ArticleSection(
            title: 'Example',
            body: 'For example, if you\'re 30 years old, your maximum heart rate would be 190 beats per minute (220 - 30 = 190). To calculate your target heart rate zone for moderate-intensity exercise, you would aim for a heart rate between 95 and 162 beats per minute (50% to 85% of 190).',
          ),
          ArticleSection(
            title: 'Benefits of achieving target exercise heart rate',
            body: 'Achieving your target exercise heart rate can provide a variety of health and fitness benefits, including:\n\nImproved cardiovascular health: Regular aerobic exercise that raises your heart rate can strengthen your heart and cardiovascular system, reducing your risk of heart disease, stroke, and other cardiovascular problems.\n\nIncreased fitness level: Consistently working out within your target heart rate zone can help improve your overall fitness level, including your endurance, strength, and flexibility.\n\nMore efficient workouts: Working out at the right intensity level can help you get the most out of your exercise routine, maximizing the health and fitness benefits of each workout.\n\nWeight management: Exercising within your target heart rate zone can help you burn calories and lose weight, making it easier to achieve and maintain a healthy weight.\n\nReduced stress and anxiety: Exercise has been shown to reduce stress and anxiety levels, and working out within your target heart rate zone can help you achieve a greater sense of relaxation and well-being.\n\nBetter sleep quality: Regular exercise can improve the quality of your sleep, helping you feel more rested and refreshed each day.\n\nBy achieving your target exercise heart rate on a regular basis, you can experience these benefits and improve your overall health and well-being.',
          ),
        ],
      ),
    ];

    // Dynamic articles list for Weight & BMI (6 contents)
    final weightArticles = [
      ArticleItem(
        title: 'Healthy Weight',
        description: 'Maintaining a healthy weight is essential for preventing diseases and health problems related to be...',
        icon: Icons.monitor_weight_rounded,
        gradientColors: [const Color(0xFF42A5F5), const Color(0xFF0D47A1)],
        sections: [
          ArticleSection(
            title: '',
            body: 'Maintaining a healthy weight is essential for preventing diseases and health problems related to being overweight. Healthy weight range varies among individuals due to biological and mental differences. According to Harvard School of Public Health, healthy weight helps reduce the risk of developing heart disease, stroke, diabetes, hypertension, and several cancers. Thus, knowing your healthy weight range is crucial.\n\nThere are two methods to determine an adult\'s healthy weight. The first method uses body mass index (BMI), which is calculated by dividing weight by height in meters squared when measuring in kilos and meters. If measuring in pounds and inches, divide your weight by your height squared and multiply by a conversion ratio of 703. A BMI between 18.5 to 24.9 indicates a healthy or normal weight.\n\nMeasuring waist circumference is another popular method to determine healthy weight. For men, a waist measurement of 40 inches (101.6 cm) or less and 35 inches (88.9 cm) or less indicate a healthy weight.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Obesity',
        description: 'Complex and chronic disease is the medical term used for obesity, which occurs due to the e...',
        icon: Icons.accessibility_new_rounded,
        gradientColors: [const Color(0xFFEC407A), const Color(0xFF880E4F)],
        sections: [
          ArticleSection(
            title: '',
            body: 'Complex and chronic disease is the medical term used for obesity, which occurs due to the excessive accumulation of body fat as a result of consuming more calories than the body requires. This can disrupt the body\'s natural functions, leading to various diseases and health issues.\n\nGenerally, obesity in adults is defined as having a body mass index (BMI) of 30 or higher.\n\nObesity is categorized into three classes: Class I, Class II, and Class III, each having specific BMI ranges associated with them, as listed below:\n\n- Class III: BMI of 40 or higher.\n\nObesity in Class III, defined as having a BMI of 40 or higher, is considered severe and is associated with an increased risk of several serious health conditions, such as Type 2 diabetes and heart disease.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Obesity Causes',
        description: 'Many factors can contribute to obesity, including:',
        icon: Icons.fastfood_rounded,
        gradientColors: [const Color(0xFFFFA726), const Color(0xFFE65100)],
        sections: [
          ArticleSection(
            title: '',
            body: 'Many factors can contribute to obesity, including:',
          ),
          ArticleSection(
            title: '1. Unhealthy diet and drinking habits:',
            body: 'Consuming high-calorie foods and excessive amounts of food regularly may result in weight gain, as the body stores extra energy as fat when calorie intake is increased.',
          ),
          ArticleSection(
            title: '2. Lack of physical activity:',
            body: 'Leading a sedentary lifestyle, such as sitting at a computer for extended periods, can lead to weight gain as you expend fewer calories than you consume.',
          ),
          ArticleSection(
            title: '3. Genetics:',
            body: 'Your genetic makeup can make you more susceptible to gaining weight, and leptin deficiency caused by genetics can result in obesity as it prevents the body from signaling the brain to stop eating.',
          ),
          ArticleSection(
            title: '4. Stress:',
            body: 'Chronic stress may lead to unhealthy eating patterns, causing you to choose less nutritious foods.',
          ),
          ArticleSection(
            title: '5. Inadequate sleep:',
            body: 'Lack of sleep can impact your hormones, causing an increase in appetite and a craving for high-calorie items, and studies have shown that individuals who sleep adequately tend to weigh less.',
          ),
          ArticleSection(
            title: '6. Medications and medical conditions:',
            body: 'Increased body weight may be a symptom of medical conditions such as hypothyroidism, Cushing\'s syndrome, depression, and other neurological conditions. Additionally, certain medications, such as steroids, antidepressants, tranquilizers, blood pressure medications, or medications for seizures, can cause weight gain.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Diagnosing Obesity',
        description: 'In order to diagnose obesity, your doctor will perform a series of tests.',
        icon: Icons.medical_services_rounded,
        gradientColors: [const Color(0xFF26A69A), const Color(0xFF004D40)],
        sections: [
          ArticleSection(
            title: '',
            body: 'In order to diagnose obesity, your doctor will perform a series of tests.',
          ),
          ArticleSection(
            title: '1. Calculate Body Mass Index (BMI)',
            body: 'BMI calculation is a common method to determine if you are obese. If your BMI is over 30, you will be classified as obese. It is recommended to have an annual BMI check to assess your health risk and determine appropriate treatment.',
          ),
          ArticleSection(
            title: '2. Review medical history:',
            body: 'Your current and past weight, medical conditions, dietary habits, exercise routines, sleep patterns, and stress levels will be evaluated. Additionally, your doctor may inquire about your family\'s medical history.',
          ),
          ArticleSection(
            title: '3. Conduct a physical examination:',
            body: 'To diagnose obesity and identify any underlying conditions, a comprehensive physical examination will be conducted, which includes assessing vital signs such as blood pressure and heart rate.',
          ),
          ArticleSection(
            title: '4. Additional tests:',
            body: 'Various assessments will be performed, including ultrasonography to measure body fat, screening tests, skin fold thickness measurements, and waist circumference assessments. Blood tests, liver function testing, and cardiac tests may also be necessary to identify potential health concerns associated with obesity.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Revamping Lifestyle to Combat Obesity',
        description: 'Modifying lifestyle and behaviors can be an effective solution if you are struggling with being ove...',
        icon: Icons.directions_run_rounded,
        gradientColors: [const Color(0xFF66BB6A), const Color(0xFF1B5E20)],
        sections: [
          ArticleSection(
            title: '',
            body: 'Modifying lifestyle and behaviors can be an effective solution if you are struggling with being overweight or obese.',
          ),
          ArticleSection(
            title: '1. Develop a wholesome diet:',
            body: 'In order to establish a healthy diet, it is essential to first cut back on your sugar and fat intake. You should assess your eating habits and seek advice from your physician to determine your daily calorie requirements. The next step is to opt for nutritious foods, including fruits, vegetables, legumes, whole grains, and nuts.',
          ),
          ArticleSection(
            title: '2. Increase physical activity:',
            body: 'Increasing physical activity is crucial in treating obesity. Children should engage in at least 60 minutes of exercise daily, while adults should exercise for 150 minutes per week to manage weight. Gradually increase your exercise time to 300 minutes per week as your stamina and fitness level improve.',
          ),
          ArticleSection(
            title: '3. Seek counseling or support groups:',
            body: 'Seek out support groups and mental health counseling to identify unhealthy obesity triggers, manage anxiety, depression, or emotional eating disorders.',
          ),
        ],
      ),
      ArticleItem(
        title: 'Weight-loss tips',
        description: 'There are some tips for healthy weight loss that are applicable to almost everyone. Read on.',
        icon: Icons.lightbulb_rounded,
        gradientColors: [const Color(0xFFFFD54F), const Color(0xFFF57F17)],
        sections: [
          ArticleSection(
            title: '',
            body: 'There are some tips for healthy weight loss that are applicable to almost everyone. Read on.',
          ),
          ArticleSection(
            title: '1. Eat regularly:',
            body: 'Eating regularly throughout the day and avoiding skipping meals can help reduce the urge to snack. Keep in mind that skipping meals won\'t help you lose weight faster.',
          ),
          ArticleSection(
            title: '2. Practice mindful eating:',
            body: 'Eating slowly encourages you to pay attention to what you\'re eating and your portion size while also boosting hormones that aid in weight loss. Tracking where and when you eat extra calories can also help you make healthier food choices and lose weight.',
          ),
          ArticleSection(
            title: '3. Choose high-fiber and high-protein foods:',
            body: 'Avoid processed foods, excess fat, and sugar. Instead, opt for foods that are high in protein and fiber, which can help you reduce snacking and lose weight more quickly.',
          ),
          ArticleSection(
            title: '4. Get enough sleep:',
            body: 'People who want to lose weight should get enough sleep because a lack of sleep can slow down metabolism, promote fat accumulation, and interfere with hormones that regulate appetite.',
          ),
          ArticleSection(
            title: '5. Stay hydrated with water:',
            body: 'Drinks that are high in calories and sugar can be replaced with water, which can also help fill you up and reduce appetite.',
          ),
          ArticleSection(
            title: '6. Exercise in the evening:',
            body: 'Exercising in the evening can help with weight loss since the body\'s metabolism typically slows down during this time. Performing aerobic exercises after meals can boost your metabolic rate and keep it elevated for several hours after your workout.',
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
