import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:parousia/presentation/presentation.dart';

class CreateContactsScreen extends StatefulWidget {
  const CreateContactsScreen({super.key});

  @override
  State<CreateContactsScreen> createState() => _CreateContactsScreenState();
}

class _CreateContactsScreenState extends State<CreateContactsScreen> {
  final List<ContactInvite> selectedContacts = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.selectContacts),
          actions: [
            Badge(
              label: Text(selectedContacts.length.toString()),
              isLabelVisible: selectedContacts.length > 1,
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: selectedContacts.isNotEmpty
                    ? () async {
                        if (!context.mounted) {
                          // TODO: how can we avoid this?
                          return;
                        }
                        // TODO maybe add a confirmation dialog?
                        Navigator.pop(context, selectedContacts);
                      }
                    : null,
                icon: const Icon(Icons.group_add),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(child: ContactForm()));
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            controller: _nameController,
            autocorrect: true,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              labelText: 'Name', // l10n.contactName,
            ),
          ),
          FormBuilderTextField(
            name: 'email',
            controller: _emailController,
            autocorrect: true,
            validator: FormBuilderValidators.email(),
            decoration: InputDecoration(
              labelText: 'Email', // l10n.contactEmail,
            ),
          ),
          FormBuilderPhoneField(
            name: 'phone',
            controller: _phoneController,
            autocorrect: true,
            decoration: InputDecoration(
              labelText: 'Phone', // l10n.contactPhone,
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (_formKey.currentState?.validate() ?? false) {
          //       final contact = ContactInvite(
          //         name: _nameController.text,
          //         email: _emailController.text,
          //         phone: _phoneController.text,
          //       );
          //       Navigator.pop(context, contact);
          //     }
          //   },
          //   child: Text(l10n.save),
          // ),
        ],
      ),
    );
  }
}
