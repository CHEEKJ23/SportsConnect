import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../booking/booking2.dart';
import '../shared/buttons.dart';
import '../shared/input_fields.dart';
import 'package:page_transition/page_transition.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../rental/rental2.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'rental2.dart'; // Ensure this import points to the file where EquipmentList is defined
import 'package:shop/utils/dio_client/dio_client.dart';

class RentalPage extends StatefulWidget {
  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  String? selectedEquipment;
  String location = '';
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<dynamic> sportsCenters = [];
  List<dynamic> availableEquipment = [];
  String? selectedSportCenter;
  int? selectedSportCenterId;

  Future<void> fetchSportsCenters(String location) async {
      final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    final url = Uri.parse('$baseUrl/api/equipment-rental/get-sports-centers?location=$location');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sportsCenters = data;
        });
      } else {
        print('Error: ${response.body}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch sports centers.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> checkAvailability() async {
      final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    final url = Uri.parse('$baseUrl/api/equipment-rental/check-availability');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formattedDate = selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : null;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'sport_center_name': selectedSportCenter,
          'equipment_name': selectedEquipment,
          'date': formattedDate,
          'startTime': '${startTime?.hour}:${startTime?.minute}',
          'endTime': '${endTime?.hour}:${endTime?.minute}',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          availableEquipment = data['available_equipment'];
        });

        final rentalDetails = {
          'sport_center_id': selectedSportCenterId,
          'date': formattedDate,
          'startTime': '${startTime?.hour}:${startTime?.minute}',
          'endTime': '${endTime?.hour}:${endTime?.minute}',
        };

        // Navigate to EquipmentList with available equipment and rental details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EquipmentList(
              availableEquipment: availableEquipment,
              rentalDetails: rentalDetails,
            ),
          ),
        );
      } else {
     print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Request URL: $url');
      print('Request Headers: ${response.request?.headers}');
    

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check availability.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Equipment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            fryoTextInput(
              'Equipment',
              onChanged: (value) {
                setState(() {
                  selectedEquipment = value;
                });
              },
            ),
            fryoTextInput(
              'Location',
              onChanged: (value) {
                setState(() {
                  location = value;
                });
                if (value.isNotEmpty) {
                  fetchSportsCenters(value);
                } else {
                  setState(() {
                    sportsCenters = [];
                  });
                }
              },
            ),
            if (sportsCenters.isNotEmpty)
              DropdownButton<String>(
                hint: Text('Select Sport Center'),
                value: selectedSportCenter,
                onChanged: (value) {
                  setState(() {
                    selectedSportCenter = value;
                    selectedSportCenterId = sportsCenters.firstWhere(
                      (center) => center['name'] == value,
                      orElse: () => {'id': null},
                    )['id'];
                  });
                },
                items: sportsCenters.map<DropdownMenuItem<String>>((center) {
                  return DropdownMenuItem<String>(
                    value: center['name'],
                    child: Text(center['name']),
                  );
                }).toList(),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
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
                  },
                  child: Text('Pick a Date'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    startTime == null
                        ? 'Select Start Time'
                        : 'Start Time: ${startTime!.format(context)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != startTime) {
                      setState(() {

                        int adjustedMinutes = (pickedTime.minute < 15 || pickedTime.minute >= 45) ? 0 : 30;
                        startTime = TimeOfDay(hour: pickedTime.hour, minute: adjustedMinutes);
                      });
                    }
                  },
                  child: Text('Pick Start Time'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    endTime == null
                        ? 'Select End Time'
                        : 'End Time: ${endTime!.format(context)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != endTime) {
                      setState(() {
                        // Adjust the minutes to either 00 or 30 based on the picked time
                        int adjustedMinutes = (pickedTime.minute < 15 || pickedTime.minute >= 45) ? 0 : 30;
                        endTime = TimeOfDay(hour: pickedTime.hour, minute: adjustedMinutes);
                      });
                    }
                  },
                  child: Text('Pick End Time'),
                ),
              ],
            ),
          
              SizedBox(height: 16,),
                Row(children: [
          Text(
      "Note: The system will only accept times at 00 or 30 minutes.",
      style: TextStyle(fontSize: 13, color: Colors.grey),
),
        ],),
              SizedBox(height: 10,),

            ElevatedButton(
              onPressed: checkAvailability,
              child: Text('Check Availability'),
            ),
          ],
        ),
      ),
    );
  }
    TimeOfDay _adjustMinutes(TimeOfDay time) {
    int adjustedMinutes = (time.minute < 15 || time.minute >= 45) ? 0 : 30;
    return TimeOfDay(hour: time.hour, minute: adjustedMinutes);
  }
}