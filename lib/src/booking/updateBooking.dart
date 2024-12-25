import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/src/booking/myBooking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/utils/dio_client/dio_client.dart';

class UpdateBookingPage extends StatefulWidget {
  final int bookingId;
  final DateTime initialDate;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;

  UpdateBookingPage({
    required this.bookingId,
    required this.initialDate,
    required this.initialStartTime,
    required this.initialEndTime,
  });

  @override
  _UpdateBookingPageState createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    startTime = widget.initialStartTime;
    endTime = widget.initialEndTime;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

Future<void> _selectTime(BuildContext context, bool isStartTime) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: isStartTime ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
  );
  if (pickedTime != null) {
    setState(() {
      // Adjust minutes to 00 or 30
      int adjustedMinutes = (pickedTime.minute < 15 || pickedTime.minute >= 45) ? 0 : 30;
      TimeOfDay adjustedTime = TimeOfDay(hour: pickedTime.hour, minute: adjustedMinutes);

      if (isStartTime) {
        startTime = adjustedTime;
      } else {
        endTime = adjustedTime;
      }
    });
  }
}

  Future<void> _updateBooking() async {
     final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    final url = Uri.parse('$baseUrl/api/modifyBookings/${widget.bookingId}');
       final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken'); 
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Replace with actual token
      },
      body: jsonEncode({
        'date': selectedDate?.toIso8601String(),
        'startTime': '${startTime?.hour}:${startTime?.minute}',
        'endTime': '${endTime?.hour}:${endTime?.minute}',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    
             
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsPage()),
              );
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Date: ${selectedDate?.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Start Time: ${startTime?.format(context) ?? '--:--'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text('End Time: ${endTime?.format(context) ?? '--:--'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBooking,
              child: Text('Update Booking'),
            ),
          ],
        ),
      ),
    );
  }
}