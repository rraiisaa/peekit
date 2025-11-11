import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peekit_app/auth/components/auth_button.dart';
import 'package:peekit_app/auth/components/auth_form_field.dart';
import 'package:peekit_app/auth/components/social_auth_button.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🌀 Header Animasi (Lottie)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Lottie.asset(
                    'assets/animate/Peek_regist.json', // ganti sesuai file animasi kamu
                    controller: _lottieController,
                    width: size.width * 0.7,
                    height: size.height * 0.25,
                    onLoaded: (composition) {
                      _lottieController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
              ),

              /// 📋 Main Content
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🏷️ Title Section
                    Text(
                      "Hoola!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Don't worry, we'll remember you!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 40),

                    /// 🔐 Form Section
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthFormField(
                            controller: _emailController,
                            label: "Email",
                            hintText: "Enter your Email",
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 18),
                          AuthFormField(
                            controller: _passwordController,
                            label: "Password",
                            hintText: "Enter your password",
                            obscureText: true,
                            suffixIcon: const Icon(Icons.visibility_off),
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                              child: const Text("Forgot Password?"),
                            ),
                          ),
                          const SizedBox(height: 25),

                          /// 🔵 Login Button
                          AuthButton(
                            text: "Login",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.HOME);
                              }
                            },
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                          ),

                          const SizedBox(height: 30),

                          /// 🔸 Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "or continue with",
                                  style: TextStyle(
                                    color:
                                        AppColors.textPrimary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// 🔹 Social Login Buttons
                          SocialAuthButton(
                            assetIcon: "assets/icons/google_logo.svg",
                            label: "Login with Google",
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
                          SocialAuthButton(
                            assetIcon: "assets/icons/apple_logo.svg",
                            label: "Login with Apple",
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            onPressed: () {},
                          ),

                          const SizedBox(height: 30),

                          /// 👤 Register Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account yet?",
                                style: TextStyle(
                                  color: AppColors.textPrimary
                                      .withOpacity(0.8),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, Routes.REGISTER),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: const Text("Register"),
                              ),
                            ],
                          ),
                        ],
                      ),
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
