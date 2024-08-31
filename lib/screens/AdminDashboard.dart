import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../screens/userProfile.dart';
import '../common_widget/PopularMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './AddProdect.dart';
import './ViewProdect.dart';
import '../components/AppSignIn.dart';
import '../screens/HomeScreen.dart';
import '../screens/orders.dart';

class AdminDashboard extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phone;

  AdminDashboard({
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.phone,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int ProductsCount = 0;
  int AllUserCount = 0;

  @override
  void initState() {
    super.initState();
    getInitialCounts();
  }

  Future<void> getInitialCounts() async {
    ProductsCount = await getProductsCount();
    AllUserCount = await UserCount();
    setState(() {});
  }

  Future<int> getProductsCount() async {
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

  Future<int> UserCount() async {
    try {
      CollectionReference AllUser =
          FirebaseFirestore.instance.collection('AllUser');
      QuerySnapshot snapshot = await AllUser.get();
      return snapshot.docs.length;
    } catch (error) {
      print('Error fetching products: $error');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SalesData> salesData = [
      SalesData(month: 'Jan', amount: 100),
      SalesData(month: 'Feb', amount: 800),
      SalesData(month: 'Mar', amount: 300),
      SalesData(month: 'May', amount: 500),
      SalesData(month: 'June', amount: 1000),
      SalesData(month: 'July', amount: 1200),
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

    return Scaffold(
      drawer: MYDraw(
          userId: widget.userId,
          firstName: widget.firstName,
          lastName: widget.lastName,
          phone: widget.phone,
          username: widget.username),
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Your existing StatisticCard widgets
                StatisticCard(
                  title: 'Product',
                  value: ProductsCount.toString(),
                  color: Colors.green,
                  icon: Icons.shopping_cart,
                ),
                StatisticCard(
                  title: 'Users',
                  value: AllUserCount.toString(),
                  color: Colors.orange,
                  icon: Icons.person,
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
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Orders(
                          title: 'Orders',
                          value: 'Error',
                          color: Colors.red,
                          icon: Icons.error_outline,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Orders(
                          title: 'Orders',
                          value: 'Loading...',
                          color: Colors.blue,
                          icon: Icons.hourglass_empty,
                        );
                      }

                      final orderCount = snapshot.data!.docs.length;

                      return Orders(
                        title: 'Orders',
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
          PopularMenu(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Orders(
                    title: 'Category',
                    value: '5',
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
      {required this.title,
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
      {required this.title,
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

  MYDraw({
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
                  builder: (context) => AdminDashboard(
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
            title: Text('Home Screen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Products'),
            onTap: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProduct(),
                  ),
                );
              } catch (e) {
                print("Navigation error: $e");
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.list),
            title: Text('Add Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrderPage(
                    userId: userId,
                  ),
                ),
              );
            },
          ),

          // Account product
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Account'),
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
