import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String? text;
  final String? image;

  const EmptyState({super.key, this.text, this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (text != null)
            Text(
              text!,
              style: theme.textTheme.bodyLarge,
            ),
          if (image != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image!),
                    invertColors: theme.brightness == Brightness.dark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
