import 'package:flutter/material.dart';
import '../booking/myBooking.dart' as myBooking; //side bar drawer is here

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyRentalsPage(),
//     );
//   }
// }


// class RentalDetails {
//   final int sportCenterId;
//   final int equipmentID;
//   final String date;
//   final String startTime;
//   final String endTime;
//   final int quantityRented;

//   RentalDetails({
//     required this.sportCenterId,
//     required this.equipmentID,
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.quantityRented,
//   });
// }


class MyRentalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
          
            SizedBox(width: 8),
            Text("My Rentals"),
          ],
        ),
      ),
      drawer: const myBooking.NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ongoing Section
              Text(
                "Ongoing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RentalCard(
                color: Colors.lightBlue[100],
                title: "Rental 1",
                centerName: "Sport Center 1",
                description: "Description Description",
              ),
              RentalCard(
                color: Colors.lightBlue[100],
                title: "Rental 2",
                centerName: "Sport Center 2",
                description: "Description Description",
              ),
              SizedBox(height: 16),
              // Completed Section
              Text(
                "Completed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RentalCard(
                color: Colors.lightGreen[100],
                title: "Rental 3",
                centerName: "Sport Center 3",
                description: "Description Description",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RentalCard extends StatelessWidget {
  final Color? color;
  final String title;
  final String centerName;
  final String description;

  const RentalCard({
    Key? key,
    required this.color,
    required this.title,
    required this.centerName,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder image
          Container(
            height: 60,
            width: 60,
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
          ),
          SizedBox(width: 12),
          // Rental details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  centerName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // View button
          ElevatedButton(
            onPressed: () {
              // Navigate to rental details or perform an action
            },
            child: Text("View"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
