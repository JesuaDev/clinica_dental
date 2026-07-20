import 'package:clinica_prodental/presentation/shared/enums/view/enum_type_animation.dart';
import 'package:clinica_prodental/presentation/widget/shared/notifications/dialog_box.dart';
import 'package:flutter/material.dart';

class ViewDialog {
  static void viewDialog(
    BuildContext context,
    String title,
    String? message,
    TypeAnimation typeAnimation,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title: title,
          message: message,
          typeAnimation: typeAnimation,
        );
      },
    );
  }
}
