import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/src/screens/dashboard.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  static const routeName = "guest";

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GuestCubit>();

    return FlutterLogin(
      scrollable: true,
      hideForgotPasswordButton: true,
      title: 'SportsConnect',
      logo: const AssetImage('assets/images/newLogo.png'),
      theme: LoginTheme(
        logoWidth: 0.9, 
        pageColorDark: Colors.red,
        pageColorLight: Colors.red.shade300,
        titleStyle: TextStyle(
      color: Colors.black, 
      fontSize: 30.0, 
      fontWeight: FontWeight.bold, 
      fontFamily: 'Poppins', 
    ),
      ),
      onLogin: cubit.signIn,
      onSignup: cubit.signUp,
      userValidator: (value) {
        if (value == null || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.length < 5) {
          return "Password must be at least 5 characters";
        }
        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      },
      onRecoverPassword: (_) async => null,
    );
  }
}
