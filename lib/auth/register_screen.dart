import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/utils/validators.dart';
import 'package:peekit_app/auth/components/auth_button.dart';
import 'package:peekit_app/auth/components/auth_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 1)); // jeda 1 detik
        _lottieController.reset();
        _lottieController.forward();
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // 🔹 supaya lebih dekat ke atas, tapi tetap aman di semua device
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animation
              Center(
                child: Lottie.asset(
                  'assets/animate/Peek_regist.json',
                  controller: _lottieController,
                  width: 180,
                  height: 150,
                  onLoaded: (composition) {
                    _lottieController
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Hoolaa! Make a New Account",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Peek the World!",
                style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 28),

              // 🔹 FORM
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthFormField(
                      controller: _nameController,
                      label: "Full Name",
                      hintText: "Enter your full name",
                      validator: Validators.validateFullName,
                    ),
                    const SizedBox(height: 18),
                    AuthFormField(
                      controller: _emailController,
                      label: "Email",
                      hintText: "Enter your Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 18),
                    AuthFormField(
                      controller: _passwordController,
                      label: "Password",
                      hintText: "Enter your Password",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.visibility),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 18),
                    AuthFormField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      hintText: "Re-enter your password",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.visibility),
                      validator: (value) => Validators.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 40),
                    AuthButton(
                      text: "Register",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacementNamed(context, Routes.HOME);
                        }
                      },
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
