import 'package:flutter/material.dart';
import '../screens/start_screen.dart';
import '../core/app_colors.dart';

class DeliverexApp extends StatelessWidget {
  const DeliverexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deliverex Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}