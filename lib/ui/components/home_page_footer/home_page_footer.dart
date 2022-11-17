import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/resourses/app_icons.dart';
import 'package:weather_app/ui/components/blur_container/blur_container.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class HomePageFooter extends StatelessWidget {
  final String sunsetTime;
  final String sunriseTime;
  const HomePageFooter({
    super.key,
    this.sunriseTime = '10:20',
    this.sunsetTime = '19:20',
  });

  @override
  Widget build(BuildContext context) {
    return BlurContainer(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomePageFooterItem(
              icon: AppIcons.sunrise,
              text: 'Восход $sunriseTime',
            ),
            HomePageFooterItem(
              icon: AppIcons.sunset,
              text: 'Закат $sunsetTime',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageFooterItem extends StatelessWidget {
  final String icon;
  final String text;
  const HomePageFooterItem({
    super.key,
    this.text = 'Error',
    this.icon = AppIcons.sunset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          icon,
          color: AppColors.textColor,
        ),
        const SizedBox(height: 18),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            height: 22 / 16,
            color: AppColors.valueColor,
          ),
        ),
      ],
    );
  }
}
