import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrderPage extends StatelessWidget {
  final String? userId;

  const MyOrderPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('product')
                    .doc(order['ProductId'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Card(
                      child: ListTile(
                        title: Text('Loading...'),
                      ),
                    );
                  }

                  if (productSnapshot.hasError) {
                    return Card(
                      child: ListTile(
                        title: Text('Error: ${productSnapshot.error}'),
                      ),
                    );
                  }

                  final productData =
                      productSnapshot.data!.data() as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      title: Text(productData['ProductName']),
                      subtitle: Text('Price: \$${productData['Price']}'),
                      // Display other product details as needed
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
