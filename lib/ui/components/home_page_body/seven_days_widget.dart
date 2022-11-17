import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/resourses/bg.dart';
import 'package:weather_app/ui/components/blur_container/blur_container.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class SevenDaysWidget extends StatelessWidget {
  const SevenDaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: BlurContainer(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => SevenDaysWidgetItem(
            day: model.date[index],
            dayTemp: model.setDailyDayTemp(index),
            nightTemp: model.setDailyNightTemp(index),
            icon: model.setDailyIcon(index),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: 8,
        ),
      ),
    );
  }
}

class SevenDaysWidgetItem extends StatelessWidget {
  final String day;
  final String icon;
  final int dayTemp;
  final int nightTemp;
  const SevenDaysWidgetItem({
    super.key,
    this.day = 'Error',
    required this.icon,
    this.dayTemp = 0,
    this.nightTemp = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            day,
            style: TextStyle(
              fontSize: 20,
              height: 22 / 20,
              color: AppColors.textColor,
            ),
          ),
        ),
        Image.network(
          icon,
          width: 30,
          height: 30,
          color: AppColors.textColor,
        ),
        _DayNightTemp(
          dayTemp: dayTemp,
          nightTemp: nightTemp,
        ),
      ],
    );
  }
}

class _DayNightTemp extends StatelessWidget {
  final int dayTemp;
  final int nightTemp;
  const _DayNightTemp({
    super.key,
    this.dayTemp = 5,
    this.nightTemp = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Text>[
          Text(
            '$dayTemp℃',
            style: TextStyle(
              fontSize: 20,
              height: 22 / 20,
              color: AppColors.textColor,
            ),
          ),
          Text(
            '$nightTemp℃',
            style: TextStyle(
              fontSize: 20,
              height: 22 / 20,
              color: AppColors.valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
