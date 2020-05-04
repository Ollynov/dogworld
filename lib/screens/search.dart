import 'package:doggies/shared/bottom_nav.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Here is your search...'),
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }
}
