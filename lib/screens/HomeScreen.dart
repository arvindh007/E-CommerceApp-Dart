// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup/screens/EditProduct.dart';
import 'package:flutter/material.dart';
import '../common_widget/TopPromoSlider.dart';
import '../common_widget/PopularMenu.dart';
import './AdminDashboard.dart';
import './AddProdect.dart';
import './ViewProdect.dart';
import '../components/AppSignIn.dart';

class ProductDetailPage extends StatefulWidget {
  final DocumentSnapshot productSnapshot;

  const ProductDetailPage({Key? key, required this.productSnapshot})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productSnapshot['ProductName'] ?? 'No name',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(widget.productSnapshot['Image'] ?? ''),
          ),
          Text(
            widget.productSnapshot['ProductName'] ?? 'No name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(widget.productSnapshot['Description'] ?? 'No description'),
          Text(
            '\$${widget.productSnapshot['Price']}' ?? 'No price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Update product status to false
                  widget.productSnapshot.reference.update({'status': false});
                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product deleted successfully')),
                  );
                  // Navigate back after update
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    // Other text style properties if needed
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                        productSnapshot: widget.productSnapshot,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    // Other text style properties if needed
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _BrandHomePageState createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<MyHomePage> {
  List<dynamic> products = [];
  TextEditingController searchController = TextEditingController();
  Future<void> fetchProductsFromFirebase() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      setState(() {
        products = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the 'Image' field is empty or null
          if (data['Image'] == null || data['Image'].isEmpty) {
            data['Image'] = 'Image not available';
          }
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error fetching products: $e');
      // Handle the error here
    }
  }

  late Stream<QuerySnapshot> productsStream;

  @override
  void initState() {
    super.initState();
    productsStream = FirebaseFirestore.instance
        .collection('product')
        .where('status', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products List',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              showCursor: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF666666),
                  size: 17,
                ),
                fillColor: Color(0xFFF2F3F5),
                hintStyle: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: 'Roboto-Light.ttf',
                  fontSize: 14,
                ),
                hintText: "What would you like to buy?",
              ),
            ),
          ),
          TopPromoSlider(),
          PopularMenu(),
          StreamBuilder<QuerySnapshot>(
            stream: productsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final documents = snapshot.data!.docs;
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final product =
                        documents[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productSnapshot: documents[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(product['Image']),
                            ),
                            Text(
                              product['ProductName'] ?? 'No name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(product['Description'] ?? 'No description'),
                            Text(
                              '\$${product['Price']}' ?? 'No price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MYDraw extends StatelessWidget {
  const MYDraw({super.key});

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
                  'Saleem Malik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'saleemalik444@gmail.com',
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
                  builder: (context) => AdminDashboard(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Product'),
            onTap: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductScreen(),
                  ),
                );
              } catch (e) {
                
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('View Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProduct(),
                ),
              );
            },
          ),
          // edit Prodct
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProduct(),
                ),
              );
            },
          ),
          // delete product
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProduct(),
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
