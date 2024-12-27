import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/blocs/chat/chat_bloc.dart';
import 'package:shop/blocs/user/user_bloc.dart';
import 'package:shop/screens/chat/chat_screen.dart';
import 'package:shop/utils/dio_client/dio_client.dart';


class HorizontalActivitiesWidget extends StatefulWidget {
  @override
  _HorizontalActivitiesWidgetState createState() => _HorizontalActivitiesWidgetState();
}

class _HorizontalActivitiesWidgetState extends State<HorizontalActivitiesWidget> {
    List<dynamic> activities = [];
    String sportTypeQuery = '';
  String locationQuery = '';
 String _searchType = 'sportType'; // Default search type
  String _query = ''; // Search query

  @override
  void initState() {
    super.initState();
    fetchActivities(); 
  }


  Future<void> fetchActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('No authentication token found. Redirecting to login.');
      return;
    }

    final url = Uri.parse('$baseUrl:8000/api/activities/others');

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

 UserEntity? getUserById(int? userId) {
    if (userId == null) return null;
    final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];
    return users.firstWhere((user) => user.id == userId);
  }

@override
Widget build(BuildContext context) {
  return activities.isEmpty
      ? Center(child: Text('No deals available.', style: TextStyle(fontSize: 16)))
      : SizedBox(
          height: 305, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
       

              return Container(
                width: 180, 
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Image.asset(
                'assets/images/activityDefaultImage.jpg', 
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          activity['sportType'] ?? 'No Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Location: ${activity['sport_center_name'] ?? 'N/A'}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    ),
    Text(
      'Date: ${activity['date'] ?? 'N/A'}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    ),
    Text(
      'Start Time: ${activity['startTime'] ?? 'N/A'}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    ),
    Text(
      'End Time: ${activity['endTime'] ?? 'N/A'}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
    ),
  ],
),
                      ),
                  
                     Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Creator: ${activity['creator_name']?? 'Unknown'}',

          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    
     IconButton(
          icon: Icon(Icons.message, color: Colors.red),
          onPressed: () {
            // Navigate to chat screen with the seller
            final userId = activity['user_id'];
            if (userId == null) {
              print('User ID is null for this deal');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('This deal does not have a valid user')),
              );
              return;
            }

            final user = getUserById(userId);
            if (user != null) {
              context.read<ChatBloc>().add(UserSelected(user));
              Navigator.of(context).pushNamed(ChatScreen.routeName);
            } else {
              print('User not found for ID: $userId');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User not found for this deal')),
              );
            }
          },
        ),
    ],
  ),
),
                    ],
                  ),
                ),
              );
            },
          ),
        );
}

}