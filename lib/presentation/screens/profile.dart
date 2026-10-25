import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

/// Saves the profile, and says whether that worked.
typedef OnProfileSaveCallback = Future<bool> Function(
  String name,
  XFile? image,
);

class ProfileScreen extends StatefulWidget {
  final Profile? profile;
  final bool? userNavigated;
  final bool saving;
  final OnProfileSaveCallback onSave;

  const ProfileScreen({
    super.key,
    this.profile,
    this.userNavigated,
    this.saving = false,
    required this.onSave,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sign in with Apple sends the name after the profile first loads.
    final name = widget.profile?.displayName;
    if (name != null && _nameController.text.isEmpty) {
      _nameController.text = name;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _nameFocusNode.unfocus();
    setState(() => _enableSaveButton = false);

    final saved = await widget.onSave(
      _nameController.text.trim(),
      _imageController.value,
    );
    if (!mounted) return;
    if (!saved) {
      setState(() => _enableSaveButton = true);
    } else if (!(widget.userNavigated ?? false)) {
      // Asked for the name on first sign-in: go back to where they were.
      Navigator.of(context).pop();
    }
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
            onPressed: () => const SettingsRoute().push<void>(context),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
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
                    spacing: 16,
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
                        autofillHints: const [AutofillHints.name],
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: l10n.enterYourName,
                          helperText: l10n.profileNameHelper,
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
                  onPressed: _enableSaveButton && !widget.saving ? _save : null,
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
