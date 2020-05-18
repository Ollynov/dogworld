import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: [],
          ),
        );
      },
    );
  }
}
