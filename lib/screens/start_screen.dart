import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'customer_signup_screen.dart';
import 'tracking_screen.dart';
import 'chatbot_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Deliverex',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Fleet Dispatch • Delivery Tracking • OCR Documentation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _StartButton(
                    label: 'Login',
                    icon: Icons.login_rounded,
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _StartButton(
                    label: 'Sign Up as Customer',
                    icon: Icons.person_add_alt_1_rounded,
                    color: AppColors.accent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerSignupScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _OutlineStartButton(
                    label: 'Track Delivery',
                    icon: Icons.search_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackingScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _OutlineStartButton(
                    label: 'Chatbot',
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatbotScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Providential 628 Site Preparation Services',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _StartButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _OutlineStartButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _OutlineStartButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.primary),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}