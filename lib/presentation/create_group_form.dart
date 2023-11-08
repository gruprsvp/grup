import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnCreateGroupCallback = void Function(String displayName);

class CreateGroupForm extends StatefulWidget {
  final bool creationInProgress;
  final OnCreateGroupCallback onCreateGroup;

  const CreateGroupForm({
    super.key,
    required this.creationInProgress,
    required this.onCreateGroup,
  });

  @override
  createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // TODO: implement build
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              enabled: !widget.creationInProgress,
              focusNode: _nameFocusNode,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.enterGroupName,
                suffixIcon: const Icon(Icons.mood),
              ),
              maxLength: 32,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterGroupNamePlease;
                }
                return null;
              },
            ),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              maxLength: 256,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.description_outlined),
                hintText: l10n.enterGroupDescription,
                border: const OutlineInputBorder(),
              ),
            ),
            FilledButton(
              onPressed: widget.creationInProgress
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _nameFocusNode.unfocus();
                        widget.onCreateGroup(_nameController.text.trim());
                      }
                    },
              child: Text(l10n.createNewGroup),
            ),
          ],
        ),
      ),
    );
  }
}
