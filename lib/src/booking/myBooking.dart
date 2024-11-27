import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/blocs/blocs.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/screens/screens.dart';
import 'package:shop/screens/guest/guest_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/src/booking/bookingCountdown.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';


// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyBookingsPage(),
//     );
//   }
// }
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer( // Removed 'const' here
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
  Widget buildHeader(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final currentUser = authBloc.state.user!;

    return InkWell(
       onTap: (){
              Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            ));
            },
      child: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.only(
          top:24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage('https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg'),
            ),
            SizedBox(height: 12),
            Text(
              "${currentUser.name}", 
              style: TextStyle(fontSize: 28,color: Colors.black),
            ),
            Text(
              "${currentUser.email}", 
              style: TextStyle(fontSize: 16, color:Colors.black),
            )
          ],
        ),
      ),
    );
  }
    Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            ));
            },
          ),
          const Divider(color:Colors.black26),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: const Text('Favourite'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: const Text('Workflow'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.update),
            title: const Text('Update'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.book_online),
            title: const Text('Booking'),
            onTap: (){
Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => MyBookingsPage()), 
 );

            },
          ),ListTile(
            leading: Icon(Icons.car_rental),
            title: const Text('Rental'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: (){
            context.read<GuestCubit>().signOut();
             Navigator.pushReplacement(
   context,
   MaterialPageRoute(builder: (context) => GuestScreen()), 
 );
            },
          ),
        ],
      ),
    );
  }
}
class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      // Handle missing token, e.g., redirect to login
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/myBookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

     if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      setState(() {
        bookings = responseData['bookings']; // Extract the bookings list
      });
    } else {
      // Handle unexpected response structure
      print('Unexpected response format');
    }
  } else {
    // Handle error
    print('Failed to load bookings');
  }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My Bookings'),
    ),
    body: bookings.isEmpty
        ? Center(
            child: Text(
              'No bookings made.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking ID: ${booking['id']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${booking['date']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Time: ${booking['startTime']} - ${booking['endTime']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sport Center: ${booking['sport_center_name']}',
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                      Text(
                        'Sport Type: ${booking['sport_type_name']}',
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                      SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                     Navigator.pop(context);
//               Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (BuildContext context) => BookingCountdown(
//   bookingDate: booking['date'], // Pass the booking date
//   startTime: booking['startTime'], // Pass the start time
// ),
//             ));
                  },
                  child: Text('View Countdown'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic for the second button here
                  },
                  child: Text('Button 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic for the third button here
                  },
                  child: Text('Button 3'),
                ),
              ],
            ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
}
