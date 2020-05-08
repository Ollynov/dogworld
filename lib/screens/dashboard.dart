import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: FlatButton(
                child: Text('Logout'),
                color: Colors.red,
                onPressed: () async {
                  log('ok you just signed out bruh');
                  print('ok you just signed out bruh');
                  await auth.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                })),
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
