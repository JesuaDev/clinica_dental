import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget {
  final ColorScheme theme;
  final ValueChanged<String> onChanged;
  const NumberInput({super.key, required this.theme, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],

      onChanged: onChanged,

      decoration: InputDecoration(
        prefixText: 'L.  ',
        hintText: '0.00',
        fillColor: theme.secondary,
        filled: true,

        hintStyle: TextStyle(color: theme.onSecondary.withValues(alpha: .5)),
        contentPadding: EdgeInsets.only(left: 30, top: 20, bottom: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: theme.primary),
        ),
      ),
    );
  }
}
