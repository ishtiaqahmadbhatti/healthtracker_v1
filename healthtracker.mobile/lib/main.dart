import 'package:flutter/material.dart';
import 'app/app_screens/splash_screen.dart';
import 'app/app_services/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEF4444), // Rose red
          secondary: Color(0xFF06B6D4), // Cyan
          surface: Color(0xFF1E293B), // Slate/Grey
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
