import 'package:flutter/material.dart' hide Router;

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
          style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),)
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
            Text("$text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Roboto')),
        ),
      );
  }
}

class InfoRow2 extends StatelessWidget {

  final String text;
  final TextEditingController controller;

  InfoRow2({Key key, this.text, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(children: [
      TitleColumn2(text: text),
      Container(
        width: 100, 
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),)
      ),
    ],);
  }
}

class TitleColumn2 extends StatelessWidget {
  final String text;

  TitleColumn2({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _controller.text = widget.data;

    return 
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 230,
          child: 
            Text("$text", style: TextStyle(fontSize: 16, fontFamily: 'Roboto')),
        ),
      );
  }
}
