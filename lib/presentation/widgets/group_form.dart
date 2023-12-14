import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/models/group.dart';

typedef OnGroupSaveCallback = void Function(Group);

class GroupForm extends StatefulWidget {
  final OnGroupSaveCallback onSave;
  final Group? group;

  const GroupForm({
    super.key,
    required this.onSave,
    this.group,
  });

  @override
  createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.displayName);
    _descriptionController =
        TextEditingController(text: widget.group?.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
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
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 5,
                    maxLength: 256,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    autocorrect: true,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.description_outlined),
                      hintText: l10n.enterGroupDescription,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final displayName = _nameController.text.trim();
                  final description = _descriptionController.text.trim();
                  final picture = null; // TODO

                  _formKey.currentState!.save();
                  widget.onSave(Group(
                    id: widget.group?.id ?? 0,
                    displayName: displayName,
                    description: description.isNotEmpty ? description : null,
                    picture: picture,
                  ));
                }
              },
              child:
                  Text(widget.group != null ? l10n.save : l10n.createNewGroup),
            ),
          ),
        ],
      ),
    );
  }
}
