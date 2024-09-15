import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(this.text, {this.style, Key? key}) : super(key: key);

  final String text;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
            package: 'multi_packages_example_theme',
            fontFamily: 'Roboto',
          ) ??
          const TextStyle(
            package: 'multi_packages_example_theme',
            fontFamily: 'Roboto',
          ),
    );
  }
}
