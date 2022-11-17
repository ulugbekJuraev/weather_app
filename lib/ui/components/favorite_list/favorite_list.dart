import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/resourses/bg.dart';

import 'package:hive_flutter/hive_flutter.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<FavoriteHistory>>(
        valueListenable:
            Hive.box<FavoriteHistory>(HiveBoxes.favoriteBox).listenable(),
        builder: (context, value, _) {
          return ListView.separated(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            itemBuilder: (context, index) => FavoriteCard(
              index: index,
              value: value,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: value.length,
          );
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final int index;
  final Box<FavoriteHistory> value;
  // final Function func;

  const FavoriteCard({
    super.key,
    required this.index,
    required this.value,
    // required this.func,
  });

  @override
  Widget build(BuildContext context) {
    final int? color = value.getAt(index)?.color;
    final model = context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(value.getAt(index)?.bg ?? Bg.clearBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Избранное',
                style: TextStyle(
                  fontSize: 12,
                  height: 22 / 12,
                  color: Color(color ?? 0xFFFFFFFF),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value.getAt(index)?.cityName ?? 'Erorr',
                style: TextStyle(
                  fontSize: 18,
                  height: 22 / 18,
                  color: Color(color ?? 0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.getAt(index)?.cityName ?? 'Erorr',
                style: TextStyle(
                  fontSize: 12,
                  height: 22 / 12,
                  color: Color(color ?? 0xFFFFFFFF),
                ),
              ),
            ],
          ),
          IconButton(
            color: Colors.red,
            onPressed: () {
              model.deleteFavorite(index, context,
                  cityName: model.weatherData?.timezone);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
