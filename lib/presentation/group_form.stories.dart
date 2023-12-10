import 'package:flutter/material.dart';
import 'package:parousia/presentation/group_form.dart';
import 'package:parousia/util/util.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  type: GroupForm,
  name: 'with data',
)
Widget withDataUseCase(BuildContext context) {
  return Material(
    child: GroupForm(onSave: (_) {}, group: Fake.group()),
  );
}

@widgetbook.UseCase(
  type: GroupForm,
  name: 'empty',
)
Widget emptyUseCase(BuildContext context) {
  return Material(
    child: GroupForm(onSave: (_) {}),
  );
}
