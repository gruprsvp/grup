import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

typedef OnProfileSaveCallback = void Function(String? name, XFile? image);

class ProfileScreen extends StatefulWidget {
  final Profile? profile;
  final OnProfileSaveCallback onSave;

  const ProfileScreen({super.key, this.profile, required this.onSave});

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();

  late TextEditingController _nameController;

  bool _showSaveButton = false;
  XFile? _tempImageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.displayName);
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  ImageProvider? _profilePicture() {
    if (_tempImageFile != null) {
      if (kIsWeb) {
        return NetworkImage(_tempImageFile!.path);
      } else {
        return FileImage(File(_tempImageFile!.path));
      }
    } else if (widget.profile?.picture != null) {
      return NetworkImage(widget.profile!.picture!);
    }
    return null;
  }

  // TODO: move to a widget and make it reusable
  _changeImage() async {
    final source = await showAdaptiveDialog<ImageSource>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return SimpleDialog(
          title: Text(l10n.chooseNewProfilePicture),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt),
                  const SizedBox(width: 8),
                  Text(l10n.camera),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: Row(
                children: [
                  const Icon(Icons.photo_library),
                  const SizedBox(width: 8),
                  Text(l10n.gallery),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (source != null) {
      _pickImageTemp(source);
    }
  }

  Future<void> _pickImageTemp(ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 512,
      maxHeight: 512,
      requestFullMetadata: false,
    );
    if (imageFile == null) {
      return;
    }

    setState(() {
      _tempImageFile = imageFile;
      _showSaveButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profilePicture = _profilePicture();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProfilePicture(
                onPressed: () => _changeImage(),
                image: profilePicture,
                name: _nameController.value.text,
                radius: 64,
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
                onChanged: (value) {
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      _showSaveButton = true;
                    } else {
                      _showSaveButton = false;
                    }
                  });
                },
              ),
              // TODO(borgoat): options to link additional auth providers
            ],
          ),
        ),
      ),
      floatingActionButton: _showSaveButton
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _showSaveButton = false;
                  });
                  _formKey.currentState!.save();
                  _nameFocusNode.unfocus();
                  widget.onSave(_nameController.text.trim(), _tempImageFile);
                }
              },
              label: Text(l10n.save),
              icon: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
