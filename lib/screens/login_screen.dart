import 'package:flutter/material.dart';
import 'package:wage/Components/Round_button.dart';
import 'package:wage/constrains.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wage/screens/home_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// class LoginScreen extends StatefulWidget {
//   static String id = 'login_screen';
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// final TextEditingController emailController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _auth = FirebaseAuth.instance;
//   String email;
//   String password;
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//
//   Widget buildEmail() {
//     return TextFormField(
//       controller: emailController,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Email is required';
//         }
//         if (!RegExp(
//                 r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//             .hasMatch(value)) {
//           return 'Please enter a valid email Address';
//         } else {
//           return null;
//         }
//       },
//       onSaved: (String value) {
//         email = value;
//       },
//       keyboardType: TextInputType.emailAddress,
//       decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
//     );
//   }
//
//   Widget buildPassword() {
//     return TextFormField(
//       controller: passwordController,
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Password is required';
//         } else if (value.length < 6) {
//           return 'Password must contain 6 lettors';
//         }
//       },
//       obscureText: true,
//       onSaved: (String value) {
//         password = value;
//       },
//       keyboardType: TextInputType.name,
//       decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFeea984),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Hero(
//               tag: 'icon',
//               child: Container(
//                 height: 200.0,
//                 child: Image.asset('images/Icon.png'),
//               ),
//             ),
//             SizedBox(
//               height: 48.0,
//             ),
//             Form(
//                 key: _formkey,
//                 child: Column(
//                   children: [
//                     buildEmail(),
//                     SizedBox(
//                       height: 8.0,
//                     ),
//                     buildPassword(),
//                   ],
//                 )),
//             SizedBox(
//               height: 24.0,
//             ),
//             RoundButton(
//                 title: 'Log In ',
//                 color: Color(0xFF4d426c),
//                 onPressed: () async {
//                   if (!_formkey.currentState.validate()) {
//                     return;
//                   } else {
//                     try {
//                       final user = _auth.signInWithEmailAndPassword(
//                           email: email, password: password);
//                       if (user != null) {
//                         Navigator.pushNamed(context, HomePage.id);
//                       }
//                     } catch (e) {
//                       print(e);
//                     }
//                   }
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFeea984),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/Icon.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundButton(
                    title: 'Log In',
                    color: Color(0xFF4d426c),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, HomePage.id);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
