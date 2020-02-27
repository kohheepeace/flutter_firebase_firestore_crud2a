import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_firestore_crud2a/models/post.dart';
import 'package:provider/provider.dart';

class PostsEditPage extends StatefulWidget {
  PostsEditPage({Key key, @required this.post}) : super(key: key);
  final Post post;

  @override
  _PostsEditPageState createState() => _PostsEditPageState();
}

class _PostsEditPageState extends State<PostsEditPage> {
  final GlobalKey<FormState> _editPostFormKey_ = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();

  // https://flutter.dev/docs/development/ui/interactive
  bool _isSubmitting = false;

  @override
  initState() {
    // https://github.com/flutter/flutter/issues/9969
    titleInputController.text = widget.post.title;
    contentInputController.text = widget.post.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Post"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
            key: _editPostFormKey_,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Title*', hintText: "Title"),
                  controller: titleInputController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Content', hintText: "Post content here..."),
                  controller: contentInputController,
                ),
                SizedBox(height: 20),
                _isSubmitting ? // https://stackoverflow.com/questions/47065098/how-to-work-with-progress-indicator-in-flutter
                Center(child: CircularProgressIndicator())
                :
                RaisedButton(
                  child: Text("Update Post"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_editPostFormKey_.currentState.validate()) {
                      try {
                        setState(() {
                          _isSubmitting = true;
                        });
                        
                        final user = Provider.of<FirebaseUser>(context, listen: false);
                      
                        await Firestore.instance
                          .collection('users')
                          .document(user.uid)
                          .collection("posts")
                          .document(widget.post.id)
                          .updateData({
                            "title": titleInputController.text,
                            "content": contentInputController.text,
                            "updatedAt": FieldValue.serverTimestamp()
                          });
                        
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error Happened!!!: $e');
                        setState(() {
                          _isSubmitting = false;
                        });
                      }  
                    }
                  },
                ),
              ],
            ),
          )
        )
      )
    );
  }
}