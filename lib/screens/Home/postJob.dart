import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wage/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'package:wage/Components/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wage/screens/Home/main_drawer.dart';

final storageRef = FirebaseStorage.instance.ref();
final postRef = FirebaseFirestore.instance.collection('posts');
final DateTime timestamp = DateTime.now();

class PostJob extends StatefulWidget {
  Userr currentUser;

  PostJob({this.currentUser});

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  // var firestoreDb = FirebaseFirestore.instance.collection('post').snapshots();
  // TextEditingController nameInputController;
  // TextEditingController titleInputController;
  // TextEditingController wageInputController;
  // TextEditingController locationInputController;
  // TextEditingController experianceInputController;
  // TextEditingController descriptionInputController;
  // TextEditingController availablityInputController;
  // TextEditingController contactInputController;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   nameInputController = TextEditingController();
  //   titleInputController = TextEditingController();
  //   wageInputController = TextEditingController();
  //   locationInputController = TextEditingController();
  //   experianceInputController = TextEditingController();
  //   descriptionInputController = TextEditingController();
  //   availablityInputController = TextEditingController();
  //   contactInputController = TextEditingController();
  // }

  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  bool isUploading = false;
  String postID = Uuid().v4();
  File file;

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File files = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.file = files;
    });
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a post"),
            children: [
              SimpleDialogOption(
                child: Text("Image from gallery"),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Scaffold buildSplashScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('POST'),
        backgroundColor: Color(0xFF4d426c),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/upload.svg',
              height: 260,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () {
                  selectImage(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Upload image',
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postID.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imagefile) async {
    var uploadTask = storageRef.child("post_$postID.jpg").putFile(imagefile);
    var storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  var firebaseUser = FirebaseAuth.instance.currentUser;
  createPostInFirestore({
    String mediaUrl,
    String location,
    String description,
    String title,
    String contact,
  }) {
    postRef.doc(firebaseUser.uid).collection('userposts').doc(postID).set({
      "postId": postID,
      "ownerID": firebaseUser.uid,
      "username": firebaseUser.displayName,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "title": title,
      "timestamp": timestamp,
      "likes ": {},
      "contact": contact,
    });
  }

  handleSubmit() async {
    await compressImage();
    String mediaUrl = await uploadImage(file);
    setState(() {
      isUploading = true;
    });
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: descriptionController.text,
      title: titleController.text,
      contact: contactController.text,
    );
    descriptionController.clear();
    titleController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postID = Uuid().v4();
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4d426c),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearImage();
          },
        ),
        title: Text(
          'Create your post',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? CircularProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('T'),
              backgroundColor: Color(0xFF4d426c),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Job title",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Text('D'),
              backgroundColor: Color(0xFF4d426c),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Job Description",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Text('C'),
              backgroundColor: Color(0xFF4d426c),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: contactController,
                decoration: InputDecoration(
                  hintText: "Contact",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Color(0xFF4d426c),
              size: 35.0,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Location",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                "Use current location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: getUserLocation,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  getUserLocation() async {
    Position positon = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(positon.latitude, positon.longitude);
    Placemark placemark = placemarks[0];
    String formatedAdress = "${placemark.locality},${placemark.subLocality}";
    locationController.text = formatedAdress;
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
    // return Center(
    //   child: Scaffold(
    //     backgroundColor: Color(0xFFeea984),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         _showDialog(context);
    //       },
    //       child: Icon(Icons.add),
    //     ),
    //     body: StreamBuilder(
    //         stream: firestoreDb,
    //         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    //           if (!streamSnapshot.hasData) {
    //             return CircularProgressIndicator();
    //           }
    //           return ListView.builder(
    //               itemCount: streamSnapshot.data.docs.length,
    //               itemBuilder: (context, int index) {
    //                 // return Text(streamSnapshot.data.docs[index]['name']);
    //                 return CustomCard(
    //                     streamSnapshot: streamSnapshot.data, index: index);
    //               });
    //         }),
    //   ),
    // );
  }

// _showDialog(BuildContext context) async {
//   final _userID =
//       FirebaseAuth.instance.currentUser.getIdToken(true).toString();
//
//   await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.all(10.0),
//           content: Column(
//             children: [
//               Text('Please enter the details'),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Name')),
//                   controller: nameInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Job title')),
//                   controller: titleInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Job description')),
//                   controller: descriptionInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Place')),
//                   controller: locationInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Experiance')),
//                   controller: experianceInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(labelText: ('Availablity')),
//                   controller: availablityInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration: InputDecoration(
//                       labelText: ('Enter your mobile number')),
//                   controller: contactInputController,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   autofocus: true,
//                   autocorrect: true,
//                   decoration:
//                       InputDecoration(labelText: ('Expected wage(per day)')),
//                   controller: wageInputController,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             FlatButton(
//               onPressed: () {
//                 nameInputController.clear();
//                 titleInputController.clear();
//                 descriptionInputController.clear();
//                 locationInputController.clear();
//                 experianceInputController.clear();
//                 availablityInputController.clear();
//                 wageInputController.clear();
//                 contactInputController.clear();
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             FlatButton(
//               onPressed: () {
//                 if (nameInputController.text.isNotEmpty &&
//                     titleInputController.text.isNotEmpty &&
//                     descriptionInputController.text.isNotEmpty &&
//                     locationInputController.text.isNotEmpty &&
//                     experianceInputController.text.isNotEmpty &&
//                     availablityInputController.text.isNotEmpty &&
//                     wageInputController.text.isNotEmpty &&
//                     contactInputController.text.isNotEmpty) {
//                   // ignore: unnecessary_statements
//                   FirebaseFirestore.instance.collection("post").add({
//                     "name": nameInputController.text,
//                     "title": titleInputController.text,
//                     "description": descriptionInputController.text,
//                     "location": locationInputController.text,
//                     "experiance": experianceInputController.text,
//                     "availablity": availablityInputController.text,
//                     "wage": wageInputController.text,
//                     "contact": contactInputController.text,
//                     "timestamp": new DateTime.now()
//                   }).then((value) {
//                     Navigator.pop(context);
//                     nameInputController.clear();
//                     titleInputController.clear();
//                     descriptionInputController.clear();
//                     locationInputController.clear();
//                     experianceInputController.clear();
//                     availablityInputController.clear();
//                     wageInputController.clear();
//                     contactInputController.clear();
//                   }).catchError((Error) => print(Error));
//                 }
//               },
//               child: Text('Save'),
//             )
//           ],
//         );
//       });
// }
}
