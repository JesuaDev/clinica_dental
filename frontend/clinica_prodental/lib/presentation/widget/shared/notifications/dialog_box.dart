import 'package:clinica_prodental/presentation/shared/enums/view/enum_type_animation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

class DialogBox extends StatefulWidget {
  final String title;
  final String? message;
  final icon;
  final TypeAnimation typeAnimation;

  const DialogBox({
    super.key,
    required this.title,
    this.message,
    this.icon,
    required this.typeAnimation,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    final String animation = widget.typeAnimation == TypeAnimation.succes
        ? 'assets/lottie/success-animation.json'
        : widget.typeAnimation == TypeAnimation.warning
        ? 'assets/lottie/warning-animation.json'
        : 'assets/lottie/error-animation.json';

    return AlertDialog(
      title: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: LottieBuilder.asset(animation),
          ),
          SizedBox(height: 20),
          Text(
            widget.title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        width: 400,
        padding: EdgeInsets.symmetric(horizontal: 30),

        child: Text(
          widget.message ?? ' ',
          style: TextStyle(fontFamily: 'sora-light', fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),

      actions: [
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.typeAnimation == TypeAnimation.succes
                  ? Colors.green
                  : widget.typeAnimation == TypeAnimation.warning
                  ? Colors.amber
                  : Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Está bien, gracias",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),

                  SizedBox(width: 10),

                  HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkBadge01),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
