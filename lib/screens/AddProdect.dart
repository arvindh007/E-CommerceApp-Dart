// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_final_fields
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './DataBaseFunctions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController CatagoeryController = TextEditingController();

  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _image;
  String ImageUrl = '';
  String UploadUrl = '';
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print(_image!.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<String?> uploadImageAndGetUrl(File localFile, String imageName) async {
    try {
      print('Uploading file: ${localFile.path}');
      final FirebaseStorageReference =
          FirebaseStorage.instance.ref().child('product/$imageName.jpg');
      print('Storage reference: ${FirebaseStorageReference.fullPath}');
      await FirebaseStorageReference.putFile(localFile);
      final downloadUrl = await FirebaseStorageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> pickerAndUpload() async {
    await _pickImage();
    if (_image != null) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      String? imageUrl = await uploadImageAndGetUrl(_image!, imageName);
      if (imageUrl != null) {
        setState(() {
          UploadUrl = imageUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image first'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (UploadUrl.isNotEmpty) {
          print('Uploading file: $UploadUrl');
        }
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('product').add({
          'ProductName': _nameController.text,
          'Price': _priceController.text,
          'Description': _descriptionController.text,
          'Image': UploadUrl,
          'status': true,
          'Catagory': SelectedItem.trim(),
        });
        _Adding_Data_Using_Sheard_Prefrenes();
        _Adding_Data_Using_Sqlite();
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _image = null;
        showAboutDialog(
          context: context,
          applicationName: 'Product Added',
          applicationVersion: '1.0.0',
          applicationIcon: Icon(Icons.add),
          children: [
            Text('Product Added Successfully'),
          ],
        );
      } catch (e) {
        print('Error adding product: $e');
      }
    }
  }

  Future<void> _Adding_Data_Using_Sqlite() async {
    // Create a Model instance with the data you want to save
    Model newProdect = Model(
      ProdectName: _nameController.text,
      Price: _priceController.text,
      Description: _descriptionController.text,
      Image: UploadUrl,
    );
// Create a DbManager instance
    DbManager dbManager = DbManager();
    int? result = await dbManager.insertData(newProdect);
    if (result != null && result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _Adding_Data_Using_Sheard_Prefrenes() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (UploadUrl.isNotEmpty) {
          print('Uploading file: $UploadUrl');
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('ProdectName', _nameController.text);
        await prefs.setString('Price', _priceController.text);
        await prefs.setString('Description', _descriptionController.text);
        await prefs.setString('Image', UploadUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added successfully'),
            duration: Duration(seconds: 10),
          ),
        );
      } catch (e) {
        print('Error adding product: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Update the icon color
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
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
                    Icons.production_quantity_limits,
                    color: Color(0xFF666666),
                    size: defaultIconSize,
                  ),
                  fillColor: Color(0xFFF2F3F5),
                  hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize,
                  ),
                  hintText: "Enter Product Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _priceController,
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
                    Icons.price_change_outlined,
                    color: Color(0xFF666666),
                    size: defaultIconSize,
                  ),
                  fillColor: Color(0xFFF2F3F5),
                  hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize,
                  ),
                  hintText: "Enter Product Price",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Please enter product price';
                  }
                  // You can add more specific validation for price if needed
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
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
                    Icons.description,
                    color: Color(0xFF666666),
                    size: defaultIconSize,
                  ),
                  fillColor: Color(0xFFF2F3F5),
                  hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize,
                  ),
                  hintText: "Enter Product Description",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Please enter product description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              DropdownMenuExample(),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  pickerAndUpload();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: Text(
                  'Pick Image and upload',
                  style: TextStyle(
                    color: Colors.white,
                    // Other text style properties if needed
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 100, // or any size you want
                height: 100, // or any size you want
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: kIsWeb // Check if running on web
                    ? Center(
                        child: Text('Image preview not available on web'),
                      )
                    : _image != null
                        ? Image.file(_image!,
                            fit: BoxFit.cover) // Load local file
                        : Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.white,
                    // Other text style properties if needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> list = <String>[
  ' Select Catagory',
  ' drum',
  ' violins',
  ' instrument',
  ' guitar',
];
var SelectedItem = '';

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});
  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          SelectedItem = dropdownValue;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
      width: 350,
    );
  }
}
