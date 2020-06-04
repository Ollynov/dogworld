import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // GET LOGGED IN USERS INFO. TWO GETTER FUNCTIONS, ONE AS A ASYNC FUNCTION, OTHER AS STREAM!
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;

  // For apple sign in, first determine whether it's even an option on their device. Apple sign in is now a requirement for the app store.
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  // APPLE SIGN IN
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        print('ok here is our appleResult: ');
        print(appleResult);
      }

      final AuthCredential credential = OAuthProvider(providerId: 'apple.com')
          .getCredential(
              accessToken: String.fromCharCodes(
                  appleResult.credential.authorizationCode),
              idToken:
                  String.fromCharCodes(appleResult.credential.identityToken));

      // I believe that the getCredential method uses OAuth strategy with apple specifically, to grab the authorization code from the browser and deserialize it or something like that. Then you can pass it into the next function which will do an api call to your firebase to actually log the person in.
      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      updateUserData(user);

      return user;
    } catch (err) {
      print('got this error in apple sign in: ');
      print(err);
      return null;
    }
  }

  // LAZY REGISTRATION< WHERE WE DON"T HAVE ANY INFO OTHER THAN A USERID FOR THE PERSON
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    updateUserData(user);
    return user;
  }

  // GOOGLE SIGNIN
  Future<FirebaseUser> googleSignIn() async {
    print('we trying to sign in thats madness');
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      // These are the secure tokens that are saved on our browser after we have succesfully signed into google, and they have redirected us back to our app with the tokens
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      // Finally we sign into our own app with the credential variable from above.
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      updateUserData(user); // this is just in case anything has changed;
      print('ok here is user: ');
      print(user);

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

  Future<void> signOut() {
    return _auth.signOut();
  }
}
