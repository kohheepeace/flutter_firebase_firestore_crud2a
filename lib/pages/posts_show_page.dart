import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_crud2a/models/post.dart';

class PostsShowPage extends StatefulWidget {
  PostsShowPage({Key key, @required this.post}) : super(key: key);
  final Post post;

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
        // https://stackoverflow.com/questions/51579546/how-to-format-datetime-in-flutter
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Title is ... ${widget.post.title}"), // https://stackoverflow.com/questions/50818770/passing-data-to-a-stateful-widget
            Text("CreatedAt: ${widget.post.createdAt.toDate()}"), // If you need format date => https://stackoverflow.com/questions/51579546/how-to-format-datetime-in-flutter
          ],
        )
      ),
    );
  }
}