import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';
import 'screens/screens.dart';

import 'package:doggies/shared/bottom_nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Report>.value(value: Global.reportRef.documentStream),
        StreamProvider<FirebaseUser>.value(value: AuthService().userStream),
      ],
      child: MaterialApp(
        title: 'Dog World',
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xffA83518),
          accentColor: Color(0xffF2A922),
//           .Smiling-bi-eyed-husky-dog-wait-dog-treats-on-the-yellow-background.-Smiling-dog-is-wait-for-food.-1-hex { color: #A67CA3; }
// .Smiling-bi-eyed-husky-dog-wait-dog-treats-on-the-yellow-background.-Smiling-dog-is-wait-for-food.-2-hex { color: #F0F0F2; }
// .Smiling-bi-eyed-husky-dog-wait-dog-treats-on-the-yellow-background.-Smiling-dog-is-wait-for-food.-3-hex { color: #F2CB05; }
// .Smiling-bi-eyed-husky-dog-wait-dog-treats-on-the-yellow-background.-Smiling-dog-is-wait-for-food.-4-hex { color: #F2D95C; }
// .Smiling-bi-eyed-husky-dog-wait-dog-treats-on-the-yellow-background.-Smiling-dog-is-wait-for-food.-5-hex { color: #F2B705; }

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // brightness: Brightness.light,
          buttonTheme: ButtonThemeData(),
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 18),
              bodyText2: TextStyle(fontSize: 16),
              button:
                  TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
              subtitle1: TextStyle(color: Colors.grey)),
        ),
        home: MyHomePage(title: 'Doggies'),
        routes: {
          '/breed-information': (context) => BreedInfo(),
          '/dog': (context) => Dog(),
          '/profile': (context) => Profile(),
          '/dashboard': (context) => DashboardScreen(),
          '/dogopedia': (context) => DogopediaScreen(),
          '/search': (context) => SearchScreen(),
          '/login': (context) => LoginScreen(),
          '/quiz': (context) => QuizScreen(),
        },

        // WEB does not support firebase storage nor analytics so commenting out to avoid errors for now
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        // ],
      ),
    );
  }
}

class BreedInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Dog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Dogopedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AuthService auth = AuthService();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.userCircle,
            ),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // FlatButton(
            //     onPressed: () async {
            //       Navigator.pushReplacementNamed(context, '/login');
            //     },
            //     child: Text("Go To Login")),
            // Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
      bottomNavigationBar:
          AppBottomNav(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('push'),
              color: Colors.green,
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SlideshowScreen(name: 'Jeff'))
                // );

                //  Navigator.pushNamed(
                //     context,
                //     '/slideshow'
                //   );

                Navigator.pushNamed(context, '/slideshow');
              },
            ),
          ],
        ),
      ),
    );
  }
}
