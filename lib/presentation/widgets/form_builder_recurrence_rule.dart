import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

class FormBuilderRecurrenceRule
    extends FormBuilderFieldDecoration<RecurrenceRule> {
  /// To localize the recurrence rule picker, supply a [RruleL10n] implementation
  final RruleL10n rruleL10n;

  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<RecurrenceRule?>? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  /// Preset the widget's value.
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;

  final bool showCursor;

  final int? minLines;

  final bool expands;

  final TextInputAction? textInputAction;

  final VoidCallback? onEditingComplete;

  final InputCounterWidgetBuilder? buildCounter;
  final MouseCursor? mouseCursor;

  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  final double cursorWidth;
  final TextCapitalization textCapitalization;

  FormBuilderRecurrenceRule({
    super.key,
    required super.name,
    required this.rruleL10n,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.decoration,
    super.enabled,
    super.focusNode,
    super.initialValue,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    super.valueTransformer,
    this.autocorrect = true,
    this.autofocus = false,
    this.buildCounter,
    this.controller,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.enableInteractiveSelection = true,
    this.expands = false,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.maxLines = 1,
    this.minLines,
    this.mouseCursor,
    this.obscureText = false,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.showCursor = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
  }) : super(builder: (FormFieldState<RecurrenceRule?> field) {
          final state = field as _RecurrenceRulePickerState;

          return TextField(
            autocorrect: autocorrect,
            autofocus: autofocus,
            buildCounter: buildCounter,
            controller: state._textFieldController,
            cursorColor: cursorColor,
            cursorRadius: cursorRadius,
            cursorWidth: cursorWidth,
            decoration: state.decoration,
            enableInteractiveSelection: enableInteractiveSelection,
            enabled: state.enabled,
            expands: expands,
            focusNode: state.effectiveFocusNode,
            inputFormatters: inputFormatters,
            keyboardAppearance: keyboardAppearance,
            keyboardType: keyboardType,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            mouseCursor: mouseCursor,
            obscureText: obscureText,
            onEditingComplete: onEditingComplete,
            readOnly: true,
            scrollPadding: scrollPadding,
            showCursor: showCursor,
            style: style,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textCapitalization: textCapitalization,
            textDirection: textDirection,
            textInputAction: textInputAction,
          );
        });

  @override
  FormBuilderFieldDecorationState<FormBuilderRecurrenceRule, RecurrenceRule>
      createState() => _RecurrenceRulePickerState();
}

class _RecurrenceRulePickerState extends FormBuilderFieldDecorationState<
    FormBuilderRecurrenceRule, RecurrenceRule> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    final initVal = value;
    _textFieldController.text =
        initVal == null ? '' : initVal.toText(l10n: widget.rruleL10n);
    effectiveFocusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocus);
    // Dispose the _textFieldController when initState created it
    if (null == widget.controller) {
      _textFieldController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleFocus() async {
    if (effectiveFocusNode.hasFocus && enabled) {
      effectiveFocusNode.unfocus();
      await onShowSelector(context, value);
    }
  }

  Future<RecurrenceRule?> onShowSelector(
      BuildContext context, RecurrenceRule? currentValue) async {
    final newValue = await showAdaptiveDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return SimpleDialog(
          title: Text(l10n.recurrenceRule),
          children: [
            (CommonRecurrenceRules.daily, Icons.today),
            (CommonRecurrenceRules.weekly, Icons.date_range),
            (CommonRecurrenceRules.monthly, Icons.calendar_month),
            (CommonRecurrenceRules.yearly, Icons.cake),
            (CommonRecurrenceRules.weekdays, Icons.work),
            (CommonRecurrenceRules.weekends, Icons.beach_access),
          ]
              .map<ListTile>(
                (r) => ListTile(
                  leading: Icon(r.$2),
                  title: Text(r.$1.toText(l10n: widget.rruleL10n)),
                  onTap: () => Navigator.pop(context, r.$1),
                ),
              )
              .toList(growable: false),
          // TODO: custom recurrence rule
        );
      },
    );

    if (!mounted) return null;
    final finalValue = newValue ?? currentValue;
    didChange(finalValue);
    return finalValue;
  }

  @override
  void didChange(RecurrenceRule? value) {
    super.didChange(value);
    _textFieldController.text =
        (value == null) ? '' : value.toText(l10n: widget.rruleL10n);
  }
}
