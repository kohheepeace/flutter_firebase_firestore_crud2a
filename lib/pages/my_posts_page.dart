import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/models/post.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/posts_edit_page.dart';
import 'package:flutter_firebase_firestore_crud2a/pages/posts_show_page.dart';
import 'package:provider/provider.dart';

class MyPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
                  .collection("users")
                  .document(user.uid)
                  .collection("posts")
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
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
                    trailing: PopupMenuButton(
                      onSelected: (result) async {
                        final type = result["type"];
                        final post = result["value"];
                        switch (type) {
                          case 'edit':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostsEditPage(post: post),
                              ),
                            );
                            break;
                          case 'delete':
                            await Firestore.instance
                              .collection('users')
                              .document(user.uid)
                              .collection('posts')
                              .document(post.id)
                              .delete();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: {"type": "edit", "value": post},
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: {"type": "delete", "value": post},
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
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
    );
  }
}