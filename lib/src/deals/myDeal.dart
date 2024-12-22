// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'editDeal.dart';
// class MyDealsPage extends StatefulWidget {
//   @override
//   _MyDealsPageState createState() => _MyDealsPageState();
// }

// class _MyDealsPageState extends State<MyDealsPage> {
//   List<dynamic> deals = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchDeals();
//   }

//   Future<void> fetchDeals() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');

//     if (token == null) {
//       print('Token is null. Redirecting to login.');
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8000/api/view/my-deals'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           deals = jsonDecode(response.body);
//         });
//       } else {
//         print('Failed to fetch deals. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

//   Future<void> deleteDeal(int? dealID) async {
//     if (dealID == null) {
//       print('Deal ID is null. Cannot delete.');
//       print('Deal ID: $dealID');
//       return;
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');

//     if (token == null) {
//       print('Token is null. Redirecting to login.');
     
//       return;
//     }

//     try {
//       final response = await http.delete(
//         Uri.parse('http://10.0.2.2:8000/api/delete/deals/$dealID'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         print('Deal deleted successfully.');
//         fetchDeals(); // Refresh the list of deals
//       } else {
//         print('Failed to delete deal. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }

// void editDeal(int? dealID, Map<String, dynamic> dealData) {
//   if (dealID == null) {
//     print('Deal ID is null. Cannot edit.');
//     return;
//   }
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => EditDealPage(dealID: dealID, initialData: dealData),
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Deals'),
//       ),
//       body: deals.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: EdgeInsets.all(8.0),
//               itemCount: deals.length,
//               itemBuilder: (context, index) {

//                 final deal = deals[index];
//                 // final int? dealID = deal['id'] as int?; 
                
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8.0),
//                   elevation: 4.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(16.0),
//                     leading: deal['image_path'] != null
//                         ? Image.network(
//                             deal['image_path'],
//                             width: 50.0,
//                             height: 50.0,
//                             fit: BoxFit.cover,
//                           )
//                         : Icon(Icons.image, size: 50.0), // Placeholder if no image
//                     title: Text(
//                       deal['title'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8.0),
//                         Text(
//                           'Price: \$${deal['price']}',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Location: ${deal['location']}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => editDeal(deal['dealID'], deal),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => deleteDeal(deal['dealID']),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'editDeal.dart';

class MyDealsPage extends StatefulWidget {
  @override
  _MyDealsPageState createState() => _MyDealsPageState();
}

class _MyDealsPageState extends State<MyDealsPage> with SingleTickerProviderStateMixin {
  List<dynamic> deals = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchDeals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchDeals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/view/my-deals'),
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

  Future<void> deleteDeal(int? dealID) async {
    if (dealID == null) {
      print('Deal ID is null. Cannot delete.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token is null. Redirecting to login.');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/delete/deals/$dealID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Deal deleted successfully.');
        fetchDeals(); // Refresh the list of deals
      } else {
        print('Failed to delete deal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void editDeal(int? dealID, Map<String, dynamic> dealData) {
    if (dealID == null) {
      print('Deal ID is null. Cannot edit.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDealPage(dealID: dealID, initialData: dealData),
      ),
    ).then((value) {
      if (value == true) {
        fetchDeals(); // Refresh the list if the deal was updated
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    final status = deal['status']?.toString().toLowerCase() ?? 'pending';
    final imageUrl = 'http://10.0.2.2/sportsConnectAdmin/sportsConnect/public/images/${deal['image_path']}';


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
                imageUrl,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
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
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => editDeal(deal['dealID'], deal),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteDeal(deal['dealID']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealsList(String status) {
    final filteredDeals = deals.where((deal) => 
      (deal['status']?.toString().toLowerCase() ?? 'pending') == status.toLowerCase()
    ).toList();
    
    return filteredDeals.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  status == 'pending' ? Icons.pending :
                  status == 'approved' ? Icons.check_circle :
                  Icons.cancel,
                  size: 64.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.0),
                Text(
                  'No ${status.toLowerCase()} deals',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: filteredDeals.length,
            itemBuilder: (context, index) => _buildDealCard(filteredDeals[index]),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Deals'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.pending),
              text: 'Pending',
            ),
            Tab(
              icon: Icon(Icons.check_circle),
              text: 'Approved',
            ),
            Tab(
              icon: Icon(Icons.cancel),
              text: 'Rejected',
            ),
          ],
        ),
      ),
      body: deals.isEmpty
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDealsList('pending'),
                _buildDealsList('approved'),
                _buildDealsList('rejected'),
              ],
            ),
    );
  }
}