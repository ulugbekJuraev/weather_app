import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/components/favorite_list/favorite_list.dart';
import 'package:weather_app/ui/components/search_page_app_bar/search_page_app_bar.dart';
import 'package:weather_app/ui/components/search_page_current_region/search_page_current_region.dart';
import 'package:weather_app/ui/pages/noConnection/no_connection.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffD8E8F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SearchPageAppBar(),
            SearchPageCurrentRegion(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Избранное',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff323232),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FavoriteList(),
          ],
        ),
      ),
    );
  }
}
