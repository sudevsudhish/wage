import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wage/Components/Round_button.dart';
import 'package:wage/models/user.dart';
import 'package:wage/screens/signup_screen.dart';

var firebaseUser = FirebaseAuth.instance.currentUser;

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(firebaseUser.photoURL),
                  ),
                  Text(
                    firebaseUser.displayName,
                    style: TextStyle(fontSize: 22.0, color: Color(0xFF2F2440)),
                  ),
                  Text(
                    firebaseUser.email,
                    style: TextStyle(fontSize: 18.0, color: Color(0xff2F2440)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xff2F2440),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.person_add,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.work,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Jobs',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.coronavirus,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Covid-19 work instructions',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.support_agent,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Customer care',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'About us',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.call,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Contact us',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF7D7098),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          size: 35.0,
                          color: Color(0xff2F2440),
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff2F2440)),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Container(
                              child: Center(
                                child: Expanded(
                                  child: Container(
                                    height: 250,
                                    width: 300,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Are you sure to logout ?',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RoundButton(
                                          color: Colors.red,
                                          title: 'Logout',
                                          onPressed: () {
                                            setState(() {
                                              GoogleSignIn().signOut();
                                              Navigator.pushNamed(
                                                  context, SignupScreen.id);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
