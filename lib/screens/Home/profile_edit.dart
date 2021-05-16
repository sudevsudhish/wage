import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wage/screens/Home/main_drawer.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFeea984),
        appBar: AppBar(
          title: Text(
            'PROFILE',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Color(0xFF4d426c),
        ),
        drawer: MainDrawer(),
        body: Container());
  }
}
