import 'package:flutter/cupertino.dart';
import 'package:weather_app/ui/pages/error_page/error_page.dart';
import 'package:weather_app/ui/pages/home_page/home_page.dart';
import 'package:weather_app/ui/pages/search_page/search_page.dart';
import 'package:weather_app/ui/router/app_routes.dart';

abstract class AppNavigator {
  static String get initialRoute => AppRoutes.home;

  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.search: (context) => const SearchPage(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return ErrorPage.error404;
  }
}
