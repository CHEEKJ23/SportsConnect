import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/src/booking/myBooking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/utils/dio_client/dio_client.dart';
import 'package:shop/src/booking/booking3.dart';
class UpdateBookingPage extends StatefulWidget {
  final int bookingId;
  final DateTime initialDate;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final int initialCourtId; 
  final int sportCenterId;
  final String selectedSport;


  UpdateBookingPage({
    required this.bookingId,
    required this.initialDate,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.initialCourtId, 
    required this.sportCenterId,
    required this.selectedSport,
  });

  @override
  _UpdateBookingPageState createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? selectedCourtId; // New field for selected court ID

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    startTime = widget.initialStartTime;
    endTime = widget.initialEndTime;
    selectedCourtId = widget.initialCourtId; // Initialize new field
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
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
    final url = Uri.parse('$baseUrl:8000/api/modifyBookings/${widget.bookingId}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': selectedDate?.toIso8601String(),
        'startTime': '${startTime?.hour}:${startTime?.minute}',
        'endTime': '${endTime?.hour}:${endTime?.minute}',
        'court_id': selectedCourtId, // Include court ID in the request
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





Future<List<Map<String, dynamic>>> fetchAvailableCourts({
  required int sportCenterId,
  required String selectedSport,
  required DateTime selectedDate,
  required String startTime,
  required String endTime,
}) async {
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
   final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final url = Uri.parse('$baseUrl:8000/api/sport-center/$sportCenterId/available-courts');
  print('Debug: Request URL: $url'); // Print the URL for debugging

 print('Debug: Fetching available courts with parameters:');
  print('Sport Center ID: $sportCenterId');
  print('Selected Sport: $selectedSport');
  print('Selected Date: ${selectedDate.toIso8601String()}');
  print('Start Time: $startTime');
  print('End Time: $endTime');
  try {
    final response = await http.post(
  url,
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', 
  },
  body: jsonEncode({
    'sportType': selectedSport,
    'date': selectedDate.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
  }),
);

   if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      // Check if the response is a list or a single object
      if (data is List) {
        return data.map((court) => {
          'id': court['id'] as int,
           'number': court['number'].toString(), 
        }).toList();
      } else if (data is Map) {
        // If it's a single object, wrap it in a list
        return [{
          'id': data['id'] as int,
          'number': data['number'].toString(), 
        }];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      print('Debug: Failed to load available courts, status code: ${response.statusCode}');
      print('Debug: Response body: ${response.body}');
      throw Exception('Failed to load available courts');
    }
  } catch (e) {
    print('Error fetching available courts: $e');
    return [];
  }
}

void _showCourtSelectionDialog(List<Map<String, dynamic>> availableCourts) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Court'),
        content: SingleChildScrollView(
          child: ListBody(
            children: availableCourts.map((court) {
              return ListTile(
                title: Text('Court Number: ${court['number']}'),
                onTap: () {
                  setState(() {
                    selectedCourtId = court['id'];
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
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
            // New ListTile for selecting court
            ListTile(
              title: Text('Court: $selectedCourtId'),
              trailing: Icon(Icons.sports_tennis),
             onTap: () async {
  if (selectedDate != null && startTime != null && endTime != null) {
    // Assuming fetchAvailableCourts is a method in a class, you might need to create an instance
    // If it's a standalone function, you can call it directly
    final availableCourts = await fetchAvailableCourts(
      sportCenterId: widget.sportCenterId, // Pass necessary parameters
      selectedSport: widget.selectedSport,
      selectedDate: selectedDate!,
      startTime: '${startTime!.hour}:${startTime!.minute}',
      endTime: '${endTime!.hour}:${endTime!.minute}',
    );

    if (availableCourts.isNotEmpty) {
      _showCourtSelectionDialog(availableCourts);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No courts available for the selected time.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select date and time first.')),
    );
  }
},
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