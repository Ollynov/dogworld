import 'package:flutter/material.dart' hide Router;
import 'package:flutter/widgets.dart';

class AppTopNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PreferredSize(
        preferredSize: null,
        child: AppBar(
          title: Text('Home'),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
