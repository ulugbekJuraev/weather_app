import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/resourses/app_icons.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class SearchPageCurrentRegion extends StatelessWidget {
  const SearchPageCurrentRegion({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(model.setTheme()),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CurrentRegionInfo(
                currentCity: model.weatherData?.timezone,
              ),
              CurrentRegionTempInfo(
                currentTemp: model.setCurrentTemp(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentRegionInfo extends StatelessWidget {
  final bool isFavorite;
  final String? currentCity;
  const CurrentRegionInfo({
    super.key,
    this.isFavorite = false,
    required this.currentCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Текущее место',
          style: TextStyle(
            fontSize: 12,
            height: 22 / 12,
            color: AppColors.valueColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          currentCity ?? 'Error',
          style: TextStyle(
            fontSize: 18,
            height: 22 / 18,
            color: AppColors.valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Азия/Ташкент',
          style: TextStyle(
            fontSize: 12,
            height: 22 / 12,
            color: AppColors.valueColor,
          ),
        ),
      ],
    );
  }
}

class CurrentRegionTempInfo extends StatelessWidget {
  final int? currentTemp;
  const CurrentRegionTempInfo({super.key, required this.currentTemp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.cloudy),
        const SizedBox(width: 10),
        Text(
          '${currentTemp ?? 0}℃',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.valueColor,
          ),
        ),
      ],
    );
  }
}
