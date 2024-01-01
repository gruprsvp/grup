import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupJoin extends StatefulWidget {
  final ValueSetter<String> onJoin;

  const GroupJoin({
    super.key,
    required this.onJoin,
  });

  @override
  createState() => _GroupJoinState();
}

class _GroupJoinState extends State<GroupJoin> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
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
                  FormBuilderTextField(
                    name: 'code',
                    valueTransformer: (value) => value?.toUpperCase(),
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: l10n.enterInviteCode,
                      suffixIcon: const Icon(Icons.confirmation_num_outlined),
                      hintText: 'ABCD-1234',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterInviteCodePlease;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onJoin(_codeController.text);
                }
              },
              child: Text(l10n.joinGroup),
            ),
          ),
        ],
      ),
    );
  }
}
