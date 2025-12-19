// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:parousia/presentation/widgets/group_form.stories.dart'
    as _parousia_presentation_widgets_group_form_stories;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'presentation',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'widgets',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GroupForm',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'empty',
                builder: _parousia_presentation_widgets_group_form_stories
                    .emptyUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'with data',
                builder: _parousia_presentation_widgets_group_form_stories
                    .withDataUseCase,
              ),
            ],
          )
        ],
      )
    ],
  )
];
