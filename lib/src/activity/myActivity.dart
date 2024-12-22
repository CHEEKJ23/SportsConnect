import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserActivitiesScreen extends StatefulWidget {
  @override
  _UserActivitiesScreenState createState() => _UserActivitiesScreenState();
}

class _UserActivitiesScreenState extends State<UserActivitiesScreen> {
  List<dynamic> userActivities = [];
  List<dynamic> joinedActivities = [];


  @override
  void initState() {
    super.initState();
    fetchUserActivities(); // Fetch user activities when the screen loads
    fetchJoinedActivities();

  }

  Future<void> fetchUserActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    String url = 'http://10.0.2.2:8000/api/activities/mine';
    print('User Activities URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('User Activities response status: ${response.statusCode}');
      print('User Activities response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('User Activities data: $data'); 
        setState(() {
          userActivities = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user activities.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

 Future<void> fetchJoinedActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    String url = 'http://10.0.2.2:8000/api/activities/joined';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          joinedActivities = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch joined activities.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

Future<void> cancelActivity(int activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    String url = 'http://10.0.2.2:8000/api/activities/cancel/$activityId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Activity cancelled successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Activity cancelled successfully')),
        );
      } else {
        print('Failed to cancel activity');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel activity')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> unjoinActivity(int activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    String url = 'http://10.0.2.2:8000/api/activities/unjoin/$activityId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Successfully unjoined the activity');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully unjoined the activity')),
        );
      } else {
        print('Failed to unjoin activity');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unjoin activity')),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Activities'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Created'),
              Tab(text: 'Joined'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildSelfCreatedActivityList(userActivities, 'No created activities found.'),
            buildJoinedActivityList(joinedActivities, 'No joined activities found.'),
          ],
        ),
      ),
    );
  }

Widget buildJoinedActivityList(List<dynamic> activities, String emptyMessage) {
  return activities.isEmpty
      ? Center(child: Text(emptyMessage))
      : ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final sportType = activity['sportType'] ?? 'Unknown Sport';
            final sportCenterName = activity['sport_center_name'] ?? 'Unknown Sport Center';
            final location = activity['sport_center_location'] ?? 'Unknown Location';
            final date = activity['date'] ?? 'Unknown Date';
            final startTime = activity['startTime'] ?? 'Unknown Start Time';
            final endTime = activity['endTime'] ?? 'Unknown End Time';
            final players = activity['players'] as List<dynamic> ?? [];
    final joinedUserNames = players.map((player) => player['name']).join(', ');



            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group_outlined, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          sportType,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Location: $location',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Sport Center: $sportCenterName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Date: $date',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                      Text(
                      'Start Time: $startTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),  Text(
                      'End Time: $endTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Joined Users: $joinedUserNames',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       
                        SizedBox(width: 8),
                         ElevatedButton(
                          onPressed: () {
                             _showUnjoinConfirmationDialog(context, activity['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400, 
                            foregroundColor: Colors.white, 
                          ),
                          child: Text('Unjoin'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
}

Widget buildSelfCreatedActivityList(List<dynamic>? activities, String emptyMessage) {
  // Ensure activities is not null by initializing it to an empty list if necessary
  final safeActivities = activities ?? [];

  return safeActivities.isEmpty
      ? Center(child: Text(emptyMessage))
      : ListView.builder(
          itemCount: safeActivities.length,
          itemBuilder: (context, index) {
            final activity = safeActivities[index];
            final sportType = activity['sportType'] ?? 'Unknown Sport';
            final sportCenterName = activity['sport_center_name'] ?? 'Unknown Sport Center';
            final location = activity['sport_center_location'] ?? 'Unknown Location';
            final date = activity['date'] ?? 'Unknown Date';
            final startTime = activity['startTime'] ?? 'Unknown Start Time';
            final endTime = activity['endTime'] ?? 'Unknown End Time';
            final players = activity['players'] as List<dynamic>? ?? [];
            final joinedUserNames = players.map((player) => player['name']).join(', ');

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group_outlined, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          sportType,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Location: $location',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Sport Center: $sportCenterName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Date: $date',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Start Time: $startTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'End Time: $endTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Joined Users: $joinedUserNames',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        ElevatedButton(
                          onPressed: () {
                            _showCancelConfirmationDialog(context, activity['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400, 
                            foregroundColor: Colors.white, 
                          ),
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
}

void _showCancelConfirmationDialog(BuildContext context, int activityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel'),
          content: Text('Are you sure you want to cancel this activity?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                cancelActivity(activityId); // Proceed with canceling the activity
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  
void _showUnjoinConfirmationDialog(BuildContext context, int activityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel'),
          content: Text('Are you sure you want to unjoin this activity?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                unjoinActivity(activityId); // Proceed with canceling the activity
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}