abstract class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/';
  static const document = '/document/:documentId';
  static String documentPath(String documentId) => '/document/$documentId';
}
