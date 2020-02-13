import 'package:flutter/material.dart';
class PostsNewPage extends StatefulWidget {
  @override
  _PostsNewPageState createState() => _PostsNewPageState();
}
class _PostsNewPageState extends State<PostsNewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PostsNew Page"),
      ),
      body: Center(
        child: Text('This is posts new page')
      ),
    );
  }
}