import 'package:flutter/material.dart';
import '../booking/booking.dart';
import '../booking/booking3.dart';
import 'package:shop/utils/dio_client/dio_client.dart';
import 'package:shop/utils/dio_client/dio_client.dart';
 final dioClient = DioClient();
  final baseUrl = dioClient.baseUrl;


class SportCenterList extends StatelessWidget {
  static const routeName = "sportCenterList";


  final List<Map<String, dynamic>> sportsCenters;
SportCenterList(this.sportsCenters);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports Centers'),
      ),
      body: sportsCenters.isEmpty
          ? Center(
              child: Text(
                'No Sports Centers or Sports Type Available',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: sportsCenters.length,
              itemBuilder: (context, index) {
                final item = sportsCenters[index];
                print('Item at index $index: $item');
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
                             decoration: BoxDecoration(
                               image: DecorationImage(
                                 image: NetworkImage(
                                  
        '$baseUrl/sportsConnectAdmin/sportsConnect/public/images/${item['image'] ?? 'default.jpg'}',
      ),
                                 fit: BoxFit.cover,
                               ),
                             ),
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
                          (item['price'] ?? 'N/A'),
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
                        SizedBox(height: 8.0),
            // Select Button
            ElevatedButton(
              onPressed: () {
                // Navigate to available courts page
           final sportCenterId = item['id'] ?? 0;
    final selectedSport = item['sportType'] ?? 'Unknown Sport';
    final selectedDate = item['date'] ?? 'Unknown Date';
    final startTime = item['startTime'] ?? '00:00';
    final endTime = item['endTime'] ?? '00:00';
    final image = item['image'] ?? 'default.jpg';

    // Debugging: Print the values being passed
    print('Navigating to SportsCenterLayout with:');
    print('sportCenterId: $sportCenterId');
    print('selectedSport: $selectedSport');
    print('selectedDate: $selectedDate');
    print('startTime: $startTime');
    print('endTime: $endTime');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SportsCenterLayout(
          sportCenterId: sportCenterId,
          selectedSport: selectedSport,
          selectedDate: selectedDate,
          startTime: startTime,
          endTime: endTime,
          image: item['image'],
        ),
      ),
    );
              },
              child: Text('Select'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
                      ],
                    ),
                  ),
                );
              },
              
            ),

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
            // ElevatedButton(
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => SportsCenterLayout(),
            //     ),
            //   ),
            //   child: Text('Next'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
