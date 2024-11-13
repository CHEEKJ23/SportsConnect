import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/buttons.dart';
// import './singup_page.dart';
// import './signin_page.dart';
import './login_screens.dart';
import './register_screen.dart';
import './dashboard.dart';



class WelcomePage extends StatefulWidget {
  // final String pageTitle;

  // const WelcomePage({super.key, required this.pageTitle});
  const WelcomePage({Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/welcome.png', width: 190, height: 190),
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 0),
            child: const Text('SportsConnect!', style: logoStyle),
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(bottom: 0),
            child: froyoTextBtn('Sign In', () {
              // Navigator.pushReplacement(
              //     context,
              //     PageTransition(
              //         alignment: Alignment.center,
              //         type: PageTransitionType.rotate,
              //         duration: const Duration(seconds: 1),
              //         child: LoginScreen()
              //         ));
            }),
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.all(0),
            child: froyoOutlinedBtn('Sign Up', () {
              // Navigator.pushReplacement(
              //     context,
              //     PageTransition(
              //         alignment: Alignment.center,
              //         type: PageTransitionType.rotate,
              //         duration: const Duration(seconds: 1),
              //         child: RegisterScreen()));
              // Navigator.of(context).pushReplacementNamed('/signup');
            }),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Not choosing language here', style: TextStyle(color: darkText)),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: const Text('SKR',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
           Container(
            width: 200,
            margin: const EdgeInsets.only(bottom: 0),
            child: froyoTextBtn('shortcut', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      alignment: Alignment.center,
                      type: PageTransitionType.rotate,
                      duration: const Duration(seconds: 1),
                      child: Dashboard()));
            }),
          ),
        ],
      )),
      backgroundColor: bgColor,
    );
  }
}
