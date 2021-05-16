import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wage/screens/Home/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wage/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wage/screens/Home/search.dart';
import 'package:wage/screens/Home/Notification.dart';
import 'package:wage/screens/Home/postJob.dart';
import 'package:wage/screens/Home/profile.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final postRef = FirebaseFirestore.instance.collection('posts');
final DateTime timestamp = DateTime.now();
final storageRef = FirebaseStorage.instance.ref();
final userDetails = FirebaseFirestore.instance.collection("users");

//Home page controller
class HomePage extends StatefulWidget {
  Userr currentUser = Userr();
  static String id = 'HomePage';
  final _auth = FirebaseAuth.instance;
  final _userID = FirebaseAuth.instance.currentUser.getIdToken(true);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    Search(),
    PostJob(),
    Notifications(),
    Profile(),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeea984),
      body: Container(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Color(0xff2F2440),
        inactiveColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            // ignore: deprecated_member_use
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              size: 30,
            ),
            title: Text(
              'Post',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active_outlined,
              size: 30,
            ),
            title: Text(
              'Notification',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
            title: Text(
              'Profile',
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}

//Home page view
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Userr currentUser = Userr();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('HOME'),
        backgroundColor: Color(0xFF4d426c),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('$currentUser'),
      ),
    );
  }
}

// class CustomCard extends StatelessWidget {
//   final QuerySnapshot streamSnapshot;
//   final int index;
//
//   const CustomCard({Key key, this.streamSnapshot, this.index})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var snapshot = streamSnapshot.docs[index];
//     var docID = streamSnapshot.docs[index].id;
//
//     TextEditingController nameInputController =
//         TextEditingController(text: snapshot.get('name'));
//     TextEditingController titleInputController =
//         TextEditingController(text: snapshot.get('title'));
//     TextEditingController wageInputController =
//         TextEditingController(text: snapshot.get('wage'));
//     TextEditingController locationInputController =
//         TextEditingController(text: snapshot.get('location'));
//     TextEditingController experianceInputController =
//         TextEditingController(text: snapshot.get('experiance'));
//     TextEditingController descriptionInputController =
//         TextEditingController(text: snapshot.get('description'));
//     TextEditingController availablityInputController =
//         TextEditingController(text: snapshot.get('availablity'));
//     TextEditingController contactInputController =
//         TextEditingController(text: snapshot.get('contact'));
//
//     return Column(
//       children: [
//         Container(
//           child: Card(
//             elevation: 12,
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text(
//                     snapshot.get('title').toString().toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   subtitle: Text(
//                     snapshot.get('description'),
//                     style: TextStyle(
//                       fontSize: 18.0,
//                     ),
//                   ),
//                   leading: CircleAvatar(
//                     radius: 34,
//                     child:
//                         Text(snapshot.get('title').toString()[0].toUpperCase()),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       'Name:',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     Text(
//                       snapshot.get('name'),
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on),
//                     Text(
//                       snapshot.get('location'),
//                       style: TextStyle(
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                         icon: Icon(Icons.edit),
//                         onPressed: () async {
//                           await showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   contentPadding: EdgeInsets.all(10.0),
//                                   content: Column(
//                                     children: [
//                                       Text('Update the details'),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Name')),
//                                           controller: nameInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Job title')),
//                                           controller: titleInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Job description')),
//                                           controller:
//                                               descriptionInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Place')),
//                                           controller: locationInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Experiance')),
//                                           controller: experianceInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText: ('Availablity')),
//                                           controller:
//                                               availablityInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText:
//                                                   ('Enter your mobile number')),
//                                           controller: contactInputController,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           autofocus: true,
//                                           autocorrect: true,
//                                           decoration: InputDecoration(
//                                               labelText:
//                                                   ('Expected wage(per day)')),
//                                           controller: wageInputController,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   actions: [
//                                     FlatButton(
//                                       onPressed: () {
//                                         nameInputController.clear();
//                                         titleInputController.clear();
//                                         descriptionInputController.clear();
//                                         locationInputController.clear();
//                                         experianceInputController.clear();
//                                         availablityInputController.clear();
//                                         wageInputController.clear();
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text('Cancel'),
//                                     ),
//                                     FlatButton(
//                                       onPressed: () {
//                                         if (nameInputController
//                                                 .text.isNotEmpty &&
//                                             titleInputController
//                                                 .text.isNotEmpty &&
//                                             descriptionInputController
//                                                 .text.isNotEmpty &&
//                                             locationInputController
//                                                 .text.isNotEmpty &&
//                                             experianceInputController
//                                                 .text.isNotEmpty &&
//                                             availablityInputController
//                                                 .text.isNotEmpty &&
//                                             wageInputController
//                                                 .text.isNotEmpty) {
//                                           FirebaseFirestore.instance
//                                               .collection('post')
//                                               .doc(docID)
//                                               .update({
//                                             "name": nameInputController.text,
//                                             "title": titleInputController.text,
//                                             "description":
//                                                 descriptionInputController.text,
//                                             "location":
//                                                 locationInputController.text,
//                                             "experiance":
//                                                 experianceInputController.text,
//                                             "availablity":
//                                                 availablityInputController.text,
//                                             "wage": wageInputController.text,
//                                             "timestamp": new DateTime.now()
//                                           }).then((value) =>
//                                                   Navigator.pop(context));
//                                         }
//                                       },
//                                       child: Text('Update'),
//                                     )
//                                   ],
//                                 );
//                               });
//                         }),
//                     IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           _deletepost(context);
//                         })
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   _deletepost(BuildContext context) async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             height: 50.0,
//             child: AlertDialog(
//                 contentPadding: EdgeInsets.all(10.0),
//                 content: Column(
//                   children: [
//                     Text(
//                       'Are you sure to delete the post?',
//                       style: TextStyle(
//                         fontSize: 30,
//                       ),
//                     ),
//                     RoundButton(
//                       title: 'Delete',
//                       color: Colors.red,
//                       onPressed: () async {
//                         await FirebaseFirestore.instance
//                             .collection('post')
//                             .doc(streamSnapshot.docs[index].id)
//                             .delete();
//                         Navigator.pop(context);
//                       },
//                     ),
//                     FlatButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text('Cancel'))
//                   ],
//                 )),
//           );
//         });
//   }
// }

