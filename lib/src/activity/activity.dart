import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/dashboard.dart';

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  String sportType = '';
  int sportCenterId = 0;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int playerQuantity = 1;
  double pricePerPax = 0.0;
  String location = '';
  List<dynamic> sportsCenters = [];
  List<String> sportTypes = [];
  String? selectedSportCenter;
  int? selectedSportCenterId;
  String? selectedSportType;

  Future<void> fetchSportsCenters(String location) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/equipment-rental/get-sports-centers?location=$location');
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

  Future<void> fetchSportTypes(int sportCenterId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/available-sport-types/$sportCenterId');
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
        sportTypes = List<String>.from(data);
      });
    } else {
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch sport types.')),
      );
    }
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred.')),
    );
  }
}

  Future<void> createActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final int? userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      print('Token or userId is null. Redirecting to login.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    String formatTimeOfDay(TimeOfDay tod) {
      final hour = tod.hour.toString().padLeft(2, '0');
      final minute = tod.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final Map<String, dynamic> activityData = {
      'user_id': userId,
      'sportType': selectedSportType,
      'sport_center_id': selectedSportCenterId,
      'date': date?.toIso8601String().split('T').first,
      'startTime': startTime != null ? formatTimeOfDay(startTime!) : null,
      'endTime': endTime != null ? formatTimeOfDay(endTime!) : null,
      'player_quantity': playerQuantity,
      'price_per_pax': pricePerPax,
    };

    // Print the data for debugging
    print('Activity Data:');
    print('User ID: $userId');
    print('Sport Type: $selectedSportType');
    print('Sport Center ID: $selectedSportCenterId');
    print('Date: ${activityData['date']}');
    print('Start Time: ${activityData['startTime']}');
    print('End Time: ${activityData['endTime']}');
    print('Player Quantity: $playerQuantity');
    print('Price Per Pax: $pricePerPax');

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/create/activities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(activityData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Activity created successfully.')),
        );
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        print('Failed to create activity. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
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
                      fetchSportTypes(selectedSportCenterId!);
                    });
                  },
                  items: sportsCenters.map<DropdownMenuItem<String>>((center) {
                    return DropdownMenuItem<String>(
                      value: center['name'],
                      child: Text(center['name']),
                    );
                  }).toList(),
                ),
              if (sportTypes.isNotEmpty)
                DropdownButton<String>(
                  hint: Text('Select Sport Type'),
                  value: selectedSportType,
                  onChanged: (value) {
                    setState(() {
                      selectedSportType = value;
                    });
                  },
                  items: sportTypes.map<DropdownMenuItem<String>>((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
              ListTile(
                title: Text('Date: ${date != null ? date!.toLocal().toString().split(' ')[0] : 'Select Date'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != date) {
                    setState(() {
                      date = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Start Time: ${startTime != null ? startTime!.format(context) : 'Select Start Time'}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != startTime) {
                    setState(() {
                      startTime = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('End Time: ${endTime != null ? endTime!.format(context) : 'Select End Time'}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null && picked != endTime) {
                    setState(() {
                      endTime = picked;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Player Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid player quantity';
                  }
                  return null;
                },
                onSaved: (value) => playerQuantity = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price Per Pax'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) => pricePerPax = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createActivity,
                child: Text('Create Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}