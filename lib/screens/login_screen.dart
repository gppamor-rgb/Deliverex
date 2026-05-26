import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'driver_home_screen.dart';
import 'customer_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  bool isPasswordVisible = false;

  void loginUser() {
    final username = usernameController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter username/email and password.';
      });
      return;
    }

    // DEMO ROLE CHECKING ONLY.
    // Later, this should come from backend/API:
    // response = { userId, name, role, token }

    if (username == 'driver' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DriverHomeScreen(),
        ),
      );
    } else if (username == 'customer' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomerHomeScreen(),
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                color: AppColors.card,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.lock_person_rounded,
                        size: 68,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Deliverex Login',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Login using your account. The system will open the correct dashboard based on your role.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textLight),
                      ),

                      const SizedBox(height: 24),

                      TextField(
                        controller: usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Username or Email',
                          prefixIcon: Icon(Icons.person_rounded),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_rounded),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                          ),
                        ),
                      ),

                      if (errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Demo accounts: driver / 123456 or customer / 123456',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}