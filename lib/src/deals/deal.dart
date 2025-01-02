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
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

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
        Uri.parse('$baseUrl:8000/api/view/deals'),
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

Future<void> searchDeals(String query) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final dioClient = DioClient();
    final baseUrl = dioClient.baseUrl;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found. Please log in again.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl:8000/api/search-deals?query=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          deals = data['data']; // Assuming the deals are in the 'data' field
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load deals.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


Widget _buildDealCard(Map<String, dynamic> deal) {
   final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
  final imageUrl = '$baseUrl/sportsConnectAdmin/sportsConnect/public/images/${deal['image_path']}';

  return Card(
    child: ListTile(
      leading: GestureDetector(
        onTap: () {
          _showImageDialog(context, imageUrl);
        },
        child: deal['image_path'] != null
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
      ),
      title: Text(deal['title'] ?? 'No Title'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \RM ${deal['price'] ?? 'N/A'}'),
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

void _showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 100);
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  UserEntity? getUserById(int? userId) {
    if (userId == null) return null;
    final users = context.read<UserBloc>().state.mapOrNull(loaded: (state) => state.users) ?? [];
    return users.firstWhere((user) => user.id == userId);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Deals')),
  //     body: deals.isEmpty
  //         ? Center(child: Text('No deals available.'))
  //         : ListView.builder(
  //             itemCount: deals.length,
  //             itemBuilder: (context, index) {
  //               final deal = deals[index];
  //               return _buildDealCard(deal);
  //             },
  //           ),
  //   );
  // }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Deals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Deals',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchDeals(_searchController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: deals.isEmpty
                        ? Center(child: Text('No deals available.'))
                        : ListView.builder(
                            itemCount: deals.length,
                            itemBuilder: (context, index) {
                              final deal = deals[index];
                              return _buildDealCard(deal);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}