import 'package:doggies/shared/bottom_nav.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text(
          
          'Coming Soon...',)
          // style: TextStyle(fontFamily: 'IndieFlower')),
      ),
      bottomNavigationBar: AppBottomNav(route: 1, inactive: false,),
    );
  }
}
