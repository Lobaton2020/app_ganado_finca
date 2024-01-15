import 'package:flutter/material.dart';

String formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

class DateFormField extends StatefulWidget {
  const DateFormField({
    Key? key,
    required this.initialDate,
    this.onSaved,
    this.validator,
    this.labelText = 'Fecha',
    this.hintText = 'dd/mm/yyyy',
  }) : super(key: key);

  final String labelText;
  final String hintText;
  final DateTime initialDate;
  final ValueChanged<String?>? onSaved;
  final String? Function(String?)? validator;

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  late DateTime _date;
  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final date = _date != widget.initialDate ? formatDateTime(_date) : '';
    return TextFormField(
      controller: TextEditingController(text: date),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: widget.labelText,
        hintText: widget.hintText
      ),
      onTap: () => _showDatePicker(),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    ).then((date) {
      if (date != null) {
        setState(() {
          _date = date;
        });
      }
    });
  }
}
