import 'package:flutter/material.dart';
class PostsEditPage extends StatefulWidget {
  @override
  _PostsEditPageState createState() => _PostsEditPageState();
}
class _PostsEditPageState extends State<PostsEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PostsEdit Page"),
      ),
      body: Center(
        child: Text('This is posts edit page')
      ),
    );
  }
}