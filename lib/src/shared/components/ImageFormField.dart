import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_ganado_finca/src/shared/utils/snackBartMessage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFormField extends StatefulWidget {
  const ImageFormField({
    Key? key,
    this.labelText = 'Presiona para elegir una foto',
    required this.onChange,
  }) : super(key: key);
  final String labelText;
  final void Function(XFile) onChange;
  @override
  State<ImageFormField> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  Uint8List? _image;
  handleChooseImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      final imageBytes = await image!.readAsBytes();
      if (image != null && imageBytes != null) {
        widget.onChange(image);
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (err) {
      showSnackBar(context, "F: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewImage = _image != null
        ? Container(
            margin: EdgeInsets.only(bottom: 6),
            child: Image.memory(
              _image as Uint8List,
              fit: BoxFit.contain,
            ),
          )
        : Text('');
    return Center(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(widget.labelText)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  handleChooseImage(ImageSource.camera);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: .8,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text("Camara"),
                ),
              ),
              InkWell(
                onTap: () {
                  handleChooseImage(ImageSource.gallery);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: .8,
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text("Galeria"),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: previewImage,
          ),
        ],
      ),
    );
  }
}
