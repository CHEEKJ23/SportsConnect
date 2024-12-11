// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class RentalReturnRequestPage extends StatefulWidget {
//   @override
//   _RentalReturnRequestPageState createState() => _RentalReturnRequestPageState();
// }

// class _RentalReturnRequestPageState extends State<RentalReturnRequestPage> {
//   final TextEditingController _rentalIdController = TextEditingController();

//   Future<void> sendReturnRequest() async {
//     final String rentalId = _rentalIdController.text.trim();
//     if (rentalId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid Rental ID.')),
//       );
//       return;
//     }

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('authToken');

//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Authentication token not found. Please log in again.')),
//         );
//         return;
//       }

//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:8000/api/rentals/return-request'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'rentalID': rentalId,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final snackBar = SnackBar(content: Text('Return request sent successfully.'));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       } else {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final String errorMessage = responseData['message'] ?? 'Failed to send return request.';
//         final snackBar = SnackBar(content: Text(errorMessage));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//     } catch (e) {
//       final snackBar = SnackBar(content: Text('An error occurred: $e'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rental Return Request'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _rentalIdController,
//               decoration: InputDecoration(labelText: 'Rental ID'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendReturnRequest,
//               child: Text('Send Return Request'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }