import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget? text;
  final String? image;

  const EmptyState({super.key, this.text, this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final imageUri = image != null ? 'assets/images/$image' : null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (text != null) text!,
          if (image != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUri!),
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
