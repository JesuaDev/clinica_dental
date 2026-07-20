import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DropDown extends StatelessWidget {
  final ColorScheme color;
  final List<String> dataDropDown;
  final ValueChanged<String?> onChanged;
  final String? selectedValue;

  const DropDown({
    super.key,
    required this.color,
    required this.dataDropDown,
    required this.onChanged,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        hint: Text(
          dataDropDown.isNotEmpty ? dataDropDown.first : "Más filtros ",
          style: TextStyle(fontSize: 14),
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),

        items: dataDropDown.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontSize: 14)),
          );
        }).toList(),

        onChanged: onChanged,
        value: selectedValue,
        icon: HugeIcon(icon: HugeIcons.strokeRoundedFilter, size: 20),
        focusColor: Colors.transparent,
        dropdownColor: color.onPrimary,
        underline: SizedBox.shrink(),
        mouseCursor: SystemMouseCursors.click,
        dropdownMenuItemMouseCursor: SystemMouseCursors.click,
      ),
    );
  }
}
