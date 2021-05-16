import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wage/Components/Round_button.dart';
import 'package:wage/Components/progress.dart';
import 'package:wage/models/user.dart';
import 'package:wage/screens/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

int i = j;
int j;
var firebaseUser = FirebaseAuth.instance.currentUser;
final usersRef = FirebaseFirestore.instance.collection('users');
Userr user;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genterController = TextEditingController();
  TextEditingController doBController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController jobExperianceController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(firebaseUser.uid).get();
    user = Userr.fromDocument(doc);
    displayNameController.text = user.displayName;
    emailController.text = user.email;
    jobNameController.text = user.occupation;
    jobDescriptionController.text = user.description;
    setState(() {
      isLoading = false;
    });
  }

  updateData() {
    int i = 0;
    int j;

    if (i == 0) {
      if (displayNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          jobNameController.text.isNotEmpty &&
          contactController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("profile")
            .doc(firebaseUser.uid)
            .set({
          "name": displayNameController.text,
          "age": addressController.text,
          "genter": genterController.text,
          "DateOfBirth": doBController.text,
          "jobDescription": jobDescriptionController.text,
          "jobName": jobNameController.text,
          "jobExperiance": jobExperianceController.text,
          "Qualification": qualificationController.text,
          "contact": contactController.text,
          "email": emailController.text,
          "place": placeController.text,
          "address": addressController.text,
        }).then((value) {
          Navigator.pop(context);
        });
      }
      j = 1;
    } else if (j == 1) {
      FirebaseFirestore.instance
          .collection("profile")
          .doc(firebaseUser.uid)
          .update({
        "name": displayNameController.text,
        "age": addressController.text,
        "genter": genterController.text,
        "DateOfBirth": doBController.text,
        "jobDescription": jobDescriptionController.text,
        "jobName": jobNameController.text,
        "jobExperiance": jobExperianceController.text,
        "Qualification": qualificationController.text,
        "contact": contactController.text,
        "email": emailController.text,
        "place": placeController.text,
        "address": addressController.text,
      }).then((value) => Navigator.pop(context));
      j = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4d426c),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: isLoading
          ? CircularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
                        child: Hero(
                          tag: "propic",
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: CachedNetworkImageProvider(
                                firebaseUser.photoURL),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: displayNameController,
                              decoration: InputDecoration(labelText: "Name"),
                            ),
                            TextFormField(
                              controller: ageController,
                              decoration: InputDecoration(labelText: "Age"),
                            ),
                            TextFormField(
                              controller: genterController,
                              decoration: InputDecoration(labelText: "Genter"),
                            ),
                            TextFormField(
                              controller: doBController,
                              decoration:
                                  InputDecoration(labelText: "Date of birth"),
                            ),
                            TextFormField(
                              controller: jobNameController,
                              decoration:
                                  InputDecoration(labelText: "Job name"),
                            ),
                            TextFormField(
                              controller: jobDescriptionController,
                              decoration:
                                  InputDecoration(labelText: "Job Description"),
                            ),
                            TextFormField(
                              controller: jobExperianceController,
                              decoration:
                                  InputDecoration(labelText: "Job experiance"),
                            ),
                            TextFormField(
                              controller: qualificationController,
                              decoration:
                                  InputDecoration(labelText: "Qualification"),
                            ),
                            TextFormField(
                              controller: contactController,
                              decoration: InputDecoration(labelText: "Contact"),
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: "Email"),
                            ),
                            TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(labelText: "Address"),
                            ),
                            TextFormField(
                              controller: placeController,
                              decoration: InputDecoration(labelText: "Place"),
                            ),
                            RoundButton(
                              title: "Update",
                              color: Color(0xFF4d426c),
                              onPressed: () {
                                updateData();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
