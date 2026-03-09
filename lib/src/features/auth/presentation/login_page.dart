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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {}
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size.fromWidth(320)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Welcome to Google Docs clone! 👋🏻',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
