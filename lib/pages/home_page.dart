import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/widgets/home_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.isAuthenticated}) : super(key: key);
  final bool isAuthenticated;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: HomeDrawer(isAuthenticated: widget.isAuthenticated),
      body: Center(
        child: widget.isAuthenticated ? Text('Home Page after login') : Text('Home Page before login')
      ),
    );
  }
}
