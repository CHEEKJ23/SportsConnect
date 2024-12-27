import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/utils/dio_client/dio_client.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  int userPoints = 0;
  List<dynamic> gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchUserPoints();
    _fetchGifts();
  }

  Future<void> _fetchUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    final response = await http.get(
      Uri.parse('$baseUrl:8000/api/view/points'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userPoints = json.decode(response.body)['points'];
      });
    } else {
      print('Failed to fetch user points. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchGifts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    final response = await http.get(
      Uri.parse('$baseUrl:8000/api/view/gifts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        gifts = json.decode(response.body);
      });
    } else {
      print('Failed to fetch gifts. Status code: ${response.statusCode}');
    }
  }

  Future<void> _redeemGift(int giftId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
  final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl:8000/api/redeem/gift'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'gift_id': giftId}),
    );

    if (response.statusCode == 200) {
      _fetchUserPoints(); // Refresh user points after redemption
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redemption request submitted')),
      );
    } else {
      print('Failed to redeem gift. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to redeem gift')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;
    return Scaffold(
      appBar: AppBar(title: Text('Rewards')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Your Points: $userPoints'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                final imageUrl = '$baseUrl/sportsConnectAdmin/sportsConnect/public/images/${gift['image_path']}';

                return Card(
                  child: ListTile(
                    leading: gift['image_path'] != null
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
                    title: Text(gift['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Points Needed: ${gift['points_needed']}'),
                        Text(gift['description'] ?? 'No description available'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: userPoints >= gift['points_needed']
                          ? () => _redeemGift(gift['id'])
                          : null,
                      child: Text('Redeem'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}