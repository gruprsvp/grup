import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:phone_form_field/phone_form_field.dart';

class ContactForm extends StatefulWidget {
  const ContactForm(
      {super.key,
      this.onChanged,
      this.showEmail = true,
      this.showPhone = true});

  final Function(ContactInvite, bool)? onChanged;
  final bool showEmail;
  final bool showPhone;

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
        final name = _nameController.text.trim();
        final email = _emailController.text.trim();
        final phone = _phoneController.value.international;

        // Only consider phone if it was provided and is different from the initial value
        final phoneWasProvided = widget.showPhone &&
            phone.isNotEmpty &&
            _phoneController.value.isValid();

        final invites = [
          if (email.isNotEmpty) (InviteMethods.email, email),
          if (phoneWasProvided) (InviteMethods.phone, phone),
        ];

        final formIsValid = _formKey.currentState?.validate() ?? false;
        final onlyNameRequired = !widget.showEmail && !widget.showPhone;
        final emailIsValid = widget.showEmail && email.isNotEmpty;
        final phoneIsValid = widget.showPhone && phoneWasProvided;
        final isValid =
            formIsValid && (onlyNameRequired || emailIsValid || phoneIsValid);

        widget.onChanged?.call(
            ContactInvite(displayNameOverride: name, invites: invites),
            isValid);
      },
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            controller: _nameController,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              labelText: l10n.contactName,
            ),
            textInputAction: widget.showPhone || widget.showEmail
                ? TextInputAction.next
                : TextInputAction.done,
          ),
          if (widget.showEmail)
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.email(),
              decoration: InputDecoration(
                labelText: l10n.contactEmail,
              ),
              textInputAction: widget.showPhone
                  ? TextInputAction.next
                  : TextInputAction.done,
            ),
          if (widget.showPhone)
            PhoneFormField(
              controller: _phoneController,
              validator: PhoneValidator.valid(context),
              decoration: InputDecoration(
                labelText: l10n.contactPhone,
              ),
              textInputAction: TextInputAction.done,
            )
        ],
      ),
    );
  }
}
