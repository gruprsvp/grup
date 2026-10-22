import 'package:material_ui/material_ui.dart';
import 'package:parousia/util/util.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.onPressed,
    this.image,
    this.name,
    this.radius,
    this.loadingValue = 1,
    this.icon,
    this.color,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final ImageProvider? image;
  final String? name;
  final double? radius;
  final double? loadingValue;
  final IconData? icon;
  final Color? color;

  /// What pressing it does, for screen readers and on hover.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameInitials = getNameInitials(name);
    final padding = radius != null ? radius! / 12.0 : 1.0;
    final color = this.color ?? theme.colorScheme.primary;
    final backgroundColor = HSLColor.fromColor(color)
        .withLightness(0.9)
        .toColor();

    final button = ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(shape: CircleBorder()),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            foregroundImage: image,
            child: nameInitials != null && nameInitials.isNotEmpty
                ? Text(nameInitials)
                : Icon(icon, size: radius, color: color),
          ),
          // A decorative ring: not a progress bar to screen readers.
          Positioned.fill(
            child: ExcludeSemantics(
              child: CircularProgressIndicator(
                strokeWidth: padding,
                value: loadingValue,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
    final tooltip = this.tooltip;
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}
