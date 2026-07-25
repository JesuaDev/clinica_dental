import 'package:flutter/material.dart';
import 'package:clinica_prodental/presentation/widget/shared/header/container_title.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ContentHeaderForm extends StatefulWidget {
  final String title;
  final String subTitle;
  final dynamic icon;

  const ContentHeaderForm({
    super.key,
    required this.title,
    required this.subTitle, this.icon,
  });

  @override
  State<ContentHeaderForm> createState() => _ContentHeaderFormState();
}

class _ContentHeaderFormState extends State<ContentHeaderForm> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final childIcon = HugeIcon(
      icon: HugeIcons.strokeRoundedCancel01,
      color: isHover ? Colors.white70 : color.onSecondary,
    );

    return Row(
      children: [
        ContainerTitle(
          styleLabel: TextStyle(),
          color: color.onSecondary,
          title: widget.title,
          subTitle: widget.subTitle,
          fontSize: 25,
          icon: widget.icon,
        ),

        Spacer(),

        GestureDetector(
          onTap: () => context.pop(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) => setState(() {
              isHover = true;
            }),
            onExit: (event) => setState(() {
              isHover = false;
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: color.onSecondary.withValues(alpha: .15),
                ),
                borderRadius: BorderRadius.circular(15),
                color: isHover ? Colors.red : Colors.transparent,
              ),
              child: isHover ? Spin(child: childIcon) : childIcon,
            ),
          ),
        ),
      ],
    );
  }
}