//custom card for displaying the jobs
// class JobCard extends StatelessWidget {
//   final QuerySnapshot streamSnapshot;
//   final int index;
//
//   const JobCard({Key key, this.streamSnapshot, this.index}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var snapshot = streamSnapshot.docs[index];
//     var docID = streamSnapshot.docs[index].id;
//
//     var timeToDate = new DateTime.fromMicrosecondsSinceEpoch(
//         snapshot.get("timestamp").seconds * 1000);
//     var dateFormated = new DateFormat("d MMM y").format(timeToDate);
//
//     TextEditingController nameInputController =
//         TextEditingController(text: snapshot.get('name'));
//     TextEditingController titleInputController =
//         TextEditingController(text: snapshot.get('title'));
//     TextEditingController wageInputController =
//         TextEditingController(text: snapshot.get('wage'));
//     TextEditingController locationInputController =
//         TextEditingController(text: snapshot.get('location'));
//     TextEditingController experianceInputController =
//         TextEditingController(text: snapshot.get('experiance'));
//     TextEditingController descriptionInputController =
//         TextEditingController(text: snapshot.get('description'));
//     TextEditingController availablityInputController =
//         TextEditingController(text: snapshot.get('availablity'));
//
//     return Column(
//       children: [
//         Container(
//           height: 170,
//           child: Card(
//             elevation: 12,
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text(snapshot.get('title')),
//                   subtitle: Text(snapshot.get('description')),
//                   leading: CircleAvatar(
//                     radius: 34,
//                     child:
//                         Text(snapshot.get('title').toString()[0].toUpperCase()),
//                   ),
//                 ),
//                 Row(
//                   children: [Text('Name :'), Text(snapshot.get('name'))],
//                 ),
//                 Expanded(
//                   child: RoundButton(
//                     onPressed: () {
//                       return showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               backgroundColor: Color(0xFFeea984),
//                               content: Column(
//                                 children: [
//                                   Column(children: [
//                                     Text(
//                                       'Name',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot
//                                           .get('name')
//                                           .toString()
//                                           .toUpperCase(),
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(children: [
//                                     Text(
//                                       'Job name',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.get('title'),
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Job description',
//                                           overflow: TextOverflow.visible,
//                                           style: TextStyle(
//                                             decoration:
//                                                 TextDecoration.underline,
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                         Text(
//                                           snapshot.get('description'),
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                           ),
//                                         )
//                                       ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(children: [
//                                     Text(
//                                       'Experiance',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.get('experiance'),
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(children: [
//                                     Text(
//                                       'Place',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.get('location'),
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(children: [
//                                     Text(
//                                       'Availablity',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.get('availablity'),
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Column(children: [
//                                     Text(
//                                       'Expected wage',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       '\u{20B9}${snapshot.get('wage')} (per day)',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     )
//                                   ]),
//                                   SizedBox(
//                                     height: 20.0,
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.black),
//                                       color: Colors.white,
//                                     ),
//                                     child: Center(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'Contact',
//                                             style: TextStyle(
//                                                 fontSize: 26,
//                                                 color: Colors.green),
//                                           ),
//                                           Text(
//                                             snapshot.get('contact'),
//                                             style: TextStyle(
//                                               fontSize: 24,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             );
//                           });
//                     },
//                     title: 'View post',
//                     color: Colors.green,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//profile view

// import 'package:flutter/material.dart';
// import 'package:wage/screens/Home/profile.dart';
// import 'package:wage/screens/Home/search.dart';
// import 'package:wage/screens/Home/postJob.dart';
// import 'package:wage/screens/Home/Notification.dart';
//
// PageController pageController;
//
// class HomePage extends StatefulWidget {
//
//   void initState(){
//
//   }
//
//   static String id = 'HomePage';
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         children: [HomeView(), Search(), Upload(), Notifications(), Profile()],
//         controller: pageController,
//       ),
//     );
//   }
// }
//
// class HomeView extends StatefulWidget {
//   @override
//   _HomeViewState createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
