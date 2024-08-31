// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_setup/User_%20screens/CustomerDashboard.dart';
import 'package:flutter/material.dart';
import '../components/AppSingUp.dart';
import '../screens/AdminDashboard.dart';

String phone = '';
String _password = '';

class AppSignIn extends StatefulWidget {
  const AppSignIn({super.key});

  @override
  _AppSignInState createState() => _AppSignInState();
}

class _AppSignInState extends State<AppSignIn> {
  bool obscureText = true; // State variable to manage text obscuring
  TextEditingController passwordController =
      TextEditingController(); // Controller for password field

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.close),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 130,
                      alignment: Alignment.center,
                      child: Image.network(
                          'https://cdn0.iconfinder.com/data/icons/gradak-finance-flad/32/ecommerce-21-512.png'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
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
                          Icons.person,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "User Name",
                      ),
                      onChanged: (value) {
                        phone = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: obscureText,
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
                        fillColor: Color(0xFFF2F3F5),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize,
                        ),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (passwordController.text.isEmpty ||
                              phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill all the fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            checkCredentials(phone, passwordController.text)
                                .then((userData) {
                              if (userData != null) {
                                String username = userData['UserName'];
                                String firstName = userData['FirstName'];
                                String lastName = userData['LastName'];
                                String email = userData['Phone'];
                                String role = userData['Role'];
                                String userId =
                                    userData['id']; // Get the user ID

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login Successful'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                if (role == 'Admin') {
                                  // Navigate to the admin dashboard
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminDashboard(
                                        userId: userId,
                                        username: username,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phone: email,
                                      ),
                                    ),
                                  );
                                } else if (role == 'User') {
                                  // Navigate to the user dashboard
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerDashboard(
                                        // Pass necessary parameters if needed
                                        userId: userId,
                                        username: username,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phone: email,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Login Failed. Invalid credentials.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(17.0),
                          backgroundColor:
                              const Color.fromRGBO(27, 117, 188, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Color.fromRGBO(27, 117, 188, 1)),
                          ),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins-Medium.ttf',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppSingUp()),
                          )
                        },
                        child: Container(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromRGBO(27, 117, 188, 1),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> checkCredentials(
    String phoneNumber, String password) async {
  CollectionReference allUserCollection =
      FirebaseFirestore.instance.collection('AllUser');

  QuerySnapshot querySnapshot = await allUserCollection
      .where('UserName', isEqualTo: phoneNumber)
      .where('Password', isEqualTo: password)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Get the first document in the query result
    DocumentSnapshot userData = querySnapshot.docs.first;

    // Extract the user data and ID
    String userId = userData.id;
    Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
    userDataMap['id'] = userId; // Add user ID to userDataMap

    // Return the user data along with the ID
    return userDataMap;
  } else {
    // If credentials are invalid or no user found, return null or handle accordingly
    return null;
  }
}
