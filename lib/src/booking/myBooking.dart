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
import '../booking/myBooking.dart' as myBooking; //side bar drawer is here
import '../booking/testNotification.dart';
import '../booking/testNotifyButton.dart';
import '../rental/myRental.dart';
import '../deals/myDeal.dart';
import '../booking/updateBooking.dart';//side bar drawer is here
import '../activity/myActivity.dart';
import '../Feedback/feedback.dart';
import '../Feedback/viewFeedback.dart';
import '../reward/reward.dart';
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
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(),
                ),
              );
            },
          ),
          const Divider(color: Colors.black26),
          ListTile(
            leading: Icon(Icons.notification_important),
            title: const Text('Test Notification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => testNotifyButton()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: const Text('My Activity'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserActivitiesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: const Text('My Deals'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyDealsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book_online),
            title: const Text('Booking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.car_rental),
            title: const Text('Rental'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyRentalsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: const Text('Feedback'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Choose an option'),
                    content: Text('Would you like to send feedback or view feedbacks?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Send Feedback'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FeedbackPage()),
                          );
                        },
                      ),
                      TextButton(
                        child: Text('View Feedbacks'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FeedbackListPage()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: const Text('Rewards'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RewardScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
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
  final now = DateTime.now();

  // Separate bookings into upcoming and completed
  List<dynamic> upcomingBookings = bookings.where((booking) {
    DateTime bookingEndTime = DateTime.parse("${booking['date']} ${booking['endTime']}");
    return bookingEndTime.isAfter(now);
  }).toList();

  List<dynamic> completedBookings = bookings.where((booking) {
    DateTime bookingEndTime = DateTime.parse("${booking['date']} ${booking['endTime']}");
    return bookingEndTime.isBefore(now);
  }).toList();

  return Scaffold(
    drawer: myBooking.NavigationDrawer(),
    appBar: AppBar(
      title: Text('My Bookings'),
    ),
   body: bookings.isEmpty
        ? Center(
            child: Text(
              "No booking made",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          )
          : ListView(
      children: [
        // Upcoming Bookings
        if (upcomingBookings.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...upcomingBookings.map((booking) => _buildBookingCard(booking, isUpcoming: true)).toList(),
        ],

        // Divider for History
        if (completedBookings.isNotEmpty) ...[
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...completedBookings.map((booking) => _buildBookingCard(booking, isUpcoming: false)).toList(),
        ],
      ],
    ),
  );
}

// Helper method to build a booking card
Widget _buildBookingCard(dynamic booking, {required bool isUpcoming}) {
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
          if (isUpcoming) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                     Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BookingCountdown(
  bookingDate: booking['date'], 
  startTime: booking['startTime'], 
  endTime: booking['endTime'],
),
            ));
                  },
                  child: Icon(Icons.access_time_sharp),
                ),
                ElevatedButton(
                   onPressed: () {
                    // Navigate to UpdateBookingPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateBookingPage(
                          bookingId: booking['id'],
                          initialDate: DateTime.parse(booking['date']),
                          initialStartTime: TimeOfDay(
                            hour: int.parse(booking['startTime'].split(':')[0]),
                            minute: int.parse(booking['startTime'].split(':')[1]),
                          ),
                          initialEndTime: TimeOfDay(
                            hour: int.parse(booking['endTime'].split(':')[0]),
                            minute: int.parse(booking['endTime'].split(':')[1]),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.edit),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic for the third button here
                  },
                  child: Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
}
