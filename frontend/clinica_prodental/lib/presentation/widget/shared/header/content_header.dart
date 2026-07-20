import 'package:flutter/material.dart';

class ContentHeader extends StatelessWidget {
  final String title;
  const ContentHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [TitleHeaderPage(colorTheme: colorTheme, title: title)],
    );
  }
}

class TitleHeaderPage extends StatelessWidget {
  const TitleHeaderPage({
    super.key,
    required this.colorTheme,
    required this.title,
  });

  final ColorScheme colorTheme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: colorTheme.onSecondary,
            ),
          ),
          TextSpan(
            text: '\n', // Salto de línea entre spans
          ),
          TextSpan(
            text:
                'Gestiona y consulta la información de tus ${title.toLowerCase()}',
            style: TextStyle(
              color: colorTheme.onSecondary.withValues(alpha: .5),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
