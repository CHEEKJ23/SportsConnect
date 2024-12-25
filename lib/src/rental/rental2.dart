import 'package:flutter/material.dart';
import 'rental3.dart'; // Ensure this import points to the file where RentalDetails and ItemDetailPage are defined

class EquipmentList extends StatelessWidget {
  final List<dynamic> availableEquipment;
  final Map<String, dynamic> rentalDetails;

  EquipmentList({Key? key, required this.availableEquipment, required this.rentalDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Equipment'),
      ),
      body: ListView.builder(
        itemCount: availableEquipment.length,
        itemBuilder: (context, index) {
          final equipment = availableEquipment[index];
          final equipmentID = equipment['equipmentID'] as int?;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment['name'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Available: ${equipment['quantity_available'] ?? 'N/A'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: equipmentID != null
                        ? () => navigateToItemDetailPage(context, equipment, rentalDetails)
                        : null, // Disable button if ID is null
                    child: Text('View Details'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void navigateToItemDetailPage(BuildContext context, Map<String, dynamic> equipment, Map<String, dynamic> rentalDetailsMap) {
    final rentalDetails = RentalDetails(
      sportCenterId: rentalDetailsMap['sport_center_id'] ?? 0,
      date: rentalDetailsMap['date'] ?? '',
      startTime: rentalDetailsMap['startTime'] ?? '',
      endTime: rentalDetailsMap['endTime'] ?? '',
      equipmentID: equipment['equipmentID'], 
      quantityRented: equipment['quantity_rented'], 
      image: equipment['image_path'],

    );

    // Debug: Print the rental details being passed
    print('Passing rentalDetails: $rentalDetails');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(
          equipmentDetails: equipment,
          rentalDetails: rentalDetails,
        ),
      ),
    );
  }
}