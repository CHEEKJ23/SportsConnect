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


class HorizontalDealsWidget extends StatefulWidget {
  @override
  _HorizontalDealsWidgetState createState() => _HorizontalDealsWidgetState();
}

class _HorizontalDealsWidgetState extends State<HorizontalDealsWidget> {
  List<dynamic> userDeals = [];

  @override
  void initState() {
    super.initState();
    fetchUserDeals();
  }

  Future<void> fetchUserDeals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/view/deals'), // Adjust the endpoint as needed
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userDeals = jsonDecode(response.body);
        });
        print('Fetched user deals: ${response.body}');
      } else {
        print('Failed to fetch user deals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

 UserEntity? getUserById(int? userId) {
    if (userId == null) return null;
    final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];
    return users.firstWhere((user) => user.id == userId);
  }

@override
Widget build(BuildContext context) {
  return userDeals.isEmpty
      ? Center(child: Text('No deals available.', style: TextStyle(fontSize: 16)))
      : SizedBox(
          height: 240, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userDeals.length,
            itemBuilder: (context, index) {
              final deal = userDeals[index];
              final imageUrl =
                  'http://10.0.2.2/sportsConnectAdmin/sportsConnect/public/images/${deal['image_path']}';

              return Container(
                width: 205, // Adjust width as needed
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
                      deal['image_path'] != null
                          ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 120,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          deal['title'] ?? 'No Title',
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
                        child: Text(
                          'Price: \$${deal['price'] ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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
          'Seller: ${deal['user']['name'] ?? 'Unknown'}',
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
            final userId = deal['userID'];
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