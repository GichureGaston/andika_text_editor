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
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'This is a Flutter app made with Firebase and Bloc ✍️',
                      ),
                    ),
                  ),
                  EmailTextField(controller: _emailTextEditingController),
                  PasswordTextField(controller: _passwordTextEditingController),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sign in'),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      children: [
                        TextSpan(
                          text: 'Join now',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Routemaster.of(
                              context,
                            ).push(AppRoutes.register),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
