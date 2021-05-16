import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wage/Components/Round_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wage/screens/home_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wage/screens/create_account.dart';
import 'package:wage/models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Userr curretUser;

class SignupScreen extends StatefulWidget {
  static String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  bool isAuth = false;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final DateTime timestamp = DateTime.now();

  gsignin() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = await _auth.signInWithCredential(credential);
    print("signed in ${user}");

    createUserInFirestore();
    // Navigator.pushNamed(context, HomePage.id);

    return user;
  }

  createUserInFirestore() async {
    // 1) check if user exists in user collection in databese according to their id
    final GoogleSignInAccount user = _googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    // 2) if youser dosent exist then we need to take to create accountpage

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // 3) get username from create account used to make new userdocument in users collection

      usersRef.doc(user.id).set({
        "id": user.id,
        "occupation": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "description": "",
        "timestamp": timestamp
      });
      Navigator.pushNamed(context, HomePage.id);
      doc = await usersRef.doc(user.id).get();
    } else if (doc.exists) {
      Navigator.pushNamed(context, HomePage.id);
    }

    curretUser = Userr.fromDocument(doc);
    print(curretUser);
    print(curretUser.occupation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xff2F2440), Color(0xFF7D7098)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/Icon.png',
              scale: 20,
            ),
            Text(
              "wage",
              style: TextStyle(
                fontSize: 60.0,
                color: Colors.white54,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    gsignin();
                  },
                  minWidth: 150.0,
                  height: 42.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          'images/google.png',
                          scale: 1.8,
                        ),
                      ),
                      Text('Signup with Google',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
