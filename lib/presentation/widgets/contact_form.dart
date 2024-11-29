import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:parousia/models/models.dart';
import 'package:phone_form_field/phone_form_field.dart';

class ContactForm extends StatefulWidget {
  const ContactForm(
      {super.key,
      this.onChanged,
      this.showEmail = true,
      this.showPhone = true});

  final Function(ContactInvite, bool)? onChanged;
  final dynamic showEmail;
  final dynamic showPhone;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = PhoneController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        final isValid = _formKey.currentState?.validate() ?? false;
        final name = _nameController.text.trim();
        final email = _emailController.text.trim();
        final phone = _phoneController.value.international;

        widget.onChanged?.call(
            ContactInvite(
              displayNameOverride: name,
              invites: [
                if (email.isNotEmpty) (InviteMethods.email, email),
                if (phone.isNotEmpty) (InviteMethods.phone, phone),
              ],
            ),
            isValid);
      },
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              labelText: l10n.contactName,
            ),
          ),
          if (widget.showEmail)
            TextFormField(
              controller: _emailController,
              validator: FormBuilderValidators.email(),
              decoration: InputDecoration(
                labelText: l10n.contactEmail,
              ),
            ),
          if (widget.showPhone)
            PhoneFormField(
              controller: _phoneController,
              validator: PhoneValidator.valid(context),
              decoration: InputDecoration(
                labelText: l10n.contactPhone,
              ),
            )
        ],
      ),
    );
  }
}
