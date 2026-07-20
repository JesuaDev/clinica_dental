import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:clinica_prodental/presentation/shared/shared.dart';
import 'package:lottie/lottie.dart';

class Toats extends StatefulWidget {
  final String message;
  final TypeAnimation typeAnimation;
  const Toats({super.key, required this.message, required this.typeAnimation});

  @override
  State<Toats> createState() => _ToatsState();
}

class _ToatsState extends State<Toats> {
  late Timer? _timer;
  int currentTime = 5;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime > 0) {
          currentTime--;
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    final String animation = widget.typeAnimation == TypeAnimation.succes
        ? 'assets/lottie/success-animation.json'
        : widget.typeAnimation == TypeAnimation.warning
        ? 'assets/lottie/warning-animation.json'
        : 'assets/lottie/error-animation.json';

    return currentTime > 0
        ? FadeInRight(
            duration: const Duration(milliseconds: 500),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: theme.secondary.withValues(alpha: .3)),
                ],
                color: theme.secondary,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: LottieBuilder.asset(animation),
                  ),
                  Text(widget.message, style: TextStyle(letterSpacing: 1)),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
