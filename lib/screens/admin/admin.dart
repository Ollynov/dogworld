import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../../services/services.dart';
import './../../shared/shared.dart';
import 'package:provider/provider.dart';


class AdminScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // UserDetails userDetails = Provider.of<UserDetails>(context);


    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
            leading: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () { Scaffold.of(context).openDrawer();},
              tooltip: "Go Home",
            )
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new InkWell(
              child: new Text('Edit Breeds'),
              onTap: () => Navigator.pushNamed(context, '/admin/editBreed')
            ),
          ],
        ),
            )),
      );
    } else {
      return Text('Looks like you are not logged in as an admin');
    }
  }
}
