import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/models/post.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/login_page.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/posts_new_page.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/posts_show_page.dart';
import 'package:flutter_firebase_firestore_crud2a/widgets/home_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: HomeDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collectionGroup('posts').orderBy('createdAt', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  final post = Post.fromFirestore(document);
                  
                  return ListTile(
                    title: Text(
                      post.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.content),
                    onTap: () {
                      // https://flutter.dev/docs/cookbook/navigation/passing-data#4-navigate-and-pass-data-to-the-detail-screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostsShowPage(post: post),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsNewPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        tooltip: 'New Post',
        child: Icon(Icons.note_add),
      ),
    );
  }
}
