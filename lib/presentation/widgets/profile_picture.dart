import 'package:flutter/material.dart';
import 'package:parousia/util/util.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.onPressed,
    this.image,
    this.name,
    this.radius,
    this.loadingValue = 1,
    this.icon = Icons.person,
  });

  final VoidCallback? onPressed;
  final ImageProvider? image;
  final String? name;
  final double? radius;
  final double? loadingValue;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameInitials = getNameInitials(name);
    final padding = radius != null ? radius! / 12.0 : 1.0;

    return ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(shape: CircleBorder()),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.3),
            foregroundImage: image,
            child: nameInitials != null && nameInitials.isNotEmpty
                ? Text(nameInitials)
                : Icon(icon, size: radius, color: theme.colorScheme.primary),
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              strokeWidth: padding,
              value: loadingValue,
            ),
          ),
        ],
      ),
    );
  }
}
