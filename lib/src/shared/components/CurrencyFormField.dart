import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormField extends StatefulWidget {
  const CurrencyFormField({
    Key? key,
    this.onSaved,
    this.labelText = 'Monto de compra o avaluación',
    this.isRequired = false,
  }) : super(key: key);
  final String labelText;
  final bool isRequired;
  final ValueChanged<String?>? onSaved;
  @override
  State<CurrencyFormField> createState() => _CurrencyFormFieldState();
}

class _CurrencyFormFieldState extends State<CurrencyFormField> {
  final _subscriptionPriceController = TextEditingController();
  final NumberFormat numFormat = NumberFormat('###,##0', 'en_US');
  final NumberFormat numSanitizedFormat = NumberFormat('en_US');
  var currency = 'USD';

  @override
  void initState() {
    super.initState();
    _subscriptionPriceController.text = '';
  }

  void formatInput(_) {
    String formattedPrice = numFormat
        .format(double.parse("${_subscriptionPriceController.value.text}"));
    _subscriptionPriceController.value = TextEditingValue(
      text: formattedPrice,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.labelText,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (widget.isRequired) {
              return 'Este campo es requerido';
            }
            return null;
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onSaved: (value) {
          var numSanitized =
              numSanitizedFormat.parse(value! == "" ? '0.0' : value);
          _subscriptionPriceController.value = TextEditingValue(
            text: numSanitized.toString(),
            selection: TextSelection.collapsed(offset: '$numSanitized'.length),
          );
          widget.onSaved!(
              numSanitized.toString() == "0" ? "" : numSanitized.toString());
        },
        controller: _subscriptionPriceController..text = '',
        onTap: () {
          var textFieldNum = _subscriptionPriceController.text;
          var numSanitized = numSanitizedFormat.parse(textFieldNum);
          _subscriptionPriceController.value = TextEditingValue(
            text: numSanitized == 0 ? '' : '$numSanitized',
            selection: TextSelection.collapsed(offset: '$numSanitized'.length),
          );
        },
        onFieldSubmitted: formatInput);
  }
}
