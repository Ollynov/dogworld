import 'dart:developer';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthService auth = AuthService();
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          logger.d("user");
          developer.log(
            'log me',
            name: 'my.app.category',
            error: jsonEncode(user),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }

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
              'Welcome There',
              style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
            ),
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
      return Text('Sorry you are not logged in.');
    }
  }
}

// class ProfileScreen extends StatelessWidget {
//   final AuthService auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     FirebaseUser user = Provider.of<FirebaseUser>(context);

//     if (user != null) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.deepOrange,
//           title: Text(user.displayName ?? 'Guest'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               if (user.photoUrl != null)
//                 Container(
//                   width: 100,
//                   height: 100,
//                   margin: EdgeInsets.only(top: 50),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: NetworkImage(user.photoUrl),
//                     ),
//                   ),
//                 ),
//               Text(user.email ?? '',
//                   style: Theme.of(context).textTheme.headline),
//               Spacer(),
//               FlatButton(
//                   child: Text('logout'),
//                   color: Colors.red,
//                   onPressed: () async {
//                     await auth.signOut();
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil('/', (route) => false);
//                   }),
//               Spacer()
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Text('not logged in...');
//     }
//   }
// }
