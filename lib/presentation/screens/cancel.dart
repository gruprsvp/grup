import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/presentation/view_models/cancel.dart';

/// Cancelling plans, or withdrawing from one, by the paying account's email
/// address. The button labels are the statutory ones (§ 312k and § 356a
/// BGB, EU Directive 2011/83 Art. 11a): keep them when changing the copy.
class CancelScreen extends StatefulWidget {
  const CancelScreen({
    super.key,
    this.email,
    this.paidGroups = const {},
    required this.sending,
    required this.sent,
    required this.onSubmit,
  });

  /// Filled in when signed in.
  final String? email;

  /// The groups whose plan the signed-in user pays for, by id.
  final Map<String, String> paidGroups;

  final bool sending;

  /// The request went through: the page only says so.
  final bool sent;

  final ValueChanged<CancellationRequest> onSubmit;

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.email);
  final _name = TextEditingController();

  /// `cancel` or `withdraw`, once chosen.
  String? _action;
  String? _groupId;

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit((
      action: _action!,
      email: _email.text.trim(),
      groupId: _groupId,
      name: _action == 'withdraw' ? _name.text.trim() : null,
      language: Localizations.localeOf(context).languageCode,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final withdraw = _action == 'withdraw';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cancelPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: widget.sent
              ? Text(l10n.cancelSent, style: textTheme.titleMedium)
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      Text(l10n.cancelPageIntro),
                      if (_action == null) ...[
                        FilledButton(
                          onPressed: () => setState(() => _action = 'cancel'),
                          child: Text(l10n.cancelEntry),
                        ),
                        FilledButton.tonal(
                          onPressed: () => setState(() => _action = 'withdraw'),
                          child: Text(l10n.withdrawEntry),
                        ),
                      ] else ...[
                        Text(
                          withdraw ? l10n.withdrawEntry : l10n.cancelEntry,
                          style: textTheme.titleMedium,
                        ),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.cancelEmailLabel,
                          ),
                          validator: (value) =>
                              RegExp(r'^\S+@\S+\.\S+$')
                                  .hasMatch(value?.trim() ?? '')
                              ? null
                              : l10n.cancelEmailInvalid,
                        ),
                        if (widget.paidGroups.isNotEmpty)
                          DropdownButtonFormField<String?>(
                            initialValue: _groupId,
                            decoration: InputDecoration(
                              labelText: l10n.cancelPlanLabel,
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text(l10n.cancelAllPlans),
                              ),
                              for (final MapEntry(key: id, value: name)
                                  in widget.paidGroups.entries)
                                DropdownMenuItem(value: id, child: Text(name)),
                            ],
                            onChanged: (id) => setState(() => _groupId = id),
                          ),
                        if (withdraw)
                          TextFormField(
                            controller: _name,
                            autofillHints: const [AutofillHints.name],
                            decoration: InputDecoration(
                              labelText: l10n.withdrawNameLabel,
                            ),
                            validator: (value) =>
                                (value?.trim().isEmpty ?? true)
                                ? l10n.withdrawNameMissing
                                : null,
                          ),
                        Text(
                          withdraw ? l10n.withdrawEffect : l10n.cancelEffect,
                        ),
                        FilledButton(
                          onPressed: widget.sending ? null : _submit,
                          child: Text(
                            withdraw
                                ? l10n.withdrawConfirm
                                : l10n.cancelConfirm,
                          ),
                        ),
                        TextButton(
                          onPressed: widget.sending
                              ? null
                              : () => setState(() => _action = null),
                          child: Text(
                            MaterialLocalizations.of(context).backButtonTooltip,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
