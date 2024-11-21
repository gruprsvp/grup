import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';

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
          onChanged: (contactInvite) {
            setState(() {
              _showSaveButton = true;
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
  const ContactForm({super.key, this.onChanged});

  final Function(ContactInvite)? onChanged;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FormBuilder(
      key: _formKey,
      onChanged: () {
        if (_formKey.currentState?.validate(focusOnInvalid: false) ?? false) {
          final name = _nameController.text.trim();
          final email = _emailController.text.trim();
          final phone = _phoneController.text.trim();

          widget.onChanged?.call(ContactInvite(
            displayNameOverride: name,
            invites: [
              ...(email.isNotEmpty ? [(InviteMethods.email, email)] : []),
              ...(phone.isNotEmpty ? [(InviteMethods.phone, phone)] : []),
            ],
          ));
        }
      },
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            controller: _nameController,
            autocorrect: true,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              labelText: l10n.contactName,
            ),
          ),
          FormBuilderTextField(
            name: 'email',
            controller: _emailController,
            autocorrect: true,
            validator: FormBuilderValidators.email(checkNullOrEmpty: false),
            decoration: InputDecoration(
              labelText: l10n.contactEmail,
            ),
          ),
          FormBuilderPhoneField(
            name: 'phone',
            controller: _phoneController,
            autocorrect: true,
            decoration: InputDecoration(
              labelText: l10n.contactPhone,
            ),
          ),
        ],
      ),
    );
  }
}
