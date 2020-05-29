import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNav extends StatefulWidget {
  @override
  _AppBottomNavState createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dog, size: 20),
            title: Text('Dogopedia')),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search, size: 20),
            title: Text('Pup Finder')),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userCircle, size: 20),
            title: Text('Dashboard')),
        // BottomNavigationBarItem(
        //     icon: Icon(FontAwesomeIcons.question, size: 20),
        //     title: Text('Quiz')),
      ],
      currentIndex: _selectedIndex,
      // unselectedItemColor: Colors.white,
      // selectedItemColor: Theme.of(context).accentColor,
      selectedItemColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      // fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        setState(() {
          _selectedIndex = idx;
        });
        switch (idx) {
          case 0:
            Navigator.pushNamed(context, '/dogopedia');
            break;
          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
            Navigator.pushNamed(context, '/dashboard');
            break;
          // case 3:
          //   Navigator.pushNamed(context, '/quiz');
          //   break;
        }
      },
    );
  }
}
