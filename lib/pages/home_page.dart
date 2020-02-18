import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/login_page.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
							leading: Icon(Icons.exit_to_app),
							title: Text('Login'),
							onTap: () {
								// https://flutter.dev/docs/cookbook/navigation/navigation-basics#2-navigate-to-the-second-route-using-navigatorpush
								// https://stackoverflow.com/questions/43807184/how-to-close-scaffolds-drawer-after-an-item-tap
								Navigator.pop(context);
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => LoginPage()),
								);
							}
						),
            ListTile(
							leading: Icon(Icons.account_circle),
							title: Text('Register'),
							onTap: () {
								Navigator.pop(context);
								Navigator.pushNamed(context, '/sign_up');
							}
						),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: widget.isAuthenticated ? Text('Home Page after login') : Text('Home Page before login')
      ),
    );
  }
}
