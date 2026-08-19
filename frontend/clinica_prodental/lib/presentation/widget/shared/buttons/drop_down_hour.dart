import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DropDownHour extends StatelessWidget {
  final List<String> listHours;
  final String? selected;
  final String hint;

  final ColorScheme color;
  final Color backgroundColor;

  final ValueChanged<String?> onChanged;

  const DropDownHour({
    super.key,
    required this.color,
    required this.onChanged,
    this.selected,
    required this.listHours,
    required this.backgroundColor,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: DropdownButton(
        hint: Text(hint),

        icon: Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedClock01,
              color: color.onSecondary.withValues(alpha: .4),
            ),
          ),
        ),

        underline: SizedBox.shrink(),
        mouseCursor: SystemMouseCursors.click,
        dropdownMenuItemMouseCursor: SystemMouseCursors.click,

        value: selected,
        items: listHours.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
