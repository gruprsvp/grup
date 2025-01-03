import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/group.dart';
import 'package:parousia/presentation/presentation.dart';

typedef OnGroupSaveCallback = ValueSetter<(Group group, XFile? image)>;

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

  late ImageController _imageController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _imageController = ImageController();
    _nameController = TextEditingController(text: widget.group?.displayName);
    _descriptionController =
        TextEditingController(text: widget.group?.description);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListenableBuilder(
                    listenable: _nameController,
                    builder: (context, child) => ImageFormField(
                      radius: 64,
                      icon: Icons.group,
                      color: colorScheme.secondary,
                      controller: _imageController,
                      initialImage: widget.group?.picture != null
                          ? NetworkImage(widget.group!.picture!)
                          : null,
                    ),
                  ),
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
                  final picture = _imageController.value;

                  _formKey.currentState!.save();
                  widget.onSave((
                    Group(
                      id: widget.group?.id ?? '',
                      displayName: displayName,
                      description: description.isNotEmpty ? description : null,
                    ),
                    picture
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
