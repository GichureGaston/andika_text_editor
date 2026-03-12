import 'package:andika/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:andika/src/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/routing/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state!.message),
                backgroundColor: const Color(0xFFB04040),
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is! AuthAuthenticated,
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1714),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Color(0xFFF0E6C8),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome back ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1714),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to continue writing',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9C8E78),
                        ),
                      ),
                      const SizedBox(height: 28),
                      EmailTextField(controller: _emailController),
                      const SizedBox(height: 12),
                      PasswordTextField(controller: _passwordController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: state is AuthLoading ? null : _onSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1714),
                          foregroundColor: const Color(0xFFF0E6C8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFF0E6C8),
                                ),
                              )
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B6358),
                            ),
                            children: [
                              TextSpan(
                                text: 'Join now',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1714),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.go(AppRoutes.signUp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
