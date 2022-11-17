import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/ui/theme/app_colors.dart';

class BlurContainer extends StatelessWidget {
  final Widget? child;
  const BlurContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.boxBgColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
