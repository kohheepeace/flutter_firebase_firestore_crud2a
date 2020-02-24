import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;

  // https://dart.dev/guides/language/language-tour#constructors
  Post(this.id, this.title, this.content, this.createdAt);

  // https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4
  // 1. Using "Named constructors"
  // 2. Using "Initializer list"
  Post.fromFirestore(DocumentSnapshot document)
    : id = document.documentID,
      title = document['title'],
      content = document['content'],
      createdAt = document['createdAt'];
}