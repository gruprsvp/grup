import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

typedef OnProfileSaveCallback = ValueSetter<(String? name, XFile? image)>;

class ProfileScreen extends StatefulWidget {
  final Profile? profile;
  final bool? userNavigated;
  final OnProfileSaveCallback onSave;

  const ProfileScreen(
      {super.key, this.profile, this.userNavigated, required this.onSave});

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();

  late ImageController _imageController;
  late TextEditingController _nameController;

  bool _enableSaveButton = false;

  @override
  void initState() {
    super.initState();
    _imageController = ImageController();
    _nameController = TextEditingController(text: widget.profile?.displayName);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _nameFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear),
            tooltip: l10n.settings,
            onPressed: () => SettingsRoute().push(context),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          setState(() {
            if (_formKey.currentState!.validate()) {
              _enableSaveButton = true;
            } else {
              _enableSaveButton = false;
            }
          });
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ImageFormField(
                      controller: _imageController,
                      initialImage: widget.profile?.picture != null
                          ? NetworkImage(widget.profile!.picture!)
                          : null,
                      radius: 64,
                      icon: Icons.person,
                    ),
                    TextFormField(
                      focusNode: _nameFocusNode,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.enterYourName,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enterYourNamePlease;
                        }
                        return null;
                      },
                    ),
                    // TODO(borgoat): options to link additional auth providers
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _enableSaveButton
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _enableSaveButton = false;
                            });
                            _formKey.currentState!.save();
                            _nameFocusNode.unfocus();
                            widget.onSave((
                              _nameController.text.trim(),
                              _imageController.value,
                            ));

                            if (!(widget.userNavigated ?? false)) {
                              Navigator.of(context).pop(context);
                            }
                          }
                        }
                      : null,
                  child: Text(l10n.save),
                )),
          ],
        ),
      ),
    );
  }
}
