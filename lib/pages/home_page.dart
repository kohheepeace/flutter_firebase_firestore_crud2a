import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/global_state.dart';
import 'package:flutter_firebase_firestore_crud2a/widgets/home_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = Provider.of<GlobalState>(context).isAuthenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: HomeDrawer(),
      body: Center(
        child: isAuthenticated ? Text('Home Page after login') : Text('Home Page before login')
      ),
    );
  }
}
