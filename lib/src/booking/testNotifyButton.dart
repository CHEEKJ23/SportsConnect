import 'package:flutter/material.dart';

import '../booking/testNotification.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();

  runApp(const testNotifyButton());
}

class testNotifyButton extends StatelessWidget {
  const testNotifyButton({super.key});

   @override
   Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: () async {
         return true; // Allow back navigation
       },
       child: Scaffold(
         appBar: AppBar(
           title: Text('Page Title'),
         ),
         body: Center(
  child: Home(), // Use 'child' instead of 'home'
),
       ),
     );
   }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
  
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationService.showInstantNotification(
                    "Instant Notification", "This shows an instant notifications");
              },
              child: const Text('Show Notification'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                DateTime scheduledDate = DateTime.now().add( const Duration(seconds: 5));
                NotificationService.scheduleNotification(
                  0,
                  "Scheduled Notification",
                  "This notification is scheduled to appear after 5 seconds",
                  scheduledDate,
                );
              },
              child: const Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}