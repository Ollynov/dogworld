import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UsersService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // GET LOGGED IN USERS INFO. TWO GETTER FUNCTIONS, ONE AS A ASYNC FUNCTION, OTHER AS STREAM!
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;

  Future<void> updateUserPreferences(FirebaseUser user) {
    DocumentReference userRef = _db.collection('users').document(user.uid);

    // this just updates info we have on the user, and gives us the last time they were active on the site. merge: true is important, so it only overwrites in case the data now is different
    return userRef.setData({
      'uid': user.uid,
      'displayName': user.displayName,
      'lastActivity': DateTime.now(),
    }, merge: true);
  }
}
