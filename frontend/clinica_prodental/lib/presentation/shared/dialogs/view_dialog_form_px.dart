import 'package:clinica_prodental/presentation/screens/citas/dialog/content_dialog_cita.dart';
import 'package:clinica_prodental/presentation/screens/px/dialog/content/content_dialog_px.dart';
import 'package:flutter/material.dart';

class ViewDialogForm {
  static void showDialogFormPx(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialogPx();
      },
    );
  }

  static void showDialogFormCitas(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialogCita(); 
      },
    );
  }
}
