import 'package:flutter/material.dart';

class LogLetter extends StatelessWidget {
  const LogLetter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Pro',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: 'Dental',
                style: TextStyle(
                  color: Color(0xff05B086),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            style: TextStyle(fontFamily: 'sora-smi', fontSize: 25),
          ),
        ),
      ],
    );
  }
}
