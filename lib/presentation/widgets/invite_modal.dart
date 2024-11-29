import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum InviteOptions { email, phone, contacts, guest }

class InviteModal extends StatelessWidget {
  final ValueChanged<InviteOptions>? onOptionSelected;

  const InviteModal({
    super.key,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.invite,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOption(
                  context,
                  icon: Icons.email,
                  label: l10n.contactEmail,
                  option: InviteOptions.email,
                ),
                _buildOption(
                  context,
                  icon: Icons.phone,
                  label: l10n.contactPhone,
                  option: InviteOptions.phone,
                ),
                if (!kIsWeb)
                  _buildOption(
                    context,
                    icon: Icons.contacts,
                    label: l10n.contacts,
                    option: InviteOptions.contacts,
                  ),
                _buildOption(
                  context,
                  icon: Icons.person_outline,
                  label: l10n.guest,
                  option: InviteOptions.guest,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required InviteOptions option,
  }) =>
      GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Close the modal
          onOptionSelected?.call(option); // Notify the selection
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
}
