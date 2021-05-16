import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wage/Components/progress.dart';
import 'package:wage/models/post.dart';
import 'package:wage/models/user.dart';
import 'package:wage/screens/Home/edit_profile.dart';
import 'package:wage/screens/Home/main_drawer.dart';

import 'postJob.dart';

class Profile extends StatefulWidget {
  Userr currentUser = Userr();
  final String profileId;

  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future getData() {
    var userSnapshot = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        return element;
      });
    });
  }

  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef
        .doc(widget.currentUser.id)
        .collection('userposts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4d426c)),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4d426c)),
          ),
        )
      ],
    );
  }

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(),
      ),
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
          onPressed: function,
          child: Container(
            width: 250.0,
            height: 27.0,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.blue),
            ),
          )),
    );
  }

  buildProfileButton() {
    return buildButton(text: "Edit profile", function: editProfile);
  }

  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          print(widget.profileId);
          return Text("Document does not exist");
        }
        Userr user = Userr.fromDocument(snapshot.data);
        Map<String, dynamic> data = snapshot.data.data();
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Hero(
                tag: "propic",
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(data['photoUrl']),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "${data['diaplayName']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  "${data['occupation']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCountColumn("posts", postCount),
                        // buildCountColumn("followers", 0),
                        // buildCountColumn("following", 0)
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildProfileButton(),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  buildProfilePost() {
    if (isLoading) {
      CircularProgress();
    }
    return Column(
      children: posts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        backgroundColor: Color(0xFF4d426c),
      ),
      drawer: MainDrawer(),

      body: buildProfileHeader(),
      // body: ListView(
      //   children: [
      //     buildProfileHeader(),
      //     Divider(
      //       height: 0.0,
      //     ),
      //     buildProfilePost(),
      //   ],
      // ),
    );
  }
}
