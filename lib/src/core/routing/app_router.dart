import 'package:andika/src/core/routing/splash_page.dart';
import 'package:andika/src/features/auth/presentation/login_page.dart';
import 'package:andika/src/features/auth/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/document/data/remote/document_remote_repository.dart';
import '../../features/document/presentation/widgets/blocs/document_bloc.dart';
import '../../features/document/presentation/widgets/document_page.dart';
import '../../features/document/presentation/widgets/home_page.dart';
import 'app_routes.dart';

const _splashRoute = '/splash';

GoRouter createRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();

  return GoRouter(
    initialLocation: _splashRoute,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      if (authState is AuthInitial || authState is AuthLoading) {
        return location == _splashRoute ? null : _splashRoute;
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute =
          location == AppRoutes.signIn || location == AppRoutes.signUp;

      if (location == _splashRoute) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.signIn;
      }

      if (!isAuthenticated && !isAuthRoute) return AppRoutes.signIn;
      if (isAuthenticated && isAuthRoute) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: _splashRoute,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.document,
        builder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return BlocProvider(
            create: (_) => DocumentBloc(documentRepo: DocumentRemoteRepo()),
            child: DocumentPage(documentId: documentId),
          );
        },
      ),
    ],
  );
}

class GoRouterAuthNotifier extends ChangeNotifier {
  GoRouterAuthNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}
