import 'package:flutter/material.dart';
import 'package:parousia/util/util.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.onPressed,
    this.image,
    this.name,
    this.radius,
  });

  final void Function()? onPressed;
  final ImageProvider? image;
  final String? name;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameInitials = getNameInitials(name);
    final padding = radius != null ? radius! / 8.0 : 1.0;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(padding),
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: padding,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
        foregroundImage: image,
        child: nameInitials != null && nameInitials.isNotEmpty
            ? Text(
                nameInitials,
                // style: theme.textTheme.headlineLarge,
              )
            : Icon(
                Icons.person,
                size: radius,
                color: theme.colorScheme.primary,
              ),
      ),
    );
  }
}
