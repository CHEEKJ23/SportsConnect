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
import 'package:shop/utils/dio_client/dio_client.dart';

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
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/view/deals'),
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
    final imageUrl = 'http://10.0.2.2/sportsConnectAdmin/sportsConnect/public/images/${deal['image_path']}';

    return Card(
      child: ListTile(
        leading: deal['image_path'] != null
            ? Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50);
                },
              )
            : Icon(Icons.image, size: 50),
        title: Text(deal['title'] ?? 'No Title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${deal['price'] ?? 'N/A'}'),
            Text(deal['description'] ?? 'No description available'),
            Text('Seller: ${deal['user']['name'] ?? 'Unknown'}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.message, color: Colors.blue),
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
      ),
    );
  }

  UserEntity? getUserById(int? userId) {
    if (userId == null) return null;
    final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];
    return users.firstWhere((user) => user.id == userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deals')),
      body: deals.isEmpty
          ? Center(child: Text('No deals available.'))
          : ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return _buildDealCard(deal);
              },
            ),
    );
  }
}