import 'dart:developer';
import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome There ${user.displayName}',
              style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
            ),
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text('Logout'),
                  color: Colors.red[400],
                  onPressed: () async {
                    log('ok you just signed out bruh');
                    print('ok you just signed out bruh');
                    await auth.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }),
            ),
          ],
        )),
        bottomNavigationBar: AppBottomNav(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sorry you are not logged in.',
              style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text('Login'),
                  color: Colors.greenAccent,
                  onPressed: () async {
                    Navigator.pushNamed(context, '/login');
                  }),
            ),
          ],
        )),
        bottomNavigationBar: AppBottomNav(),
      );
    }
  }
}
