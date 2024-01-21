import 'package:flutter/material.dart';
enum TextBorderedType { normal, small }
class TextBordered extends StatefulWidget {
  const TextBordered({
    Key? key,
    required this.text,
    this.type = TextBorderedType.normal
  }) : super(key: key);
  final String text;
  final TextBorderedType type;
  @override
  State<TextBordered> createState() => _TextBorderedState();
}

class _TextBorderedState extends State<TextBordered> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.type == TextBorderedType.normal
          ? EdgeInsets.symmetric(vertical: 4)
          : EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: Colors.grey,
          width: .8,
        ),
      ),
      padding: widget.type == TextBorderedType.normal
          ? EdgeInsets.symmetric(vertical: 6, horizontal: 10)
          : EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      child: Text(
        widget.text,
        style: TextStyle(
            fontSize: widget.type == TextBorderedType.normal ? 17 : 14),
      ),
    );
  }
}
