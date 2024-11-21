import 'package:flutter/material.dart';
import '../booking/booking.dart';
import '../booking/booking3.dart';



class SportCenterList extends StatelessWidget {
  // final List<Map<String, String>> sportsCenters = [
  //   {
  //     'name': 'Pro one Sports Center',
  //     'priceRange': 'RM16-22',
  //     'description': 'Description\nDescription'
  //   },
  //   {
  //     'name': 'Impian Sports World',
  //     'priceRange': 'RM15-25',
  //     'description': 'Description\nDescription'
  //   },
  //   // Add more items if needed
  // ];
  final List<Map<String, dynamic>> sportsCenters;
SportCenterList(this.sportsCenters);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports Centers'),
      ),
      // body: ListView.builder(
      //   itemCount: sportsCenters.length,
      //   itemBuilder: (context, index) {
      //     final item = sportsCenters[index];
      //     return Card(
      //       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             // Larger image container
      //             Container(
      //               width: double.infinity,
      //               height: 200,
      //               color: Colors.grey[300],
      //               child: Icon(Icons.image, size: 100), // Image icon placeholder
      //             ),
      //             SizedBox(height: 8.0),
      //             // Text content below the image
      //             Text(
      //               item['name']!,
      //               style: TextStyle(
      //                 fontWeight: FontWeight.w500,
      //                 fontSize: 16.0,
      //                 color: Colors.grey[800],
      //               ),
      //             ),
      //             SizedBox(height: 4.0),
      //             Text(
      //               item['priceRange']!,
      //               style: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 16.0,
      //               ),
      //             ),
      //             SizedBox(height: 4.0),
      //             Text(
      //               item['description']!,
      //               style: TextStyle(
      //                 color: Colors.grey[600],
      //                 fontSize: 14.0,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: sportsCenters.isEmpty
          ? Center(
              child: Text(
                'No Sports Centers Available',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
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
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey[500],
                          ), // Image icon placeholder
                        ),
                        SizedBox(height: 8.0),
                        // Sports Center Name
                        Text(
                          item['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        // Price Range
                        Text(
                          item['priceRange'] ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        // Description
                        Text(
                          item['description'] ?? 'No description available.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SportsCenterLayout(),
                ),
              ),
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
