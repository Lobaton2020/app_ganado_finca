import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/shared/components/AutocompleteSingleFormField.dart';
import 'package:app_ganado_finca/src/shared/components/DateFormField.dart';
import 'package:app_ganado_finca/src/shared/components/ImageFormField.dart';
import 'package:app_ganado_finca/src/shared/components/SelectFormField.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/fromDateString.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:app_ganado_finca/src/shared/utils/snackBartMessage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const provenanceId = {
  "Comprado": "1",
};

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
  bool isLoading = false;
  bool mustShowAmount = false;
  List<IOption> ownerOptions = [];
  List<IOption> provenanceOptions = [];
  List<IOption> motherBovineOptions = [];

  String? _validationEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  void onChangeImage(XFile image) {
    newBovine["photo"] = image;
  }

  void _onSubmitForm() async {
    if (_form.currentState!.validate()) {
      setState(() => isLoading = true);
      _form.currentState!.save();
      newBovine["owner_id"] = int.parse(newBovine["owner_id"]);
      newBovine["provenance_id"] = int.parse(newBovine["provenance_id"]);
      newBovine["is_male"] = newBovine["is_male"] == "1";
      newBovine["for_increase"] = newBovine["for_increase"] == "1";
      newBovine["date_birth"] =
          fromDateStringToIsoString(newBovine["date_birth"]);
      if (newBovine.containsKey("mother_id")) {
        newBovine["mother_id"] = int.parse(newBovine["mother_id"]);
      }
      if (newBovine["provenance_id"]!.toString() == provenanceId["Comprado"]) {
        newBovine["adquisition_amount"] =
            num.parse("${newBovine["adquisition_amount"]}");
      } else {
        newBovine.remove("adquisition_amount");
      }
      try {
        if (await bovineService.findOneByName(newBovine["name"] as String) !=
            null) {
          showSnackBar(context, "Error, ya existe un animal con ese nombre");
          setState(() => isLoading = false);
          return;
        }
        if (newBovine["photo"] != null) {
          newBovine["photo"] =
              await storageService.uploadBovinePhoto(newBovine["photo"]);
        }
        await bovineService.create(Bovine.fromJson(newBovine));
        showSnackBar(context, "Proceso exitoso!");
        try {
          _form.currentState!.reset();
        } catch (e) {}
        newBovine.remove("photo");
        setState(() => isLoading = false);
        Navigator.pop(context);
        tabObserver.add(1);
      } catch (err) {
        print(err);
        setState(() => isLoading = false);
        showSnackBar(context, "F: $err");
      }
    }
  }

  void _onChangeProvenance(String? provenanceIdParam) {
    setState(() {
      mustShowAmount = provenanceIdParam != null &&
          provenanceIdParam == provenanceId["Comprado"];
    });
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      bovineService.findOwners(),
      bovineService.findProvenances(),
      bovineService.findBovinesNames(),
    ]).then((values) {
      setState(() {
        ownerOptions = values[0];
        provenanceOptions = values[1];
        motherBovineOptions = values[2];
      });
    }).catchError((error) {
      print("Error consulta owners or provenances: " + error);
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
            child: AutocompleteSingleFormField(
                labelText: "Madre del animal",
                onSelected: (option) => {newBovine["mother_id"] = option.value},
                options: motherBovineOptions),
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
                onChange: _onChangeProvenance,
                onSaved: (value) => {newBovine["provenance_id"] = value ?? ''},
                options: provenanceOptions),
          ),
          mustShowAmount
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Monto de compra',
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
                        {newBovine["adquisition_amount"] = value ?? ''},
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SelectFormField(
                initialValue: "0",
                validator: _validationEmpty,
                labelText: "Es al aumento",
                onSaved: (value) => {newBovine["for_increase"] = value ?? ''},
                options: [
                  IOption(label: "Si", value: "1"),
                  IOption(label: "No", value: "0")
                ]),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ImageFormField(onChange: onChangeImage)),
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
