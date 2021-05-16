import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wage/Components/progress.dart';
import 'package:wage/models/user.dart';
import 'main_drawer.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController SearchController = TextEditingController();
  Future<QuerySnapshot> searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("occupation", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultFuture = users;
    });
  }

  buildSearchResults() {
    return FutureBuilder(
        future: searchResultFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgress());
          }
          List<UserResult> searchResults = [];
          snapshot.data.docs.forEach((doc) {
            Userr user = Userr.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return ListView(
            children: searchResults,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: buildSearcField(),
        drawer: MainDrawer(),
        body: searchResultFuture == null
            ? buildNoContent()
            : buildSearchResults(),
      ),
    );
  }

  buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(
              Icons.search_rounded,
              color: Color(0xff2F2440),
              size: 80.0,
            ),
            Text(
              'Find worker..',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff2F2440),
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildSearcField() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white54,
      title: (TextFormField(
        controller: SearchController,
        onChanged: (val) {},
        decoration: InputDecoration(
          hintText: 'Search for a worker..',
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              SearchController.clear();
              buildNoContent();
            },
          ),
        ),
        onFieldSubmitted: handleSearch,
      )),
    );
  }
}

// ignore: must_be_immutable
class UserResult extends StatelessWidget {
  Userr user;

  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF7D7098),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.occupation),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
