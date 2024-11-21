import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/screens/screens.dart';
import 'package:flutter_login/flutter_login.dart';
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
      theme: LoginTheme(
        titleStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        pageColorDark: Colors.blue,
        pageColorLight: Colors.blue.shade300,
      ),
      logo: const AssetImage('assets/images/hamburger.png'),
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
          return "Please must be at least 5 chars";
        }
        return null;
      },
      onSubmitAnimationCompleted: () {
        // Navigator.of(context).pushReplacementNamed(ChatListScreen.routeName);
                Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Dashboard(),
            ));

      },
      
      onRecoverPassword: (_) async => null,
    );
  }
}
