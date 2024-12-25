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
import 'package:shop/cubits/guest/guest_cubit.dart';
import 'package:intl/intl.dart';
import 'package:shop/utils/dio_client/dio_client.dart';
class BookingPage extends StatefulWidget {
  static const routeName = "booking";

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedSport;
  String location = '';
  DateTime? selectedDate;
  TimeOfDay? startTime ;
  TimeOfDay? endTime;

Future<void> searchSportCenters() async {
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
  final url = Uri.parse('$baseUrl/api/search-sport-centers');
    // final token = '58|xAOUuy6E7jZjG7LdA9CQZepRGVGbgWSXMZAb7r8c'; 

    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer $token',
    //     },jgf
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
          'sportType': selectedSport,
          'location': location,
          'date': formattedDate,
          'startTime': '${startTime?.hour}:${startTime?.minute}',
          'endTime': '${endTime?.hour}:${endTime?.minute}',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('$data');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SportCenterList(data['sportsCenters']), 
        //   ),
        // );
        if (data is List) {
        List<Map<String, dynamic>> sportsCenters = List<Map<String, dynamic>>.from(data);

 sportsCenters = sportsCenters.map((center) {
      return {
        ...center,
        'sportType': selectedSport ?? 'Unknown Sport',
        'date': formattedDate ?? 'Unknown Date',
        'startTime': '${startTime?.hour ?? '00'}:${startTime?.minute ?? '00'}',
        'endTime': '${endTime?.hour ?? '00'}:${endTime?.minute ?? '00'}',
      };
    }).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SportCenterList(sportsCenters),
          ),
        );
      } else {
        throw Exception('Unexpected data format');
      }
      } else {
        print('Error: ${response.body}');
        print('Selected Sport: $selectedSport');
        print('Location: $location');
        print('Date: $formattedDate');
        print('Start Time: ${startTime?.hour}:${startTime?.minute}');
        print('End Time: ${endTime?.hour}:${endTime?.minute}');
        print(response.statusCode);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch sport centers.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }
  // final List<String> sports = ['Tennis', 'Soccer', 'Basketball'];

// Function to open the date picker and select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Court'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CustomDropdown(
            //   value: selectedSport,
            //   hint: 'Select Sport',
            //   onChanged: (value) {
            //     setState(() {
            //       selectedSport = value;
            //     });
            //   },
            //   items: sports,
            // ),
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.0),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(15.0),
          //   border: Border.all(
          //       color: Color.fromARGB(255, 101, 109, 102), style: BorderStyle.solid, width: 0.80),
          // ),
          //     child: DropdownButton<String>(
          //       value: selectedSport,
          //       hint: Text('Select Sport'),
          //       onChanged: (value) {
          //         setState(() {
          //           selectedSport = value;
          //         });
          //       },
          //       items: sports.map<DropdownMenuItem<String>>((String sport) {
          //         return DropdownMenuItem<String>(
          //           value: sport,
          //           child: Text(sport),
          //         );
          //       }).toList(),
          //     ),
          //   ),
          fryoTextInput(
              'Sport Type',
              onChanged: (value) {
                setState(() {
                  selectedSport = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Custom input field for location
            fryoTextInput(
              'Location',
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 16.0),
          
    // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)
                    )
                  )
                ),
                  onPressed: () => _selectDate(context),
                  child: Text('Pick a Date'),
                ), 
         ],
        ),
            SizedBox(height: 16.0),
        
        //Start Time
      Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [

    
Text("${startTime?.hour ?? '--'}: ${startTime?.minute ?? '--'}"),

ElevatedButton(
  style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)
                    )
                  )
                ),
child: const Text("Choose Start Time"),
onPressed: () async {
final TimeOfDay? startTimeOfDay = await showTimePicker(
context: context,
initialTime: startTime ?? TimeOfDay.now(),

initialEntryMode: TimePickerEntryMode.dial,
);
if (startTimeOfDay != null) {
setState(() {
startTime = startTimeOfDay;
int adjustedStartMinutes = (startTimeOfDay.minute < 15 || startTimeOfDay.minute >= 45)
          ? 00
          : 30;
startTime = TimeOfDay(hour: startTimeOfDay.hour, minute: adjustedStartMinutes);
      
});
}

},
), 
], 
        ),
            SizedBox(height: 16.0),
    //End Time

Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
Text("${endTime?.hour ?? '--'}: ${endTime?.minute ?? '--'}"),
ElevatedButton(
  style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)
                    )
                  )
                ),
child: const Text("Choose End Time"),
onPressed: () async {
final TimeOfDay? endTimeOfDay = await showTimePicker(
context: context,
initialTime: endTime ?? TimeOfDay.now(),
initialEntryMode: TimePickerEntryMode.dial,
);
if (endTimeOfDay != null) {
setState(() {
endTime = endTimeOfDay;
int adjustedEndMinutes = (endTimeOfDay.minute < 15 || endTimeOfDay.minute >= 45)
          ? 00
          : 30;
          
      endTime = TimeOfDay(hour: endTimeOfDay.hour, minute: adjustedEndMinutes);
});
}
},

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
      ]),
    ),
     bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () =>Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            )),
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            ElevatedButton(
              onPressed: searchSportCenters,
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
  
}

