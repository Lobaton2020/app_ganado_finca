import 'package:flutter/material.dart';

class TextBordered extends StatefulWidget {
  const TextBordered({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  State<TextBordered> createState() => _TextBorderedState();
}

class _TextBorderedState extends State<TextBordered> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: Colors.grey,
          width: .8,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
