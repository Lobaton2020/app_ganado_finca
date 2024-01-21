import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/shared/components/SelectFormField.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:app_ganado_finca/src/shared/utils/snackBartMessage.dart';
import 'package:flutter/material.dart';

class FormCreateOutputBovine extends StatefulWidget {
  final int bovine_id;
  const FormCreateOutputBovine({super.key, required this.bovine_id});

  @override
  State<FormCreateOutputBovine> createState() {
    return _FormCreateOutputBovineFormState();
  }
}

class _FormCreateOutputBovineFormState extends State<FormCreateOutputBovine> {
  final _form = GlobalKey<FormState>();
  final newOutputBovine = Map<String, dynamic>();
  bool isLoading = false;
  bool mustShowAmount = false;

  String? _validationEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  void _onSubmitForm() async {
    if (_form.currentState!.validate()) {
      setState(() => isLoading = true);
      _form.currentState!.save();
      newOutputBovine["was_sold"] = newOutputBovine["was_sold"] == "1";
      newOutputBovine["bovine_id"] = widget.bovine_id;
      if (newOutputBovine["was_sold"]) {
        newOutputBovine["sold_amount"] =
            num.parse("${newOutputBovine["sold_amount"]}");
      } else {
        newOutputBovine.remove("sold_amount");
      }
      try {
        await bovineOutputService
            .create(BovineOutput.fromJson(newOutputBovine));
        showSnackBar(context, "Se creó la salida!");
        _form.currentState!.reset();
        setState(() => isLoading = false);
        Navigator.pop(context);
        tabObserver.add(AppTabs.bovines.index);
      } catch (err) {
        print(err);
        setState(() => isLoading = false);
        showSnackBar(context, "F: $err");
      }
    }
  }

  void _onChangeTipoSalida(String? was_sold) {
    setState(() {
      mustShowAmount = was_sold == "1";
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                onChange: _onChangeTipoSalida,
                validator: _validationEmpty,
                labelText: "Tipo Salida ",
                onSaved: (value) => {newOutputBovine["was_sold"] = value ?? ''},
                options: [
                  IOption(label: "Venta", value: "1"),
                  IOption(label: "Fallecimiento", value: "0")
                ]),
          ),
          mustShowAmount
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Monto de venta',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      if (num.tryParse(value) == null) {
                        return 'Este campo debe ser numerico';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        {newOutputBovine["sold_amount"] = value ?? ''},
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descripción (Opcional)',
              ),
              onSaved: (value) =>
                  {newOutputBovine["description"] = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onSubmitForm,
                    child: isLoading
                        ? Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: CircularProgressIndicator(strokeWidth: 4.0))
                        : Text('Enviar información'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
