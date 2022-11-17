import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/resourses/app_icons.dart';
import 'package:weather_app/ui/components/blur_container/blur_container.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class BlockCardWidget extends StatelessWidget {
  const BlockCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 181,
        mainAxisExtent: 160,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: 4,
      itemBuilder: (context, i) => BlockCardWidgetItem(
        icon: BlockCardWidgetOptions.icons[i],
        subTitle: BlockCardWidgetOptions.subTitles[i],
        value: model.setValues(i),
        unit: BlockCardWidgetUnits.values[i],
      ),
    );
  }
}

class BlockCardWidgetItem extends StatelessWidget {
  final String icon;
  final String subTitle;
  final double? value;
  final BlockCardWidgetUnits unit;
  const BlockCardWidgetItem({
    super.key,
    required this.icon,
    required this.subTitle,
    this.value,
    this.unit = BlockCardWidgetUnits.deg,
  });

  @override
  Widget build(BuildContext context) {
    String blocCardWidgetUnit =
        BlockCardWidgetUnitsTreatment.unitsTreatment(unit);
    return BlurContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: AppColors.textColor,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${value ?? 'Error'} $blocCardWidgetUnit',
                style: TextStyle(
                  fontSize: 14,
                  height: 22 / 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.valueColor,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 10,
                  height: 22 / 10,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlockCardWidgetOptions {
  static List<String> icons = [
    AppIcons.windSpeed,
    AppIcons.feelsLike,
    AppIcons.hummidity,
    AppIcons.visibility,
  ];

  static List<String> subTitles = [
    'Скорость ветра',
    'Ощущается',
    'Влажность',
    'Видимость',
  ];
}

enum BlockCardWidgetUnits { km, deg, percent, kmh }

class BlockCardWidgetUnitsTreatment {
  static String unitsTreatment(
    BlockCardWidgetUnits units,
  ) {
    switch (units) {
      case BlockCardWidgetUnits.km:
        return 'км/ч';
      case BlockCardWidgetUnits.deg:
        return '°';
      case BlockCardWidgetUnits.percent:
        return '%';
      default:
        return 'км';
    }
  }
}
