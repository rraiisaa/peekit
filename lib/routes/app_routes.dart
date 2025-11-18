// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const NEWS_SCREEN = _Paths.NEWS_SCREEN;
  static const NOTIFICATION_SCREEN = _Paths.NOTIFICATION_SCREEN;
  static const PROFILE_SCREEN = _Paths.PROFILE_SCREEN;
  static const SEARCH_SCREEN = _Paths.SEARCH_SCREEN;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
}

// pendeklarasian routes dari masing masing screen
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const NEWS_SCREEN = '/news-screen';
  static const NOTIFICATION_SCREEN = '/notification-screen';
  static const PROFILE_SCREEN = '/profile-screen';
  static const SEARCH_SCREEN = '/search';
  static const NEWS_DETAIL = '/news-detail';
}