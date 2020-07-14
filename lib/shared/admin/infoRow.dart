import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {

  final String text;
  final TextEditingController controller;

  InfoRow({Key key, this.text, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(children: [
      TitleColumn(text: text),
      Flexible(child: 
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),)
      ),
    ],);
  }
}

class TitleColumn extends StatelessWidget {
  final String text;

  TitleColumn({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _controller.text = widget.data;

    return 
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 130,
          child: 
            Text("$text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Roboto')),
        ),
      );
  }
}
