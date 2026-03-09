import 'package:flutter/cupertino.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/document/presentation/widgets/new_document_page.dart';

const _login = '/login';
const _register = '/register';
const _document = '/document';
const _newDocument = '/newDocument';

abstract class AppRoutes {
  static String get document => _document;
  static String get newDocument => _newDocument;
  static String get login => _login;
  static String get register => _register;
}

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(_login),
  routes: {
    _login: (_) => const TransitionPage(child: LoginPage()),
    _register: (_) => const TransitionPage(child: RegisterPage()),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(_newDocument),
  routes: {
    _newDocument: (_) => const TransitionPage(child: NewDocumentPage()),
    '$_document/:id': (info) {
      final docId = info.pathParameters['id'];
      if (docId == null) {
        return const Redirect(_newDocument);
      }
      return TransitionPage(child: Center(child: Container()));
    },
  },
);
