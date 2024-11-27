import 'package:flutter/material.dart';
import '../booking/booking2.dart'; 
import '../booking/booking.dart';
import '../booking/booking4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/cubits/guest/guest_cubit.dart';
import 'package:intl/intl.dart';
import 'package:shop/src/booking/myBooking.dart';
// void main() => runApp(SportsCenterApp());

// class SportsCenterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SportsCenterApp(),
//     );
//   }
// }

class SportsCenterLayout extends StatefulWidget {
  final int sportCenterId;
  final String selectedSport;
  final String selectedDate;
  final String startTime;
  final String endTime;

    SportsCenterLayout({
    required this.sportCenterId,
    required this.selectedSport,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
  });
  @override
  _SportsCenterLayoutState createState() => _SportsCenterLayoutState();
}

class _SportsCenterLayoutState extends State<SportsCenterLayout> {
  List<String> availableSlots = [];
  Map<String, bool> selectedSlots = {};
  // // String selectedDate = "2024-11-10";
  // // String selectedTime = "10:00 AM";
  // // String selectedDuration = "2 hours";

Future<void> fetchAvailableCourts() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/sport-center/${widget.sportCenterId}/available-courts');
  
  try {
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken'); 
    
    if (token == null) {
      throw Exception('No authentication token found');
    }
    // Debugging: Print the URL and parameters
    print('Fetching available courts with:');
    print('URL: $url');
    print('sportType: ${widget.selectedSport}');
    print('date: ${widget.selectedDate}');
    print('startTime: ${widget.startTime}');
    print('endTime: ${widget.endTime}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 

      },
      body: jsonEncode({
        'sportType': widget.selectedSport,
        'date': widget.selectedDate,
        'startTime': widget.startTime,
        'endTime': widget.endTime,
      }),
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('$data'); 

      if (data is List) {

        setState(() {
          availableSlots = data.map((court) => 'Court ${court['number']} - ${court['type']}').toList();
          availableSlots.forEach((slot) => selectedSlots[slot] = false);
        });
      } else {
        print('Unexpected data format');
      }
    } else {
      print('Error: ${response.body}');
      print('Code: ${response.statusCode}');

      
    }
  } catch (error) {
    print('Error: $error');
  }
}

  @override
  void initState() {
    super.initState();
 print('Received in SportsCenterLayout:');
  print('sportCenterId: ${widget.sportCenterId}');
  print('selectedSport: ${widget.selectedSport}');
  print('selectedDate: ${widget.selectedDate}');
  print('startTime: ${widget.startTime}');
  print('endTime: ${widget.endTime}');

    fetchAvailableCourts(); 
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize all available slots as unselected
  //   availableSlots.forEach((slot) => selectedSlots[slot] = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centre Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Centre Layout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Placeholder for the centre layout image
            Image.asset(
              'assets/images/coca-cola.png', // Replace with your actual image asset path
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 32),
            Text(
              'Choose From These Available Slots',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Checkbox list for available slots
            _buildAvailableSlots(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ElevatedButton(
            //   // onPressed: () => Navigator.push(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //     builder: (BuildContext context) => SportCenterList(),
            //   //   ),
            //   // ),
            //   child: Text('Back'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () => _showConfirmationPrompt(context),
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the list of available slot checkboxes
  Widget _buildAvailableSlots() {
    return Column(
      children: availableSlots.map((String courtName) {
        return CheckboxListTile(
          title: Text(courtName),
          value: selectedSlots[courtName],
          onChanged: (bool? value) {
            setState(() {
              selectedSlots[courtName] = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

String extractCourtId(String courtString) {
  // Assuming the court string is in the format "Court {number} - {type}"
  final regex = RegExp(r'Court (\d+)');
  final match = regex.firstMatch(courtString);

  if (match != null && match.groupCount >= 1) {
    return match.group(1)!; // Return the court number as a string
  } else {
    throw Exception('Invalid court string format');
  }
}

  void _bookCourt(BuildContext context, List<String> selectedCourts) async {
    final urll = Uri.parse('http://10.0.2.2:8000/api/book-court');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final userId = prefs.getInt('userId');

    // await prefs.setInt('userId', user.id);
  //  final userId = prefs.getInt('userId');


    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication required.')),
      );
      return;
    }
//  print('Fetching available courts with:');
//     print('URL: $url');
//     print('sportType: ${widget.selectedSport}');
//     print('date: ${widget.selectedDate}');
//     print('startTime: ${widget.startTime}');
//     print('endTime: ${widget.endTime}');

    try {
      for (String court in selectedCourts) {
        final courtId = extractCourtId(court); 

        final response = await http.post(
          urll,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': userId, 
            'sport_center_id': widget.sportCenterId,
            'court_id': courtId,
            'date': widget.selectedDate,
            'startTime': widget.startTime,
            'endTime': widget.endTime,
          }),
        );
      print('Response Status Code: ${response.statusCode}');



        if (response.statusCode == 201) {

          print('Court booked successfully');
        } else {
          print('Error booking court: ${response.body}');
        }
      }
    } catch (error) {
      
      print('Error: $error');
    }
  }


  // Show confirmation prompt when "Next" button is pressed
  void _showConfirmationPrompt(BuildContext context) {
    // Get selected courts
    List<String> selectedCourts = selectedSlots.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // If no court is selected, show a warning dialog
    if (selectedCourts.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No Court Selected"),
            content: Text("Please select at least one court to proceed."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Show confirmation dialog with selected details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Booking"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to book these courts?"),
              SizedBox(height: 16),
              Text("Selected Courts: ${selectedCourts.join(', ')}"),
              Text("Date: ${widget.selectedDate}"),
              Text("Time: ${widget.startTime}-${widget.endTime}"),
              // Text("Duration: $selectedDuration"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without confirming
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _showConfirmationMessage(context); 
                  _bookCourt(context, selectedCourts);
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsPage()),
              );
            },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Optional: Show a success message after confirming
  void _showConfirmationMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Courts successfully booked!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
