import 'package:flutter/material.dart';
import '../booking/booking.dart';
import '../booking/booking3.dart';
import '../screens/dashboard.dart';
import '../rental/rental3.dart';


class EquipmentList extends StatefulWidget {
  const EquipmentList({super.key});

  @override
  State<EquipmentList> createState() => _EquipmentListState();
}

class _EquipmentListState extends State<EquipmentList> {
  final List<Map<String, String>> sportsCenters = [
    {
      'name': 'Ping Pong Racket',
      'priceRange': 'RM10/hour',
      'description': 'Description\nDescription'
    },
    {
      'name': 'Volley Ball',
      'priceRange': 'RM20/hour',
      'description': 'Description\nDescription'
    },
    // Add more items if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Equipment'),
      ),
      body: ListView.builder(
        itemCount: sportsCenters.length,
        itemBuilder: (context, index) {
          final item = sportsCenters[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Larger image container
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 100), // Image icon placeholder
                  ),
                  SizedBox(height: 8.0),
                  // Text content below the image
                  Text(
                    item['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    item['priceRange']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    item['description']!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      ElevatedButton(
                                    onPressed: () =>Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ItemDetailPage(),
                                  )),
                                    child: Text('Select'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      
                                    ),
                                  ),
                    ],
                    
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Bottom buttons
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () =>Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => BookingPage(),
      //       )),
      //         child: Text('Back'),
      //         style: ElevatedButton.styleFrom(
      //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //         ),
      //       ),
      //       ElevatedButton(
      //         onPressed: () =>Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => SportsCenterLayout(),
      //       )),
      //         child: Text('Next'),
      //         style: ElevatedButton.styleFrom(
      //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
