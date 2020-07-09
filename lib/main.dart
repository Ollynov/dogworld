import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'config/router.dart';
import 'screens/admin/admin.dart';
import 'screens/admin/editBreed.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'shared/bottom_nav.dart';


void main() {
  runApp(MyApp());
}

class Application {
  static Router router;
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Color(0xffff1744);
  final Color primaryColorDark = Color(0xffc4001d);
  final Color primaryColorLight = Color(0xffff616f);
  final Color secondaryColor = Color(0xffffd117);
  final Color secondaryColorDark = Color(0xffc7a000);
  final Color secondaryColorLight = Color(0xffffff58);

  _MyAppState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Report>.value(value: Global.reportRef.documentStream),
        StreamProvider<UserDetails>.value(value: Global.userDetailsRef.documentStream),
        StreamProvider<FirebaseUser>.value(value: AuthService().userStream),
      ],
      child: MaterialApp(
        title: 'Dog World',
        theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorDark: primaryColorDark,
          primaryColorLight: primaryColorLight,
          accentColor: secondaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonThemeData(
            minWidth: 100,
            padding: EdgeInsets.all(14),
            buttonColor: Colors.grey[300],
          ),
          
          // buttonTheme: ButtonThemeData().copyWith(
          //   buttonColor: secondaryColor
          // ),
          fontFamily: 'IndieFlower',
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 18),
              bodyText2: TextStyle(fontSize: 16),
              headline1: TextStyle(fontSize: 44),
              headline2: TextStyle(fontSize: 36),
              button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
              subtitle1: TextStyle(color: Colors.grey, fontSize: 24)),
          cardTheme: CardTheme(
            color: Colors.grey[100]
          ),
          appBarTheme: AppBarTheme(
            color: primaryColorDark,
            textTheme: Typography.blackCupertino,
            // brightness: Brightness.light,  
            iconTheme: IconThemeData(
              // color: Colors.black
            ),
          ),
        ),
        // initialRoute: '/dogopedia',
        home: MyHomePage(),
        routes: {
          // '/breed-information': (context) => BreedInfo(),
          // '/dog': (context) => Dog(),
          // '/profile': (context) => Profile(),
          '/dashboard': (context) => DashboardScreen(),
          '/dogopedia': (context) => DogopediaScreen(),
          '/search': (context) => SearchScreen(),
          '/login': (context) => LoginScreen(),
          // '/quiz': (context) => QuizScreen(),
          // '/breed/*': (context) => BreedScreen(),
          '/admin': (context) => AdminScreen(),
          '/admin/editBreed': (context) => EditBreedScreen()
        },
        onGenerateRoute: Application.router.generator
       
        // WEB does not support firebase storage nor analytics so commenting out to avoid errors for now
        // navigatorObservers: [
        //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        // ],
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // builder widget does 2 things essentially: 
        // waits until the parent widget is done building before returning it's child
        // gives the child the context of the build
        // this normally happens anyways if you had a completely separate widget, but if you just have something very small then you may not want to create a compmletely new widget.
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return IconButton(
        //       icon: const Icon(Icons.home),
        //       // onPressed: () { Scaffold.of(context).openDrawer();},
        //       tooltip: "Go Home",
        //     );
        //   },
        // ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          )
        ],
      ),
      backgroundColor: Colors.white,
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
          children: [
            Image.asset('assets/WhiteDogWorld.png')
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      //   backgroundColor: Theme.of(context).accentColor,
      // ),
      bottomNavigationBar:
          AppBottomNav(route: 0, inactive: true), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
