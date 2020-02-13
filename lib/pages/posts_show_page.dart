import 'package:flutter/material.dart';
class PostsShowPage extends StatefulWidget {
  @override
  _PostsShowPageState createState() => _PostsShowPageState();
}
class _PostsShowPageState extends State<PostsShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PostsShow Page"),
      ),
      body: Center(
        child: Text('This is posts show page')
      ),
    );
  }
}