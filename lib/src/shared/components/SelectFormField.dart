import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:flutter/material.dart';

class SelectFormField extends StatefulWidget {
  const SelectFormField({
    Key? key,
    this.onSaved,
    this.validator,
    this.labelText = 'Select',
    required this.options,
  }) : super(key: key);
  final List<IOption> options;
  final String labelText;
  final ValueChanged<String?>? onSaved;
  final String? Function(String?)? validator;
  @override
  State<SelectFormField> createState() => _SelectFormFieldState();
}

class _SelectFormFieldState extends State<SelectFormField> {
  String? _selectedOption;
  void handleChange(String? newOption) {
    setState(() {
      _selectedOption = newOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: widget.validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: widget.labelText,
      ),
      // value: _selectedOption,
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
