import 'dart:developer';
import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();
  String newDisplayName = "";
  bool hasNewDisplay = false;

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              (hasNewDisplay? Text(
                'Welcome There $newDisplayName',
                style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
              ) :
              Text(
                'Welcome There ${user.displayName}',
                style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
              )),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Display Name',
                  ),
                  onSubmitted: (String value) async {
                    await userService.updateUserPreferences(user, value);
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Great!'),
                          content: Text('Your new display name is "$value".'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () { Navigator.pop(context);},
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      newDisplayName = value;
                      hasNewDisplay = true;
                    });
                  }),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 200),
                child: 
                  FlatButton(
                    child: Text('Logout'),
                    color: Colors.red[400],
                    onPressed: () async {
                      print('ok you just signed out bruh');
                      await auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  }),
              ),
              Text(
                'Your Favorite Breeds:',
                style: TextStyle(height: 1.5, fontWeight: FontWeight.bold)),
              UserFavoriteBreeds()
          ],
        ),
            )),
        bottomNavigationBar: AppBottomNav(route: 2, inactive: false,),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sorry you are not logged in!!',
              style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text('Login'),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    Navigator.pushNamed(context, '/login');
                  }),
            ),
          ],
        )),
        bottomNavigationBar: AppBottomNav(route: 2, inactive: false),
      );
    }
  }
}

class UserFavoriteBreeds extends StatelessWidget {
  // final dynamic userFavoriteBreeds = [];

  @override
  Widget build(BuildContext context) {
    // FirebaseUser user = Provider.of<FirebaseUser>(context);
    // String id = user.uid;


    return FutureBuilder(
      future: Global.userDetailsRef.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        UserDetails userDetails = snap.data;
        print('ok got this userdetails: ');
        print(snap);
        print(snap.data);
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: userDetails.favoriteBreeds.map((opt) {
              return Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 6),
                color: Colors.black26,
                child: InkWell(
                  onTap: () {
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        Icon(
                            FontAwesomeIcons.dog,
                            size: 20),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              opt,
                              // opt.value,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

Future<void> _updateUserDetails(UserDetails userDetails) {
  // return Global.userDetailsRef.upsert(
  //   ({
  //     'total': FieldValue.increment(1),
  //     'topics': {
  //       '${quiz.topic}': FieldValue.arrayUnion([quiz.id])
  //     }
  //   }),
  // );
}



