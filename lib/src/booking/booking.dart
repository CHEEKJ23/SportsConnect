import 'package:flutter/material.dart';
import 'package:your_project/shared/buttons.dart'; // Adjust the import path as necessary
import 'package:your_project/shared/input_fields.dart'; // Adjust the import path as necessary

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedSport;
  String location = '';
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> sports = ['Tennis', 'Soccer', 'Basketball'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Sport'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Custom dropdown for selecting sport type
            CustomDropdown(
              value: selectedSport,
              hint: 'Select Sport',
              onChanged: (value) {
                setState(() {
                  selectedSport = value;
                });
              },
              items: sports,
            ),
            SizedBox(height: 16.0),
            // Custom input field for location
            CustomInputField(
              labelText: 'Location',
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Custom button for date picker
            CustomButton(
              text: selectedDate == null
                  ? 'Select Date'
                  : selectedDate!.toLocal().toString().split(' ')[0],
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            // Custom button for start time picker
            CustomButton(
              text: startTime == null
                  ? 'Select Start Time'
                  : startTime!.format(context),
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    startTime = pickedTime;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            // Custom button for end time picker
            CustomButton(
              text: endTime == null
                  ? 'Select End Time'
                  : endTime!.format(context),
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    endTime = pickedTime;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}