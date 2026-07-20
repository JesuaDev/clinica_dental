import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinica_prodental/presentation/providers/custom/preferences/type_layout_provider.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../widgets.dart';

class ContentFiltersRegister extends ConsumerStatefulWidget {
  final ColorScheme color;
  final List<String> dataDropDown;
  final String titleButton;
  final String hintText;
  final Function(BuildContext context) onOpenDialog;
  const ContentFiltersRegister({
    super.key,
    required this.color,
    required this.dataDropDown,
    required this.onOpenDialog,
    required this.titleButton,
    required this.hintText,
  });

  @override
  ConsumerState<ContentFiltersRegister> createState() =>
      _ContentFiltersRegisterState();
}

class _ContentFiltersRegisterState
    extends ConsumerState<ContentFiltersRegister> {
  late final TextEditingController controller;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLayoutProvider = ref.watch(typeLayoutProvider);

    return Padding(
      padding: EdgeInsetsGeometry.only(top: 30),
      child: SizedBox(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,

              child: InputSearch(
                controller: controller,
                onChanged: (value) {
                  debugPrint(value);
                },
                hintText: widget.hintText,
              ),
            ),

            SizedBox(width: 10),
            //TODO :
            DropDown(
              color: widget.color,
              dataDropDown: widget.dataDropDown,
              onChanged: (value) {
                _selectedValue = value;
                setState(() {});
              },

              selectedValue: _selectedValue,
            ),

            Spacer(),

            SegmentedLayout(
              color: widget.color,
              onSelectedChanged: (value) {
                ref.read(typeLayoutProvider.notifier).toggleLayout(value);
              },
              selectedType: selectedLayoutProvider,
            ),
            SizedBox(width: 12),

            ButtonCreate(
              colorTheme: widget.color,
              onOpenDialog: (context) {
                widget.onOpenDialog(context);
              },
              titleButton: widget.titleButton,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonCreate extends StatelessWidget {
  const ButtonCreate({
    super.key,
    required this.colorTheme,
    required this.onOpenDialog,
    required this.titleButton,
  });

  final ColorScheme colorTheme;
  final Function(BuildContext context) onOpenDialog;
  final String titleButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        onOpenDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: colorTheme.primary.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                titleButton,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
