import 'package:app_ganado_finca/src/services/main.dart';
import 'package:app_ganado_finca/src/shared/components/DateFormField.dart';
import 'package:app_ganado_finca/src/shared/components/SelectFormField.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/fromDateString.dart';
import 'package:app_ganado_finca/src/shared/utils/snackBartMessage.dart';
import 'package:flutter/material.dart';
import 'package:app_ganado_finca/src/models/Bovine.dart';

class FormCreateBovine extends StatefulWidget {
  const FormCreateBovine({super.key, handleSubmitted});

  @override
  FormCreateBovineFormState createState() {
    return FormCreateBovineFormState();
  }
}

class FormCreateBovineFormState extends State<FormCreateBovine> {
  final _form = GlobalKey<FormState>();
  final newBovine = Map<String, dynamic>();
  List<IOption> ownerOptions = [];
  List<IOption> provenanceOptions = [];

  String? _validationEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  void _onSubmitForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      newBovine["owner_id"] = int.parse(newBovine["owner_id"]);
      newBovine["provenance_id"] = int.parse(newBovine["provenance_id"]);
      newBovine["is_male"] = newBovine["is_male"] == "1";
      newBovine["for_increase"] = newBovine["for_increase"] == "1";
      newBovine["date_birth"] =
          fromDateStringToIsoString(newBovine["date_birth"]);

      try {
        await bovineService.create(Bovine.fromJson(newBovine));
        showSnackBar(context, "Proceso exitoso!");
        _form.currentState!.reset();
      } catch (err) {
        print(err);
        showSnackBar(context, "Error, intenta de nuevo");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      bovineService.findOwners(),
      bovineService.findProvenances(),
    ]).then((values) {
      setState(() {
        ownerOptions = values[0];
        provenanceOptions = values[1];
      });
    }).catchError((error) {
      print("Error consulta owners or procenances: " + error);
    });
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
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre del animal',
              ),
              validator: _validationEmpty,
              onSaved: (value) => {newBovine["name"] = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Color',
              ),
              validator: _validationEmpty,
              onSaved: (value) => {newBovine["color"] = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: DateFormField(
              validator: _validationEmpty,
              initialDate: DateTime.now(),
              labelText: "Fecha de nacimiento",
              onSaved: (value) => {newBovine["date_birth"] = value ?? ''},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                validator: _validationEmpty,
                labelText: "Propietario",
                onSaved: (value) => {newBovine["owner_id"] = value ?? ''},
                options: ownerOptions),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                validator: _validationEmpty,
                labelText: "Sexo",
                onSaved: (value) => {newBovine["is_male"] = value ?? ''},
                options: [
                  IOption(label: "Macho", value: "1"),
                  IOption(label: "Hembra", value: "0")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                validator: _validationEmpty,
                labelText: "Proveniencia",
                onSaved: (value) => {newBovine["provenance_id"] = value ?? ''},
                options: provenanceOptions),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                validator: _validationEmpty,
                labelText: "Es al aumento",
                onSaved: (value) => {newBovine["for_increase"] = value ?? ''},
                options: [
                  IOption(label: "Si", value: "1"),
                  IOption(label: "No", value: "0")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: _onSubmitForm,
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}
