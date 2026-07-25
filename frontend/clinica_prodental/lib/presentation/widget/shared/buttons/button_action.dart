import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ButtonAction extends StatefulWidget {
  const ButtonAction({
    super.key,
    required this.color,
    this.icon,
   this.onTapButton,
  });

  final ColorScheme color;
  final dynamic icon;
  final VoidCallback? onTapButton;

  @override
  State<ButtonAction> createState() => _ButtonActionState();
}

class _ButtonActionState extends State<ButtonAction> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTapButton,
      onHover: (hover) {
        setState(() {
          isHover = hover;
        });
      },
      mouseCursor: SystemMouseCursors.click,

      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isHover
                ? Colors.transparent
                : widget.color.onSecondary.withValues(alpha: .2),
          ),
          color: isHover ? widget.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: HugeIcon(
          icon: widget.icon,
          size: 25,
          color: isHover
              ? Colors.white70
              : widget.color.onSecondary.withValues(alpha: .7),
        ),
      ),
    );
  }
}
