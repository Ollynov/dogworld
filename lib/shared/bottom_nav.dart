import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNav extends StatefulWidget {
  AppBottomNav({Key key, this.route, this.inactive}) : super(key: key);
  final int route;
  final bool inactive;

  @override
  _AppBottomNavState createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _selectedIndex = 0;
  bool _inactive = false;
  Color selected;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.route;
    _inactive = widget.inactive;
    if (_inactive) {
      selected = Colors.black38;
    } else {
      selected = Colors.white;
    }
  }



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
      // selectedItemColor: Theme.of(context).accentColor,
      selectedItemColor: selected,
      unselectedItemColor: Colors.black54,
      backgroundColor: Theme.of(context).primaryColorDark,
      onTap: (int idx) {
        // setState(() {
        //   _selectedIndex = idx;
        // });
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
          default:
            print('chi');
            break;
        }
      },
    );
  }
}
