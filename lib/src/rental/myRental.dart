import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../booking/myBooking.dart' as myBooking; //side bar drawer is here
import 'rentalCountdown.dart' ;
class MyRentalsPage extends StatefulWidget {
  @override
  _MyRentalsPageState createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  List<dynamic> rentals = [];

  @override
  void initState() {
    super.initState();
    fetchRentals();
  }

  Future<void> fetchRentals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      // Handle missing token, e.g., redirect to login
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/equipment-rental/my-rentals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          rentals = responseData['rentals'];
        });
      } else {
        // Handle unexpected response structure
        print('Unexpected response format');
      }
    } else {
      // Handle error
      print('Failed to load rentals');
    }
  }

  Future<void> sendReturnRequest(String rentalId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found. Please log in again.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/rentals/return-request'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rentalID': rentalId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Return request sent successfully.')),
        );
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage = responseData['message'] ?? 'Failed to send return request.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Separate rentals into ongoing and completed
    List<dynamic> ongoingRentals = rentals.where((rental) {
      DateTime rentalEndTime = DateTime.parse("${rental['date']} ${rental['endTime']}");
      return rentalEndTime.isAfter(now);
    }).toList();

    List<dynamic> completedRentals = rentals.where((rental) {
      DateTime rentalEndTime = DateTime.parse("${rental['date']} ${rental['endTime']}");
      return rentalEndTime.isBefore(now);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Rentals"),
      ),
      drawer: const myBooking.NavigationDrawer(),
      body: rentals.isEmpty
          ? Center(
              child: Text(
                "No rentals made",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : ListView(
              children: [
                // Ongoing Rentals
                if (ongoingRentals.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ongoing Rentals',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...ongoingRentals.map((rental) => RentalCard(rental: rental, isOngoing: true,onReturn: sendReturnRequest)).toList(),
                ],

                // Divider for History
                if (completedRentals.isNotEmpty) ...[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Rental History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...completedRentals.map((rental) => RentalCard(rental: rental, isOngoing: true, onReturn: sendReturnRequest)).toList(),
                ],
              ],
            ),
    );
  }
}

class RentalCard extends StatelessWidget {
 final Map<String, dynamic> rental;
  final bool isOngoing;
  final Function(String)? onReturn;

  const RentalCard({Key? key, required this.rental, required this.isOngoing, required this.onReturn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  rental['rentalStatus'] == 'ongoing'
                      ? Icons.timelapse
                      : Icons.check_circle,
                  color: rental['rentalStatus'] == 'ongoing'
                      ? Colors.blue
                      : Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  rental['equipment_name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Sport Center: ${rental['sport_center_name']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Date: ${rental['date']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Time: ${rental['startTime']} - ${rental['endTime']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Quantity: ${rental['quantity_rented']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            if (isOngoing) ...[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                     Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => RentalCountdown(rentalDate: rental['date'], startTime: rental['startTime'], endTime: rental['endTime'])), 
 );
                    },
                    child: Text("View Countdown"),
                  ),
                  SizedBox(width: 8),
                 ElevatedButton(
                onPressed: () {
                  if (onReturn != null) {
                    onReturn!(rental['rentalID'].toString()); 
                  }
                },

                child: Text("Return"),
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