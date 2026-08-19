import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TextInputForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ColorScheme color;
  final dynamic icon;
  final int lines;

  const TextInputForm({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.color,
    this.icon,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: lines,
      decoration: InputDecoration(
        fillColor: color.secondary,

        filled: true,
        prefixIcon: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 8),
          child: icon != null
              ? SizedBox(
                  width: 50,
                  child: HugeIcon(icon: icon, color: color.onSecondary),
                )
              : SizedBox.shrink(),
        ),

        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: TextStyle(color: color.onSecondary.withValues(alpha: .5)),
        contentPadding: EdgeInsets.only(left: 30, top: 20, bottom: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: color.primary),
        ),
      ),
    );
  }
}
