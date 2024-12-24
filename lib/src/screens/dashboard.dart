import 'package:flutter/material.dart';

import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import '../shared/product.dart';
import '../shared/partials.dart';
import './product_page.dart';
import '../booking/booking.dart';
import '../booking/myBooking.dart' as myBooking; //side bar drawer is here
import '../rental/rental.dart';
import '../deals/deal.dart';
import '../deals/deal2.dart';
import '../activity/activity.dart';
import '../activity/joinActivity.dart';
import '../booking/myBooking.dart';
import '../reward/reward.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/screens/screens.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shop/src/screens/dashboard.dart';
import 'package:shop/src/screens/dashboardDealList.dart';
import 'package:shop/src/screens/dashboardActivityList.dart';

List<String> imageFiles = [
'pickleball.jpg',
'badminton.jpg',
'basketball.jpg',
'futsal.jpg',
'tennis.jpeg',
'volleyball.jpg',
'pingpong.jpg',
];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  List<dynamic> deals = [];
  
  @override
  void initState() {
    super.initState();
    // fetchAllDeals();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      storeTab(context),
      const Text('Tab2'),
      const Text('Tab3'),
      const Text('Tab4'),
      const Text('Tab5'),
    ];
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          // leading: IconButton(
          //   onPressed: () {},
          //   iconSize: 21,
          //   icon: const Icon(Fryo.funnel),
          // ),
          backgroundColor: primaryColor,
          title:
              const Text('SportsConnect', style: logoWhiteStyle, textAlign: TextAlign.center),
       
        ),
      drawer: myBooking.NavigationDrawer(),

        body: tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Fryo.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Fryo.book), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Fryo.gift), label: 'Rewards'),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green[600],
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to ChatListScreen when Chat tab is tapped
      Navigator.of(context).pushNamed(ChatListScreen.routeName);
    } 
     else if (index == 2) {
      
    Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => MyBookingsPage()), 
 );
    }
    else if (index == 3) {
      
    Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => RewardScreen()), 
 );
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

//  Future<void> fetchAllDeals() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');

//     if (token == null) {
//       print('Token is null. Redirecting to login.');
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8000/api/view/deals'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           deals = jsonDecode(response.body);
//         });
//         print('Fetched deals: ${response.body}');
//       } else {
//         print('Failed to fetch deals. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }


Widget storeTab(BuildContext context) {

  return ListView(children: <Widget>[
    HeaderTopCarouselWidget(),
    headerTopCategories(),
    deals('Hot Deals', onViewMore: () {}, items: <Widget>[
    ]), 
    SizedBox(height: 10),
    HorizontalDealsWidget(), 
    divider(),
    deals('Activities', onViewMore: () {}, items: <Widget>[
    ]), 
    SizedBox(height: 10),
    HorizontalActivitiesWidget(), 
    divider(),
  ]); 
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 15, top: 10,bottom:0),
        child: Text(headerTitle, style: h4),
      ),

    ],
  );
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('Featured', onViewMore: () {}),
      SizedBox(
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            // Booking Button
            Builder(
  builder: (context) {
    return headerCategoryItem('Booking', Fryo.book, onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingPage()),
        );
      },
    );
  },
),
Builder(
  builder: (context) {
    return headerCategoryItem('Rental', Fryo.move, onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RentalPage()),
        );
      },
    );
  },
),

            Builder(
              builder: (context) {
                return headerCategoryItem('Deals', Fryo.money, onPressed: () {
                    _showDealsDialog(context);

                });
              }
            ),




            Builder(
              builder: (context) {
                return headerCategoryItem('Chat', Fryo.list, onPressed: () {
                   Navigator.of(context).pushNamed(ChatListScreen.routeName);
                });
              }
            ),


              Builder(
              builder: (context) {
                return headerCategoryItem('Activity', Fryo.flag, onPressed: () {
                    _showAvtivitiesDialog(context);

                });
              }
            ),
          ],
        ),
      )
    ],
  );
}

 void _showDealsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Text("Would you like to Sell or Buy?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllDealsPage()),
        );
              },
              child: Text("Buy"),
            ),
            TextButton(
              onPressed: () {
                 Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateDealPage()),
        );
              },
              child: Text("Sell"),
            ),
          ],
        );
      },
    );
 }


 void _showAvtivitiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Text("Would you like to Create or Join?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateActivityPage()),
        );
              },
              child: Text("Create"),
            ),
            TextButton(
              onPressed: () {
                 Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JoinActivityPage()),
        );
              },
              child: Text("Join"),
            ),
          ],
        );
      },
    );
 }


Widget divider() {
  return
Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Divider(
        color: Colors.grey, // The color of the line
        thickness: 1,       // The thickness of the line
        indent: 10,         // Optional: add padding before the line starts
        endIndent: 10,      // Optional: add padding after the line ends
      ),
    );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: const EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text('$name >', style: categoryText)
      ],
    ),
  );





}//carousel
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
            itemExtent: MediaQuery.of(context).size.width - 32,
            itemSnapping: true,
            elevation: 5,
            padding: const EdgeInsets.all(8),
            children: List.generate(imageFiles.length, (int index) {
  return Container(
    color: Colors.grey,
    child: Image.asset(
      'assets/images/${imageFiles[index]}', // Dynamically load each image from the list
      fit: BoxFit.cover,
    ),
  );
}),
          ),
        ),
      ],
    );
  }
}


Widget deals(String dealTitle, {onViewMore, List<Widget>? items}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader(dealTitle, onViewMore: onViewMore),
        // SizedBox(
        //   height: 250,
        //   child: ListView(
        //     scrollDirection: Axis.horizontal,
        //     children: items ??
        //         [
        //           Container(
        //             margin: const EdgeInsets.only(left: 15),
        //             child: const Text(
        //               'No items available at this moment.',
        //               style: taglineText,
        //             ),
        //           ),
        //         ],
        //   ),
        // ),
      ],
    ),
  );
}