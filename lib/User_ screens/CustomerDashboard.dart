// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup/User_%20screens/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './ViewProduct.dart';
import './viewCart.dart';
import './myOrder.dart';

import '../components/AppSignIn.dart';

class CustomerDashboard extends StatelessWidget {
  final String? userId;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const CustomerDashboard({
    super.key,
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.phone,
  });
  @override
  Widget build(BuildContext context) {
    List<SalesData> salesData = [
      SalesData(month: 'Jan', amount: 100),
      SalesData(month: 'Feb', amount: 800),
      SalesData(month: 'Mar', amount: 300),
      SalesData(month: 'May', amount: 500),
      SalesData(month: 'June', amount: 1000),
      SalesData(month: 'July', amount: 1200),
      // Add more data as needed
    ];
    List<charts.Series<SalesData, String>> seriesList = [
      charts.Series(
        id: 'Sales',
        data: salesData,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.amount,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (SalesData sales, _) =>
            '${sales.month}: ${sales.amount}',
      ),
    ];
    Future<int> fetchProductsCount() async {
      try {
        CollectionReference product =
            FirebaseFirestore.instance.collection('product');
        QuerySnapshot snapshot =
            await product.where('status', isEqualTo: true).get();
        print('Product Count with status true: ${snapshot.docs.length}');
        return snapshot.docs.length;
      } catch (error) {
        print('Error fetching products: $error');
        return 0;
      }
    }

    return Scaffold(
      drawer: MYDraw(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        username: username,
      ),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FutureBuilder<int>(
                    future: fetchProductsCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        int productCount = snapshot.data ?? 0;
                        return Orders(
                          title: 'Product Available',
                          value: productCount.toString(),
                          color: Colors.green,
                          icon: Icons.shopping_cart,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where('UserId', isEqualTo: userId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Orders(
                          title: 'Your Orders',
                          value: 'Error',
                          color: Colors.red,
                          icon: Icons.error_outline,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Orders(
                          title: 'Your Orders',
                          value: 'Loading...',
                          color: Colors.blue,
                          icon: Icons.hourglass_empty,
                        );
                      }

                      final orderCount = snapshot.data!.docs.length;

                      return Orders(
                        title: 'Your Orders',
                        value: orderCount.toString(),
                        color: Colors.orange,
                        icon: Icons.local_mall,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Orders(
                    title: 'Category',
                    value: '4',
                    color: Color.fromARGB(221, 90, 130, 4),
                    icon: Icons.local_mall,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SizedBox(
              height: 350,
              child: charts.BarChart(
                seriesList,
                animate: true,
                vertical: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  final String month;
  final int amount;

  SalesData({required this.month, required this.amount});
}

class Orders extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const Orders(
      {super.key,
      required this.title,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 100,
      width: 350,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 7),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const StatisticCard(
      {super.key,
      required this.title,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 7),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
          SizedBox(width: 7),
        ],
      ),
    );
  }
}

class MYDraw extends StatelessWidget {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? username;

  const MYDraw({
    super.key,
    this.userId,
    this.firstName,
    this.lastName,
    this.phone,
    this.username,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.network(
                          'https://cdn.pixabay.com/photo/2018/08/28/13/29/avatar-3637561_960_720.png')
                      .image,
                ),
                SizedBox(height: 8),
                Text(
                  '${firstName ?? ""} ${lastName ?? ""}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '$phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDashboard(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    username: username,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          userId: userId,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewCartPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('My Orders'),
            onTap: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrderPage(
                      userId: userId,
                    ),
                  ),
                );
              } catch (e) {}
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Accounts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    username: username,
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppSignIn(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
