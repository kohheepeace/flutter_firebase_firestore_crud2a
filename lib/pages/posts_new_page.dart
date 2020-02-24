import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsNewPage extends StatefulWidget {
  @override
  _PostsNewPageState createState() => _PostsNewPageState();
}

class _PostsNewPageState extends State<PostsNewPage> {
  final GlobalKey<FormState> _postNewFormKey = GlobalKey<FormState>();
  final titleInputController = TextEditingController();
  final contentInputController = TextEditingController();
  
  // https://flutter.dev/docs/development/ui/interactive#step-3-subclass-state
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PostsNew Page"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _postNewFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title*', hintText: "Title"
                  ),
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
                    labelText: 'Content', hintText: "Post content here..."
                  ),
                  controller: contentInputController,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: _isSubmitting ? // https://stackoverflow.com/a/53497047
                  Center(child: CircularProgressIndicator())
                  :
                  RaisedButton(
                    child: Text("Save Post"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_postNewFormKey.currentState.validate()) {
                        try {
                          setState(() {
                            _isSubmitting = true;
                          });
                          
                          final user = Provider.of<FirebaseUser>(context, listen: false);
                        
                          await Firestore.instance
                            .collection('users')
                            .document(user.uid)
                            .collection("posts")
                            .document()
                            .setData({
                              "title": titleInputController.text,
                              "content": contentInputController.text,
                              "createdAt": FieldValue.serverTimestamp(),
                              "updatedAt": FieldValue.serverTimestamp()
                            });
                          
                          // https://stackoverflow.com/a/46713257/6037441
                          // https://stackoverflow.com/a/45889342/6037441
                          Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                        } catch (e) {
                          print('Error Happened!!!: $e');
                          setState(() {
                            _isSubmitting = false;
                          });
                        }  
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}