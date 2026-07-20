import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderIcon extends StatefulWidget {
  const LoaderIcon({super.key});

  @override
  State<LoaderIcon> createState() => _LoaderIconState();
}

class _LoaderIconState extends State<LoaderIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 150,
        child: LottieBuilder.asset(
          "assets/lottie/dental-load.json",
          fit: BoxFit.cover,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration =
                  composition.duration ~/
                  4 // 2x más rápida
              ..repeat();
          },
        ),
      ),
    );
  }
}
