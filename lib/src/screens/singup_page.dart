import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/input_fields.dart';
import './signin_page.dart';
import './dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          title: const Text('Sign Up',
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed('/signin');
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    alignment: Alignment.center,
                    type: PageTransitionType.rightToLeft,
                    child: SignInPage(),
                  ),
                );
              },
              child: const Text('Sign In', style: contrastText),
            )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 18, right: 18),
              height: 360,
              width: double.infinity,
              decoration: authPlateDecoration,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Welcome to Fryo!', style: h3),
                      const Text('Let\'s get started', style: taglineText),
                      fryoTextInput('Username'),
                      fryoTextInput('Full Name'),
                      fryoEmailInput('Email Address'),
                      fryoPasswordInput('Password')
                    ],
                  ),
                  Positioned(
                    bottom: 15,
                    right: -15,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            alignment: Alignment.center,
                            type: PageTransitionType.rightToLeft,
                            child: Dashboard(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.all(13),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.arrow_forward, color: white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
