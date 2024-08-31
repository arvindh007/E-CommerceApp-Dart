// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class drumProduct extends StatefulWidget {
  const drumProduct({Key? key}) : super(key: key);

  @override
  _drumProductState createState() => _drumProductState();
}

class _drumProductState extends State<drumProduct> {
  late Stream<QuerySnapshot> productsStream;

  @override
  void initState() {
    super.initState();
    productsStream = FirebaseFirestore.instance
        .collection('product')
        .where('Catagory', isEqualTo: 'drum'.trim())
        .where('status', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'drum Products List',
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
        title: Text(widget.productSnapshot['ProductName'] ?? 'No name'),
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
                child: Text('Add to Cart'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Order'),
                        content:
                            Text('Are you sure you want to place this order?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // Save data to a new collection or update an existing one
                                await FirebaseFirestore.instance
                                    .collection('Orders')
                                    .add({
                                  'UserId':
                                      'jQUY47EaPywbj3zXyQpW', // Saving the userId
                                  'ProductId': widget.productSnapshot.id,
                                  'ProductName':
                                      widget.productSnapshot['ProductName'],
                                  'Description':
                                      widget.productSnapshot['Description'],
                                  'Price': widget.productSnapshot['Price'],
                                  // Add more fields as needed
                                });

                                // Close the dialog
                                Navigator.of(context).pop();

                                // Show a success message or navigate to a success page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order placed successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (error) {
                                print('Error placing order: $error');
                                // Handle the error appropriately, e.g., show an error message
                                // ...
                              }
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: Text(
                  'Order Now',
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
