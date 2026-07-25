import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/shared.dart';
import '../../widgets.dart';


class ActionButtonMore extends StatefulWidget {
  const ActionButtonMore({super.key, required this.colorTheme});

  final ColorScheme colorTheme;

  @override
  State<ActionButtonMore> createState() => _ActionButtonMoreState();
}

class _ActionButtonMoreState extends State<ActionButtonMore> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle styleItemsText = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w200,
      color: widget.colorTheme.onSecondary.withValues(alpha: .7),
      letterSpacing: 1,
    );

    return PopupMenuButton<ActionsRegisters>(
      surfaceTintColor: Colors.transparent,
      splashRadius: 0,
      tooltip: "",
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
      ),

      onSelected: (value) {
        switch (value) {
          case ActionsRegisters.details:
            break;
          case ActionsRegisters.update:
            break;
          case ActionsRegisters.delete:
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ActionsRegisters.details,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedProfile),
              SizedBox(width: 8),
              Text("Ver detalles", style: styleItemsText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ActionsRegisters.update,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedEdit01),
              SizedBox(width: 8),
              Text("Actualizar", style: styleItemsText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ActionsRegisters.delete,
          child: Row(
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedDelete01),
              SizedBox(width: 8),
              Text("Eliminar", style: styleItemsText),
            ],
          ),
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          isHover = true;
        }),
        onExit: (_) => setState(() {
          isHover = false;
        }),

        child: ButtonAction(
          color: widget.colorTheme,
         
          icon: HugeIcons.strokeRoundedMoreHorizontal,
        )
      ),
    );
  }
}
