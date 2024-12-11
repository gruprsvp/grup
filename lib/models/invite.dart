import 'package:flutter/foundation.dart'; // ignore: unused_import

import 'enum.dart';

/// A contact to invite to a group.
class ContactInvite {
  final String? displayNameOverride;
  final List<(InviteMethods, String)> invites;

  const ContactInvite(
      {required this.displayNameOverride, required this.invites});
}
