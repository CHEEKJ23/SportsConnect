import 'package:flutter/material.dart';
import '../booking/booking2.dart'; // Replace with your actual booking page import
import '../booking/booking.dart';
import '../booking/booking4.dart';


void main() => runApp(SportsCenterApp());

class SportsCenterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SportsCenterLayout(),
    );
  }
}

class SportsCenterLayout extends StatefulWidget {
  @override
  _SportsCenterLayoutState createState() => _SportsCenterLayoutState();
}

class _SportsCenterLayoutState extends State<SportsCenterLayout> {
  // Sample data for available courts
  List<String> availableSlots = ['Court 3', 'Court 4', 'Court 6', 'Court 8', 'Court 10', 'Court 12', 'Court 13'];
  Map<String, bool> selectedSlots = {};
  String selectedDate = "2024-11-10";
  String selectedTime = "10:00 AM";
  String selectedDuration = "2 hours";

  @override
  void initState() {
    super.initState();
    // Initialize all available slots as unselected
    availableSlots.forEach((slot) => selectedSlots[slot] = false);
  }

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
              Text("Date: $selectedDate"),
              Text("Time: $selectedTime"),
              Text("Duration: $selectedDuration"),
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
                Navigator.of(context).pop(); // Close dialog and proceed
                _showConfirmationMessage(context); // Show a success message
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentApp()), // Navigate to NextPage
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
