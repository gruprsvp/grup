import 'package:material_ui/material_ui.dart';

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
          ?text,
          if (image != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUri!),
                    colorFilter: theme.brightness == Brightness.dark
                        ? _invertLightness
                        : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Swaps light and dark but keeps hues: the line art turns light for the dark
/// theme and the brand navy stays blue (a plain invert makes it orange).
/// An invert followed by a 180° hue rotation.
const _invertLightness = ColorFilter.matrix([
  0.574, -1.43, -0.144, 0, 255, //
  -0.426, -0.43, -0.144, 0, 255, //
  -0.426, -1.43, 0.856, 0, 255, //
  0, 0, 0, 1, 0, //
]);
