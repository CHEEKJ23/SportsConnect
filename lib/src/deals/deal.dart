import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/chat.dart';
import 'package:shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
class AllDealsPage extends StatefulWidget {
  @override
  _AllDealsPageState createState() => _AllDealsPageState();
}

class _AllDealsPageState extends State<AllDealsPage> {
  List<dynamic> deals = [];

  @override
  void initState() {
    super.initState();
    fetchAllDeals();
  }

  Future<void> fetchAllDeals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/view/deals'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          deals = jsonDecode(response.body);
        });
        print('Fetched deals: ${response.body}');
      } else {
        print('Failed to fetch deals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    return Card(
      
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: deal['image_path'] != null
            ? Image.network(
                deal['image_path'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image, size: 50.0);
                },
              )
            : Icon(Icons.image, size: 50.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                deal['title'] ?? 'No Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Price: \$${deal['price'] ?? 'N/A'}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Location: ${deal['location'] ?? 'Unknown'}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              
              // 'Posted by: ${deal['userName'] ?? 'Unknown User'}',
              'Posted by: ${deal['user']?['name'] ?? 'Unknown User'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.message, color: Colors.blue),
        //   onPressed: () {
        //     // Implement chat or contact functionality
        //     print('Contact seller for deal: ${deal['id']}');
        //   },
        // ),
trailing: IconButton(
  icon: Icon(Icons.message, color: Colors.blue),
  onPressed: () {
    final userId = deal['userID']; 

    if (userId == null) {
      // Handle case where user_id is null
      print('User ID is null for this deal');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This deal does not have a valid user')),
      );
      return; // Exit the function
    }

    final user = getUserById(userId);

    if (user != null) {
      // Proceed if the user is found
      // context.read<ChatBloc>().add(UserSelected(user));
      // Navigator.of(context).pushNamed(ChatScreen.routeName);
context.read<ChatBloc>().add(UserSelected(user));
Navigator.of(context).pushNamed(
  ChatScreen.routeName,
  arguments: {
    'defaultMessage': "Hello, I'm interested in this item. Could you provide more details?"
  },
);
    } else {
      // Handle missing user
      print('User not found for ID: $userId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found for this deal')),
      );
    }
  },
),
      ),
    );
  }
UserEntity? getUserById(int? userId) {
  if (userId == null) return null; // Early return for null userId
  final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];
  return users.firstWhere((user) => user.id == userId);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Deals'),
      ),
      body: deals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading deals...',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchAllDeals,
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: deals.length,
                itemBuilder: (context, index) => _buildDealCard(deals[index]),
              ),
            ),
    );
  }
}