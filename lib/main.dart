import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/home_page.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/register_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;
  String testProviderText = "Hello Provider!";

  // https://stackoverflow.com/questions/41479255/life-cycle-in-flutter
  // https://flutterbyexample.com/stateful-widget-lifecycle/
  void initState() {
    super.initState();

    // https://firebase.google.com/docs/auth/web/manage-users
    // https://stackoverflow.com/questions/45353730/firebase-login-with-flutter-using-onauthstatechanged
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      // This is called when "sign-in" and "sign-out" is triggerd
      print('onAuthStateChanged called!!!');
      
      // If user signed-in already "user" is not null
      setState(() {
        isAuthenticated = user != null;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<String>(create: (context) => testProviderText),
        Provider<bool>(create: (context) => isAuthenticated)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => HomePage(),
          '/sign_up': (context) => RegisterPage(),
        },
      ),
    );
  }
}
