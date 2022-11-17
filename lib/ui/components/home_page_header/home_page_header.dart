import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/resourses/app_icons.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              model.setDailyIcon(0),
              width: 52,
              height: 42,
              color: AppColors.textColor,
            ),
            const SizedBox(width: 24),
            Text(
              model.getCurrentStatus(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textColor,
                height: 22 / 16,
              ),
            ),
          ],
        ),
        Text(
          '${model.setCurrentTemp()}℃',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 90,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HeaderMinMax.max(deg: model.setCurrentMaxTemp()),
            const SizedBox(width: 65),
            HeaderMinMax.min(deg: model.setCurrentMinTemp()),
          ],
        ),
      ],
    );
  }
}

class HeaderMinMax extends StatelessWidget {
  final String icon;
  final int deg;

  const HeaderMinMax.min({super.key, this.deg = 0}) : icon = AppIcons.min;
  const HeaderMinMax.max({super.key, this.deg = 0}) : icon = AppIcons.max;

  @override
  Widget build(BuildContext context) {
    String temp = deg < 10 && deg > 0 ? '0$deg°' : '$deg°';
    if (deg > -10 && deg < 0) temp = '-0${-deg}°';
    return Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 4),
        Text(
          temp,
          style: TextStyle(
            fontSize: 25,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
