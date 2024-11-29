import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CreateContactsScreen extends StatefulWidget {
  const CreateContactsScreen({super.key});

  @override
  State<CreateContactsScreen> createState() => _CreateContactsScreenState();
}

class _CreateContactsScreenState extends State<CreateContactsScreen> {
  bool _showSaveButton = false;
  ContactInvite? _contactInvite;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addContact)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ContactForm(
          onChanged: (contactInvite, isValid) {
            setState(() {
              _showSaveButton = isValid;
            });
            _contactInvite = contactInvite;
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showSaveButton
          ? FloatingActionButton.extended(
              onPressed: () => context.pop([_contactInvite!]),
              label: Text(l10n.save),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}

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
              validator: PhoneValidator.valid(context),decoration: InputDecoration(
                labelText: l10n.contactPhone,
              ),
            )
        ],
      ),
    );
  }
}
