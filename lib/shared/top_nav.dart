import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
