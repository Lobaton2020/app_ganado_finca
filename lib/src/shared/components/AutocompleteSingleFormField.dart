import 'dart:async';

import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:flutter/material.dart';

class AutocompleteSingleFormField extends StatefulWidget {
  const AutocompleteSingleFormField({
    Key? key,
    this.labelText = 'Selecciona la madre',
    required this.onSelected,
    required this.options,
  }) : super(key: key);
  final List<IOption> options;
  final String labelText;
  final void Function(IOption) onSelected;
  @override
  State<AutocompleteSingleFormField> createState() =>
      _AutocompleteSingleFormFieldState();
}

class _AutocompleteSingleFormFieldState
    extends State<AutocompleteSingleFormField> {
  void handleSelected(IOption selection) {
    widget.onSelected(selection);
  }

  FutureOr<Iterable<IOption>> handleOptionsBuilder(
      TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return widget.options;
    }
    return widget.options.where((IOption option) {
      return option.toString().contains(textEditingValue.text.toLowerCase());
    });
  }

  Widget build(BuildContext context) {
    return Autocomplete<IOption>(
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      },
      displayStringForOption: (IOption option) => option.label,
      optionsBuilder: handleOptionsBuilder,
      onSelected: handleSelected,
    );
  }
}
