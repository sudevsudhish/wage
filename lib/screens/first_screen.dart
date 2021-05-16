import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:wage/screens/custom_dialog.dart';
import 'package:wage/screens/welcome_screen.dart';

class FirstView extends StatelessWidget {
  static String id = 'First_Screen';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xff2F2440), Color(0xFF7D7098)],
          ),
        ),
        width: width,
        height: height,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Hero(
                tag: 'icon',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(),
                  ),
                  height: 150.0,
                  child: Image.asset('images/logo.png', scale: 1.0),
                ),
              ),
              AutoSizeText(
                "Welcome",
                style: TextStyle(
                  fontSize: 44,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                "Let\'s find a required worker",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white54,
                ),
              ),
              Container(
                child: Image.asset('images/gear.png', scale: 4.0),
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                        title: 'Let\'s create a wage account',
                        description:
                            "For creating this account you will need an valid google account",
                        primaryButtonRoute: 'SignUp',
                        primaryButtonText: 'Create My Account',
                        secondaryButtonRoute: 'Home',
                        secondaryButtonText: 'Maybe Later'),
                  );
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, right: 30.0, left: 30.0),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Color(0xFF4d426c),
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
