import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class InputSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const InputSearch({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: colorScheme.secondary,

        filled: true,
        prefixIcon: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
          child: SizedBox(
            width: 50,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: colorScheme.onSecondary,
              size: 20,
            ),
          ),
        ),

        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: TextStyle(color: colorScheme.onSecondary),
        contentPadding: EdgeInsets.only(left: 10, top: 20, bottom: 10),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 1, color: colorScheme.primary),
        ),
      ),
    );
  }
}
