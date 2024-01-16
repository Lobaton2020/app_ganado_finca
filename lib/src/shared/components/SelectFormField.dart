import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:flutter/material.dart';

class SelectFormField extends StatefulWidget {
  const SelectFormField({
    Key? key,
    this.onSaved,
    this.onChange,
    this.validator,
    this.labelText = 'Select',
    this.initialValue,
    required this.options,
  }) : super(key: key);
  final List<IOption> options;
  final String labelText;
  final ValueChanged<String?>? onSaved;
  final Function(String?)? onChange;
  final String? Function(String?)? validator;
  final String? initialValue;
  @override
  State<SelectFormField> createState() => _SelectFormFieldState();
}

class _SelectFormFieldState extends State<SelectFormField> {
  void handleChange(String? newOption) {
    if (widget != null && newOption != null) {
      widget.onChange!(newOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.initialValue,
      validator: widget.validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: widget.labelText,
      ),
      onSaved: widget.onSaved,
      onChanged: handleChange,
      items: [
        ...widget.options
            .map((option) => DropdownMenuItem(
                  value: option.value,
                  child: Text(option.label),
                ))
            .toList(),
      ],
    );
  }
}
