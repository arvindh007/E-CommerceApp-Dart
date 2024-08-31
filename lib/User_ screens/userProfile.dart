// profile_page.dart

import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String? userId;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const UserProfilePage({super.key, 
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
 title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2018/08/28/13/29/avatar-3637561_960_720.png',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customer', // Assuming this is a role or category, update as needed
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
             const SizedBox(height: 8),
            Text(
              'Username: ${username ?? ''}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${phone ?? ''}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${firstName ?? ''} ${lastName ?? ''}, customer at the Ecommerce Android Application.',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
