import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCartPage extends StatefulWidget {
  const ViewCartPage({super.key});

  @override
  _ViewCartPageState createState() => _ViewCartPageState();
}

class _ViewCartPageState extends State<ViewCartPage> {
  List<String> cartItems = [];
  Future<void> _placeOrder() async {
    // Save data to a new collection or update an existing one in Firebase
    for (var item in cartItems) {
      var itemDetails = item.split(", ");
      // Extracting details
      String productId = itemDetails[0].split(": ")[1]; // Extracting productId
      String productName =
          itemDetails[1].split(": ")[1]; // Extracting the product name
      String description =
          itemDetails[2].split(": ")[1]; // Extracting the description
      String price = itemDetails[3].split(": ")[1]; // Extracting the price
      String imageUrl =
          itemDetails[4].split(": ")[1]; // Extracting the image URL

      await FirebaseFirestore.instance.collection('Orders').add({
        'UserId': 'jQUY47EaPywbj3zXyQpW',
        'ProductId': productId,
        'ProductName': productName,
        'Description': description,
        'Price': price,
        // Add more fields as needed
      });
    }

    // Clear SharedPreferences (set the cartProducts key to null)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartProducts');

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ViewCartPage(),
      ),
    );
    // Navigate to a success page or perform other actions
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored product data
    String? storedProductData = prefs.getString('cartProducts');

    if (storedProductData != null) {
      try {
        // Parse the stored JSON string
        Map<String, dynamic> productData = json.decode(storedProductData);

        // Extract the productId and productData separately
        String productId = productData['productId'] ?? '';
        Map<String, dynamic> actualProductData =
            productData['productData'] ?? {};

        // Extract individual product details from productData
        String productName = actualProductData['ProductName'] ?? '';
        String description = actualProductData['Description'] ?? '';
        String price = actualProductData['Price'] ?? '';
        String category = actualProductData['Catagory'] ?? '';
        bool status = actualProductData['status'] ?? false;

        String item =
            'Product ID: $productId, Product: $productName, Description: $description, Price: $price, Category: $category, Status: $status';

        setState(() {
          cartItems.add(item);
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      // Data doesn't exist in SharedPreferences
      print('No product data found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
          'View Cart',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items in Cart:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (cartItems.isEmpty)
              const Text('Your cart is empty.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var itemDetails = cartItems[index].split(", ");

                    // Extracting details
                    String productId =
                        itemDetails[0].split(": ")[1]; // Extracting productId
                    String productName = itemDetails[1]
                        .split(": ")[1]; // Extracting the product name
                    String description = itemDetails[2]
                        .split(": ")[1]; // Extracting the description
                    String price =
                        itemDetails[3].split(": ")[1]; // Extracting the price
                    String imageUrl = itemDetails[4]
                        .split(": ")[1]; // Extracting the image URL

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              imageUrl), // Display the product image
                        ),
                        title: Text(productName), // Display the product name
                        subtitle: Text(
                            description), // Display the product description
                        trailing: Text(price), // Display the product price
                        // You can add more details like quantity, etc.
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            // Aligning the button to the right
            if (cartItems
                .isNotEmpty) // Only show the button when cart is not empty
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Order'),
                          content: const Text(
                              'Are you sure you want to place this order?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Place the order
                                await _placeOrder();

                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Complete Order'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
