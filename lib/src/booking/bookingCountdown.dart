// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'dart:async';

// class BookingCountdown extends StatefulWidget {
//   final String bookingDate; // Format: YYYY-MM-DD
//   final String startTime; // Format: HH:mm (24-hour format)
  
//   BookingCountdown({required this.bookingDate, required this.startTime});

//   @override
//   _BookingCountdownState createState() => _BookingCountdownState();
// }

// class _BookingCountdownState extends State<BookingCountdown> {
//   late DateTime bookingStartTime;
//   Duration timeLeft = Duration.zero;
//   FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();

//     // Parse booking time
//     bookingStartTime = DateFormat("yyyy-MM-dd HH:mm").parse(
//       "${widget.bookingDate} ${widget.startTime}",
//     );

//     startCountdown();
//   }

//   void initializeNotifications() {
//     // Initialize the notification plugin
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//     );

//     localNotifications.initialize(settings);
//   }

//   void startCountdown() {
//     // Start periodic timer
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       final now = DateTime.now();
//       setState(() {
//         timeLeft = bookingStartTime.difference(now);

//         if (timeLeft <= Duration.zero) {
//           timer.cancel(); // Stop timer when time reaches zero
//           _showBookingStartedNotification();
//         } else if (timeLeft <= Duration(minutes: 30)) {
//           _showReminderNotification();
//         }
//       });
//     });
//   }

//   void _showReminderNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'reminder_channel', // Channel ID
//       'Reminders', // Channel name
//       channelDescription: 'Reminders for booking',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await localNotifications.show(
//       0, // Notification ID
//       'Reminder: Time is running out!',
//       'Only 30 minutes left until your booking starts.',
//       notificationDetails,
//     );
//   }

//   void _showBookingStartedNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'started_channel', // Channel ID
//       'Started Booking', // Channel name
//       channelDescription: 'Notification for when booking starts', 
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await localNotifications.show(
//       1, // Notification ID
//       'Your booking has started!',
//       'Enjoy your session at the sports center.',
//       notificationDetails,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Countdown Timer'),
//       ),
//       body: Center(
//         child: timeLeft > Duration.zero
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Time until booking starts:",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     "${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               )
//             : Text(
//                 "Your booking has started!",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//       ),
//     );
//   }
// }