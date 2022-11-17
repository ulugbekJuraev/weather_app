import 'package:flutter/material.dart';
import 'package:weather_app/resourses/app_gif.dart';
import 'package:weather_app/ui/router/app_routes.dart';

abstract class ErrorPage {
  static Route get error404 {
    return MaterialPageRoute(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.home);
          },
          child: Scaffold(
            backgroundColor: const Color(0xff323232),
            body: SafeArea(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  AppGifs.error404,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
