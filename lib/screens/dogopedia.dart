import 'package:doggies/shared/shared.dart';
import 'package:flutter/material.dart';

class DogopediaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dogopedia'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
            'Here is your dogopedia where you will find everything dogs....'),
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }
}
