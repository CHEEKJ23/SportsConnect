import 'package:flutter/material.dart';
import '../screens/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBookingsPage(),
    );
  }
}
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer( // Removed 'const' here
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
  Widget buildHeader(BuildContext context) {
    return InkWell(
       onTap: (){
              Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            ));
            },
      child: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.only(
          top:24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage('https://mir-s3-cdn-cf.behance.net/project_modules/hd/1744a191472915.5e329f4376330.jpg'),
            ),
            SizedBox(height: 12),
            Text(
              'Thomas Shelby', 
              style: TextStyle(fontSize: 28,color: Colors.black),
            ),
            Text(
              'By Order Of the Peaky Blinders',
              style: TextStyle(fontSize: 16, color:Colors.black),
            )
          ],
        ),
      ),
    );
  }
    Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            ));
            },
          ),
          const Divider(color:Colors.black26),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: const Text('Favourite'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: const Text('Workflow'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.update),
            title: const Text('Update'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.book_online),
            title: const Text('Booking'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.car_rental),
            title: const Text('Rental'),
            onTap: (){},
          ),ListTile(
            leading: Icon(Icons.sell),
            title: const Text('Sell'),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}

class MyBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      drawer: const NavigationDrawer(),

      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 3, // Number of bookings
        itemBuilder: (context, index) {
          return BookingItem(
            label: 'Label',
            title: 'Booking ${index + 1}',
            description: 'Description Description',
            onCancel: () {
              // Handle cancel action here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Booking ${index + 1} cancelled')),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () =>Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(),
            )),
              child: Text('Home'),
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

class BookingItem extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final VoidCallback onCancel;

  const BookingItem({
    required this.label,
    required this.title,
    required this.description,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.red),
              ),
            ),
            
          ],
          
        ),
        
      ),
      
    );
    
  }
}
