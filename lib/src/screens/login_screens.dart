import 'dart:convert';
import './welcome_page.dart';
import './dashboard.dart';
import 'package:flutter/material.dart';
import '../services/globals.dart';
import '../services/auth_services.dart';
import '../shared/rounded_button.dart';
import '../shared/input_fields.dart';
import 'package:http/http.dart' as http;
import '../shared/buttons.dart';
import '../shared/colors.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Dashboard(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black), // Use an appropriate icon
     onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    },
  ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              fryoEmailInput('Enter your Email',
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              fryoEmailInput( 'Enter your password',
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),

              RoundedButton(
                btnText: 'LOG IN',
                onBtnPressed: () => loginPressed(),
              )
            ],
          ),
        ));
  }
}