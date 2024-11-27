// import 'package:flutter/material.dart';
// import '../shared/colors.dart';
// import '../booking/booking3.dart';
// import '../booking/myBooking.dart';



// void main() {
//   runApp(PaymentApp());
// }

// class PaymentApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PaymentMethodScreen(),
//     );
//   }
// }

// class PaymentMethodScreen extends StatefulWidget {
//   @override
//   _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
// }

// class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
//   String selectedPaymentMethod = "Amazon Pay";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment Method'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () =>Navigator.push(
//             context,
//             // MaterialPageRoute(
//             //   // builder: (BuildContext context) => SportsCenterApp(),
//             // )),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPaymentOption("Amazon Pay", "assets/images/stripe.png"),
//             _buildPaymentOption("Credit Card", "assets/images/stripe.png"),
//             _buildPaymentOption("Paypal", "assets/images/stripe.png"),
//             _buildPaymentOption("Google Pay", "assets/images/stripe.png"),
//             SizedBox(height: 20),
//             Divider(),
//             SizedBox(height: 10),
//             _buildPriceDetail("Sub-Total", "\$300.50"),
//             _buildPriceDetail("Shipping Fee", "\$15.00"),
//             SizedBox(height: 10),
//             _buildTotalPayment("\$380.50"),
//             Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _confirmPaymentDialog(context);
//                 },
//                 child: Text("Confirm Payment"),
//                 style: ElevatedButton.styleFrom(
//                   // primary: Colors.red,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, String imagePath) {
//     return ListTile(
//       leading: Image.asset(imagePath, width: 40, height: 40),
//       title: Text(title),
//       trailing: Radio<String>(
//         value: title,
//         groupValue: selectedPaymentMethod,
//         onChanged: (value) {
//           setState(() {
//             selectedPaymentMethod = value!;
//           });
//         },
//       ),
//       onTap: () {
//         setState(() {
//           selectedPaymentMethod = title;
//         });
//       },
//     );
//   }

//   Widget _buildPriceDetail(String label, String amount) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.grey),
//           ),
//           Text(amount),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalPayment(String amount) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Total Payment",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           amount,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
//         ),
//       ],
//     );
//   }

//   void _confirmPaymentDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Payment"),
//           content: Text("Are you sure you want to proceed with the payment using $selectedPaymentMethod?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () =>Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (BuildContext context) => MyBookingsPage(),
//             )),
//               child: Text("Confirm"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
