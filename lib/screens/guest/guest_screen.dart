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
      logo: const AssetImage('assets/images/sportsConnectLogoLatest.png'),
      theme: LoginTheme(
        logoWidth: 200, 
        pageColorDark: Colors.blue,
        pageColorLight: Colors.blue.shade300,
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
