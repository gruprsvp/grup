import 'package:flutter/material.dart';
import 'package:parousia/util/util.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'group_form.dart';

@widgetbook.UseCase(
  type: GroupForm,
  name: 'with data',
)
Widget withDataUseCase(BuildContext context) {
  return GroupForm(onSave: (_) {}, group: Fake.group());
}

@widgetbook.UseCase(
  type: GroupForm,
  name: 'empty',
)
Widget emptyUseCase(BuildContext context) {
  return GroupForm(onSave: (_) {});
}
