// import 'package:flutter/material.dart';
// import 'package:shop/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shopping App',
//       theme: ThemeData(
//         fontFamily: 'Lato',
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromRGBO(254, 206, 1, 1),
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'src/screens/signin_page.dart';
import 'src/screens/singup_page.dart';
import 'src/screens/welcome_page.dart';
import 'src/screens/dashboard.dart';
import 'src/screens/product_page.dart';
import 'src/shared/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fryo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WelcomePage(pageTitle: 'Welcome'),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => SignUpPage(),
        '/signin': (BuildContext context) => SignInPage(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/productPage': (BuildContext context) => ProductPage(
              productData: Product(),
            ),
      },
    );
  }
}