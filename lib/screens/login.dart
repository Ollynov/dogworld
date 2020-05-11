import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:apple_sign_in/apple_sign_in.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          print('you already logged in boy!');
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(
              size: 150,
            ),
            Text(
              'Login to Start',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Text('Your Tagline'),
            LoginButton(
                text: 'LOGIN WITH GOOGLE',
                icon: FontAwesomeIcons.google,
                color: Colors.black45,
                loginMethod: auth.googleSignIn,
                destination: '/dashboard'),
            // We first need to wrap our Apple sign in button in a FutureBuilder Widget. The way this widget works is it returns a future and it's context to the builder output. This can be useful if you need a button that has the name of a logged in user, or for example if you want to do a conditional statement, like we want to do in this case here:
            FutureBuilder<Object>(
                future: auth.appleSignInAvailable,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return AppleSignInButton(
                      onPressed: () async {
                        FirebaseUser user = await auth.appleSignIn();
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
            LoginButton(text: 'Continue as Guest', loginMethod: auth.anonLogin),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;
  final String destination;

  const LoginButton(
      {Key key,
      this.color,
      this.icon,
      this.text,
      this.loginMethod,
      this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          print('ok in our button we got user as: ');
          print(user);
          if (user != null) {
            Navigator.pushReplacementNamed(context, destination);
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
