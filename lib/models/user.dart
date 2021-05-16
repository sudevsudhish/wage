import 'package:cloud_firestore/cloud_firestore.dart';

class Userr {
  final String id;
  final String displayName;
  final String occupation;
  final String email;
  final String description;
  final String photoUrl;

  Userr(
      {this.id,
      this.displayName,
      this.occupation,
      this.email,
      this.description,
      this.photoUrl});

  factory Userr.fromDocument(DocumentSnapshot doc) {
    return Userr(
        id: doc['id'],
        email: doc['email'],
        occupation: doc['occupation'],
        photoUrl: doc['photoUrl'],
        description: doc['description'],
        displayName: doc['displayName']);
  }
}
