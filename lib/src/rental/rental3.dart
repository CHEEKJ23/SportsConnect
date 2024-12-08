import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RentalDetails {
  final int sportCenterId;
  final String date;
  final String startTime;
  final String endTime;
  int? equipmentID;
  int? quantityRented;

  RentalDetails({
    required this.sportCenterId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.equipmentID,
    this.quantityRented,
  });

  void setEquipmentID(int id) {
    equipmentID = id;
  }

  void setQuantityRented(int quantity) {
    quantityRented = quantity;
  }
}

class ItemDetailPage extends StatelessWidget {
  final Map<String, dynamic> equipmentDetails;
  final RentalDetails rentalDetails;

  ItemDetailPage({Key? key, required this.equipmentDetails, required this.rentalDetails}) : super(key: key);

  Future<void> rentEquipment(BuildContext context) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/equipment-rental/rent');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Debug: Print the data being sent
      print('Sending rental request with the following data:');
      print('Sport Center ID: ${rentalDetails.sportCenterId}');
      print('Equipment ID: ${rentalDetails.equipmentID}');
      print('Date: ${rentalDetails.date}');
      print('Start Time: ${rentalDetails.startTime}');
      print('End Time: ${rentalDetails.endTime}');
      print('Quantity Rented: ${rentalDetails.quantityRented}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'sport_center_id': rentalDetails.sportCenterId,
          'equipmentID': rentalDetails.equipmentID,
          'date': rentalDetails.date,
          'startTime': rentalDetails.startTime,
          'endTime': rentalDetails.endTime,
          'quantity_rented': rentalDetails.quantityRented,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Failed to rent equipment.')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  void _showQuantityDialog(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Quantity to Rent"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Available: ${equipmentDetails['quantity_available']} items"),
                  SizedBox(height: 8),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                int? inputQuantity = int.tryParse(quantityController.text);
                if (inputQuantity == null || inputQuantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid quantity.")),
                  );
                } else if (inputQuantity > equipmentDetails['quantity_available']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Quantity exceeds available items.")),
                  );
                } else {
                  Navigator.of(context).pop(); // Close dialog
                  rentalDetails.setEquipmentID(equipmentDetails['equipmentID']);
                  rentalDetails.setQuantityRented(inputQuantity);
                  rentEquipment(context);
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(equipmentDetails['name']),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image carousel placeholder
            Stack(
              children: [
                // Placeholder for image carousel
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text("Image Carousel")),
                ),
                Positioned(
                  top: 110,
                  left: 16,
                  child: Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                Positioned(
                  top: 110,
                  right: 16,
                  child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Price and deposit details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      "RM ${equipmentDetails['price_per_hour']} / hour",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deposit",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      "RM ${equipmentDetails['deposit_amount']}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Description section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    equipmentDetails['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Condition and quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Condition",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      equipmentDetails['condition'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      "${equipmentDetails['quantity_available']} left",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            // Rent button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showQuantityDialog(context);
                },
                child: Text(
                  "Rent",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class HeaderTopCarouselWidget extends StatelessWidget {
//   final List<dynamic> images;

//   HeaderTopCarouselWidget({required this.images});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         SizedBox(
//           height: 240,
//           child: CarouselView(
//             itemExtent: MediaQuery.of(context).size.width - 2,
//             itemSnapping: true,
//             elevation: 2,
//             padding: const EdgeInsets.all(8),
//             children: List.generate(images.length, (int index) {
//               return Container(
//                 color: Colors.white,
//                 child: Image.network(
//                   images[index], // Load each image from the network
//                   fit: BoxFit.contain,
//                 ),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }




   // Positioned(
                //   top:110,
                //   left: 16,
                //   child: Icon(Icons.arrow_back_ios, color: Colors.black),
                // ),
                // Positioned(
                //   top:110,

                //   right: 16,
                //   child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                // ),
                //  HeaderTopCarouselWidget(images: equipmentDetails['images']),



