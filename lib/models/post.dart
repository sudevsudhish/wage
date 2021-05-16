import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wage/Components/progress.dart';
import 'package:wage/models/user.dart';
import 'package:wage/screens/home_page.dart';

var firebaseUser = FirebaseAuth.instance.currentUser;

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post(
      {this.postId,
      this.ownerId,
      this.username,
      this.location,
      this.description,
      this.mediaUrl,
      this.likes});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      location: this.location,
      description: this.description,
      mediaUrl: this.mediaUrl,
      likes: this.likes,
      likeCount: getLikeCount(this.likes));
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  Map likes;
  int likeCount;

  _PostState(
      {this.postId,
      this.ownerId,
      this.username,
      this.location,
      this.description,
      this.mediaUrl,
      this.likes,
      this.likeCount});

  buildPostHeader() {
    // return FutureBuilder(
    //     future: usersRef.doc(firebaseUser.uid).get(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return CircularProgress();
    //       }
    //       Userr user = Userr.fromDocument(snapshot.data);
    //       return ListTile(
    //         leading: CircleAvatar(
    //           backgroundColor: Colors.grey,
    //           backgroundImage:
    //               CachedNetworkImageProvider(firebaseUser.photoURL),
    //         ),
    //         title: GestureDetector(
    //           child: Text(
    //             firebaseUser.displayName,
    //             style:
    //                 TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    //           ),
    //         ),
    //         subtitle: Text(location),
    //         trailing: IconButton(
    //           onPressed: () => print('Deleting post'),
    //           icon: Icon(Icons.more_vert),
    //         ),
    //       );
    //     });
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () {
        print('Liking the post');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 40.0),
            ),
            GestureDetector(
              onTap: () {
                print('Liking the post');
              },
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Color(0xFF4d426c),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            GestureDetector(
              onTap: () {
                print('Show mcomments');
              },
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount interests",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text(description))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildPostHeader(), buildPostImage(), buildPostFooter()],
    );
  }
}
