import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MessageEmptyData extends StatelessWidget {
  final double widthLottie;
  final String message;
  final ColorScheme color;
  const MessageEmptyData({
    super.key,
    required this.widthLottie,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widthLottie,
          child: LottieBuilder.asset("assets/lottie/not-found.json"),
        ),

        SizedBox(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.onSecondary.withValues(alpha: .6),
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
