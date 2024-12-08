import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:timezone/data/latest.dart' as tz; // Import the timezone data

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class BookingCountdown extends StatefulWidget {
  final String bookingDate; // Format: YYYY-MM-DD
  final String startTime; // Format: HH:mm (24-hour format)
  final String endTime; // Format: HH:mm (24-hour format)

  BookingCountdown({
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  _BookingCountdownState createState() => _BookingCountdownState();
}

class _BookingCountdownState extends State<BookingCountdown> {
  late DateTime bookingStartTime;
  late DateTime bookingEndTime;
  Duration timeLeft = Duration.zero;
  late Timer _timer;
  bool bookingStarted = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _parseBookingTimes();
    _scheduleBookingNotifications();
    _updateTimeLeft();
    _startTimer();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones(); // Initialize time zones
  }

  void _parseBookingTimes() {
    bookingStartTime = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.bookingDate} ${widget.startTime}",
    );
    bookingEndTime = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.bookingDate} ${widget.endTime}",
    );
  }

  void _scheduleBookingNotifications() {
    scheduleNotification(
      1,
      'Booking Started',
      'Your booking has started!',
      bookingStartTime,
    );

    scheduleNotification(
      2,
      'Booking Completed',
      'Your booking has completed!',
      bookingEndTime,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  void _updateTimeLeft() {
    setState(() {
      final now = DateTime.now();
      if (now.isBefore(bookingStartTime)) {
        timeLeft = bookingStartTime.difference(now);
        bookingStarted = false;
      } else {
        timeLeft = bookingEndTime.difference(now);
        bookingStarted = true;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds <= 0 && bookingStarted) {
        timer.cancel();
      } else {
        _updateTimeLeft();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Countdown'),
      ),
      body: Center(
        child: timeLeft > Duration.zero
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bookingStarted
                        ? "Your booking has started!\nTime Left:"
                        : "Time until booking starts:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal,color: Colors.blueGrey,fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              )
            : Text(
                "Booking has completed",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}