import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class RentalCountdown extends StatefulWidget {
  final String rentalDate; // Format: YYYY-MM-DD
  final String startTime; // Format: HH:mm (24-hour format)
  final String endTime; // Format: HH:mm (24-hour format)

  RentalCountdown({
    required this.rentalDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  _RentalCountdownState createState() => _RentalCountdownState();
}

class _RentalCountdownState extends State<RentalCountdown> {
  late DateTime rentalStartTime;
  late DateTime rentalEndTime;
  Duration timeLeft = Duration.zero;
  late Timer _timer;
  bool rentalStarted = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _parseRentalTimes();
    _scheduleRentalNotifications();
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

  void _parseRentalTimes() {
    rentalStartTime = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.rentalDate} ${widget.startTime}",
    );
    rentalEndTime = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.rentalDate} ${widget.endTime}",
    );
  }

  void _scheduleRentalNotifications() {
    print("Scheduling rental start notification for: $rentalStartTime");
    scheduleNotification(
      0,
      'Rental Started',
      'Your rental has started!',
      rentalStartTime,
    );

    DateTime notificationTime = rentalEndTime.subtract(Duration(minutes: 10));
    if (notificationTime.isAfter(DateTime.now())) {
      print("Scheduling rental ending soon notification for: $notificationTime");
      scheduleNotification(
        1,
        'Rental Ending Soon',
        'Your rental will end in 10 minutes!',
        notificationTime,
      );
    }

    print("Scheduling rental end notification for: $rentalEndTime");
    scheduleNotification(
      2,
      'Rental Ended',
      'Your rental has ended.',
      rentalEndTime,
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
          'rental_channel',
          'Rental Channel',
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
      if (now.isBefore(rentalStartTime)) {
        timeLeft = rentalStartTime.difference(now);
        rentalStarted = false;
      } else {
        timeLeft = rentalEndTime.difference(now);
        rentalStarted = true;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds <= 0 && rentalStarted) {
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
        title: Text('Rental Countdown'),
      ),
      body: Center(
        child: timeLeft > Duration.zero
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rentalStarted
                        ? "Your rental is ongoing!\nTime Left:"
                        : "Time until rental starts:",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey,
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              )
            : Text(
                "Rental has completed",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}