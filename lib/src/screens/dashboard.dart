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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/screens/screens.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shop/src/screens/dashboard.dart';

List<String> imageFiles = [
'badminton.jpg',
'basketball.jpg',
'futsal.jpg',
'tennis.jpeg',
'volleyball.jpg',
'pingpong.jpg',
'pickleball.jpg',
];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});


  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

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
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              iconSize: 21,
              icon: const Icon(Fryo.magnifier),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              iconSize: 21,
              icon: const Icon(Fryo.alarm),
            )
          ],
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
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

Widget storeTab(BuildContext context) {
  // TODO: will pick it up from here, am to start another template
  List<Product> foods = [
    Product(
        name: 'Hamburger',
        image: 'assets/images/hamburger.png',
        price: '\$25.00',
        userLiked: true,
        discount: 10),
    Product(
        name: 'Pasta',
        image: 'assets/images/pasta.png',
        price: '\$150.00',
        userLiked: false,
        discount: 7.8),
    Product(
      name: 'Akara',
      image: 'assets/images/akara.png',
      price: '\$10.99',
      userLiked: false,
    ),
    Product(
        name: 'Strawberry',
        image: 'assets/images/strawberry.png',
        price: '\$50.00',
        userLiked: true,
        discount: 14)
  ];

  List<Product> drinks = [
    Product(
        name: 'Coca-Cola',
        image: 'assets/images/coca-cola.png',
        price: '\$45.12',
        userLiked: true,
        discount: 2),
    Product(
        name: 'Lemonade',
        image: 'assets/images/lemonade.png',
        price: '\$28.00',
        userLiked: false,
        discount: 5.2),
    Product(
        name: 'Vodka',
        image: 'assets/images/vodka.png',
        price: '\$78.99',
        userLiked: false),
    Product(
        name: 'Tequila',
        image: 'assets/images/tequila.png',
        price: '\$168.99',
        userLiked: true,
        discount: 3.4)
  ];

  return ListView(children: <Widget>[
    HeaderTopCarouselWidget(),
    headerTopCategories(),
    deals('Hot Deals', onViewMore: () {}, items: <Widget>[
      foodItem(foods[0], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: foods[0],
              );
            },
          ),
        );
      }, onLike: () {}),
      foodItem(foods[1], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: foods[1],
              );
            },
          ),
        );
      }, imgWidth: 250, onLike: () {}),
      foodItem(foods[2], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: foods[2],
              );
            },
          ),
        );
      }, imgWidth: 200, onLike: () {}),
      foodItem(foods[3], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: foods[3],
              );
            },
          ),
        );
      }, onLike: () {}),
    ]),
    deals('Drinks Parol', onViewMore: () {}, items: <Widget>[
      foodItem(drinks[0], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: drinks[0],
              );
            },
          ),
        );
      }, onLike: () {}, imgWidth: 60),
      foodItem(drinks[1], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: drinks[1],
              );
            },
          ),
        );
      }, onLike: () {}, imgWidth: 75),
      foodItem(drinks[2], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: drinks[2],
              );
            },
          ),
        );
      }, imgWidth: 110, onLike: () {}),
      foodItem(drinks[3], onTapped: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductPage(
                productData: drinks[3],
              );
            },
          ),
        );
      }, onLike: () {}),
    ]),
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
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: items ??
                [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'No items available at this moment.',
                      style: taglineText,
                    ),
                  ),
                ],
          ),
        ),
      ],
    ),
  );
}




// mhesham1@gmail.com