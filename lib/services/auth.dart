import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // GET LOGGED IN USERS INFO. TWO GETTER FUNCTIONS, ONE AS A ASYNC FUNCTION, OTHER AS STREAM!
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;

  // LAZY REGISTRATION< WHERE WE DON"T HAVE ANY INFO OTHER THAN A USERID FOR THE PERSON
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // These are the secure tokens that are saved on our browser after we have succesfully signed into google, and they have redirected us back to our app with the tokens
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      // Finally we sign into our own app with the credential variable from above.
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      updateUserData(user); // this is just in case anything has changed;

      return user;
    } catch (err) {
      print('ok got an error with google signin: ');
      print(err);
      return null;
    }
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);

    // this just updates info we have on the user, and gives us the last time they were active on the site. merge: true is important, so it only overwrites in case the data now is different
    return reportRef.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now(),
    }, merge: true);
  }
}
