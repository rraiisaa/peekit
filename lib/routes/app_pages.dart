import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:peekit_app/auth/login_screen.dart';
import 'package:peekit_app/auth/register_screen.dart';
import 'package:peekit_app/bindings/home_bindings.dart';
import 'package:peekit_app/screens/home_screen.dart';
import 'package:peekit_app/screens/news_detail_screen.dart';
import 'package:peekit_app/screens/news_screen.dart';
import 'package:peekit_app/screens/notification_screen.dart';
import 'package:peekit_app/screens/onboarding/onboarding_screen.dart';
import 'package:peekit_app/screens/profile._screen.dart';
import 'package:peekit_app/screens/search_screen.dart';
import 'package:peekit_app/screens/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // INITIAL = screen pertama yang muncul saat apliaksi dibuka
  static const INITIAL = Routes.SPLASH;

   static final routes  = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen()
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterScreen()
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen()
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.NEWS_SCREEN,
      page: () => NewsScreen(),
      // binding: NewsBindings(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: _Paths.SEARCH_SCREEN,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => NewsDetailScreen(),
    )
   ];
}