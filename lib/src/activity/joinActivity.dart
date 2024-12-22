import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/blocs/blocs.dart';
import 'package:shop/blocs/chat/chat_bloc.dart';
import 'package:shop/blocs/user/user_bloc.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/models/models.dart';
import 'package:shop/screens/chat/chat_screen.dart';
import 'package:shop/screens/chat_list/chat_list_item.dart';
import 'package:shop/screens/guest/guest_screen.dart';
import 'package:shop/utils/utils.dart';
import 'package:shop/widgets/widgets.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:search_page/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc

class JoinActivityPage extends StatefulWidget {
  @override
  _JoinActivityPageState createState() => _JoinActivityPageState();
}

class _JoinActivityPageState extends State<JoinActivityPage> {
  List<dynamic> activities = [];
    String sportTypeQuery = '';
  String locationQuery = '';
 String _searchType = 'sportType'; // Default search type
  String _query = ''; // Search query

  Future<void> fetchActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/activities/others');

    try {
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
          activities = data;
        });
      } else {
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch activities.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }


   Future<void> fetchSpecificActivities(String query, String searchType) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    // Construct URL based on the search type
    String url = 'http://10.0.2.2:8000/api/activities/specific?$searchType=$query';
    print('Request URL: $url'); // Debug: Print the request URL

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data'); 

  // Print each activity's details for debugging
  for (var activity in data) {
    print('Activity ID: ${activity['id']}');
    print('Sport Type: ${activity['sportType']}');
    print('Sport Center Name: ${activity['sport_center_name']}');
    print('Sport Center Location: ${activity['sport_center_location']}');
    print('Creator Name: ${activity['creator_name']}');
    print('Start Time: ${activity['start_time']}');
    print('End Time: ${activity['end_time']}');
    print('Date: ${activity['date']}');
    print('---');
  }

        setState(() {
          activities = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch activities.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }


  Future<void> joinActivity(int activityId, int userId, int playerQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    String url = 'http://10.0.2.2:8000/api/join/activities/$activityId';
    print('Join URL: $url'); // Debug: Print the join URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'user_id': userId,
          'player_quantity': playerQuantity,
        }),
      );

      print('Join response status: ${response.statusCode}'); // Debug: Print the response status code
      print('Join response body: ${response.body}'); // Debug: Print the response body

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined activity successfully.')),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Failed to join activity.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> promptForPlayerQuantity(int activityId) async {
    int? playerQuantity;
    final userId = 1; // Replace with actual user ID from your app's context

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Player Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              playerQuantity = int.tryParse(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter number of players',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Join'),
              onPressed: () {
                if (playerQuantity != null && playerQuantity! > 0) {
                  Navigator.of(context).pop();
                  joinActivity(activityId, userId, playerQuantity!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid player quantity.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    fetchActivities(); 
  }

  UserEntity? getUserById(int? userId) {
  if (userId == null) return null; // Early return for null userId

  // Ensure that the users list contains UserEntity objects
  final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];

  // Find the user with the matching ID
  return users.firstWhere(
    (user) => user.id == userId,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _searchType,
                  items: [
                    DropdownMenuItem(value: 'sportType', child: Text('Sport Type')),
                    DropdownMenuItem(value: 'location', child: Text('Location')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _searchType = value!;
                    });
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _query = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_query.isNotEmpty) {
                      fetchSpecificActivities(_query, _searchType);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a search query.')),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: activities.isEmpty
                  ? Center(child: Text('No activities found.'))
                  : ListView.builder(
  itemCount: activities.length,
  itemBuilder: (context, index) {
    final activity = activities[index];
    final sportType = activity['sportType'] ?? 'Unknown Sport';
    final sportCenterName = activity['sport_center_name'] ?? 'Unknown Sport Center';
    final location = activity['sport_center_location'] ?? 'Unknown Location';
    final creatorName = activity['creator_name'] ?? 'Unknown Creator';
    final startTime = activity['startTime'] ?? 'Unknown Start Time';
    final endTime = activity['endTime'] ?? 'Unknown End Time';
    final date = activity['date'] ?? 'Unknown Date';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(sportType),
        subtitle: Text(
          'Location: $location\n'
          'Sport Center: $sportCenterName\n'
          'Date: $date\n'
          'Start Time: $startTime\n'
          'End Time: $endTime\n'
          'Creator: $creatorName\n',
          
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: Icon(Icons.message),
           onPressed: () {
            final userId = activity['user_id']; // Extract userId from activity data
            UserEntity? user = getUserById(userId);
            if (user != null) {
              // Dispatch an event to the ChatBloc to start a chat with the user
              BlocProvider.of<ChatBloc>(context).add(UserSelected(user));

              // Navigate to the ChatScreen
              Navigator.of(context).pushNamed(ChatScreen.routeName);
            } else {
              // Handle the case where the user is not found
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User not found.')),
              );
            }
          },
            ),
            ElevatedButton(
              onPressed: () {
              promptForPlayerQuantity(activity['id']);

              },
              child: Text('Join'),
            ),
          ],
        ),
      ),
    );
  },
)
            ),
          ],
        ),
      ),
    );
  }
}