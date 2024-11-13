import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../booking/booking2.dart';
import '../shared/buttons.dart';
import '../shared/input_fields.dart';
import 'package:page_transition/page_transition.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/rounded_button.dart';

import '../rental/rental2.dart';
import '../rental/rental4.dart';
import '../rental/rental.dart';


// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ItemDetailPage(),
//     );
//   }
// }


List<String> imageFiles = [
  'akara.png',
  'coca-cola.png',
  'hamburger.png',
  'lemonade.png',
  'pancake.png',
  'pasta.png',
  'strawberry.png', 
  'tequila.png',
  'vodka.png',
  'welcome.png',
];

class ItemDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.sports_volleyball),
            SizedBox(width: 8),
            Text("Volleyball"),
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
                HeaderTopCarouselWidget(),
                
                Positioned(
                  top:110,
                  left: 16,
                  child: Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                Positioned(
                  top:110,

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
                      "RM 20 / hour",
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
                      "RM 10",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Description section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Text(
                  "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\"",
                  style: TextStyle(fontSize: 14),
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
                      "Good",
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
                      "6 left",
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
                  style: TextStyle(fontSize: 16,color: Colors.white)
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

class HeaderTopCarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 240,
          child: CarouselView(
            itemExtent: MediaQuery.of(context).size.width - 2,
            itemSnapping: true,
            elevation: 2,
            padding: const EdgeInsets.all(8),
            children: List.generate(imageFiles.length, (int index) {
  return Container(
    color: Colors.white,
    child: Image.asset(
      'assets/images/${imageFiles[index]}', // Dynamically load each image from the list
      fit: BoxFit.contain,
    ),
  );
}),
          ),
        ),
      ],
    );
  }
}

// Function to show the quantity selection dialog
  void _showQuantityDialog(BuildContext context) {
    int selectedQuantity = 1; // Default selected quantity
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
                  Text("Available: 6 items"), // Display available quantity
                  SizedBox(height: 8),
                  DropdownButton<int>(
                    value: selectedQuantity,
                    items: List.generate(6, (index) => index + 1)
                        .map((quantity) {
                      return DropdownMenuItem<int>(
                        value: quantity,
                        child: Text(quantity.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedQuantity = value!;
                      });
                    },
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
                Navigator.of(context).pop(); // Close dialog
                _showConfirmationMessage(context, selectedQuantity);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a confirmation message after selection
  void _showConfirmationMessage(BuildContext context, int quantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking Confirmed"),
          content: Text("You have rented $quantity items."),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RentalPaymentApp(),
                ),
              ),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }



