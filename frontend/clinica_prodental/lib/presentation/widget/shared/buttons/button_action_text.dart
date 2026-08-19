import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ButtonActionText extends StatefulWidget {
  final dynamic icon;
  final String text;
  final Color color;

  final VoidCallback onAction;

  const ButtonActionText({
    super.key,
    this.icon,
    required this.text,
    required this.color,
    required this.onAction,
  });

  @override
  State<ButtonActionText> createState() => _ButtonActionTextState();
}

class _ButtonActionTextState extends State<ButtonActionText> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final Color colorContent = isHover ? Colors.white : widget.color;

    return InkWell(
      onTap: widget.onAction,
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },

      mouseCursor: SystemMouseCursors.click,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isHover ? widget.color : widget.color.withValues(alpha: .2),
        ),
        child: Row(
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: colorContent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 5),
            widget.icon != null
                ? HugeIcon(icon: widget.icon, color: colorContent)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
