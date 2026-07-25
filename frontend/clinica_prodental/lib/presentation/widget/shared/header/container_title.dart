import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ContainerTitle extends StatelessWidget {
  const ContainerTitle({
    super.key,
    required this.styleLabel,
    this.icon,
    required this.color,
    this.radius = 50,
    required this.title,
    this.subTitle,
    this.fontSize = 17,
  });

  final TextStyle styleLabel;
  final dynamic icon;
  final Color color;
  final double radius;
  final String title;
  final String? subTitle;
  final double fontSize; 
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        WrapperIconTitle(icon: icon, color: color, radius: radius),

        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: styleLabel.copyWith(fontSize: fontSize)),
            subTitle != null
                ? 
            Text(
                    subTitle!,
              style: TextStyle(
                color: colorTheme.onSecondary.withValues(alpha: .4),
              ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ],
    );
  }
}

class WrapperIconTitle extends StatelessWidget {
  final dynamic icon;
  final Color color;
  final double radius;
  const WrapperIconTitle({
    super.key,
    this.icon,
    required this.color,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: icon != null
          ? HugeIcon(icon: icon, color: color)
          : SizedBox.shrink(),
    );
  }
}
