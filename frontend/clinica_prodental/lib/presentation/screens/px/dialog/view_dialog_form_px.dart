import 'package:clinica_prodental/presentation/screens/px/dialog/content/content_dialog_px.dart';
import 'package:flutter/material.dart';

class ViewDialogFormPx {
  static void showDialogFormPx(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialogPx();
      },
    );
  }
}
