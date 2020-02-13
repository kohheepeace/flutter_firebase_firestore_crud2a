import 'package:flutter/material.dart';
class MyPostsPage extends StatefulWidget {
  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}
class _MyPostsPageState extends State<MyPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPosts Page"),
      ),
      body: Center(
        child: Text('This is myposts page')
      ),
    );
  }
}