import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HotelService extends StatefulWidget {
  @override
  _HotelServiceState createState() => _HotelServiceState();
}

class _HotelServiceState extends State<HotelService> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countyController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _singleRoomsController = TextEditingController();
  final TextEditingController _doubleRoomsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _webImage;
  File? _mobileImage;

  Future<void> addHotel() async {
    final String name = _nameController.text;
    final String county = _countyController.text;
    final String city = _cityController.text;
    final int? singleRooms = int.tryParse(_singleRoomsController.text);
    final int? doubleRooms = int.tryParse(_doubleRoomsController.text);
    final String description = _descriptionController.text;

    if (singleRooms == null || doubleRooms == null) {
      // Handle error, show message to user
      return;
    }

    DocumentReference hotels = FirebaseFirestore.instance.collection('hotels').doc();
    await hotels.set({
      'name': name,
      'county': county,
      'city': city,
      'singleRooms': singleRooms,
      'doubleRooms': doubleRooms,
      'description': description,
    });

    // Different upload logic for web and mobile
    if (kIsWeb) {
      if (_webImage != null) {
        try {
          await FirebaseStorage.instance
              .ref('gs://swipeaway-7195c.appspot.com/${hotels.id}')
              .putData(_webImage!);

          String downloadURL = await FirebaseStorage.instance
              .ref('gs://swipeaway-7195c.appspot.com/${hotels.id}')
              .getDownloadURL();

          await hotels.update({
            'imageURL': downloadURL,
          });
        } catch (e) {
          print(e);
        }
      }
    } else {
      if (_mobileImage != null) {
        try {
          await FirebaseStorage.instance
              .ref('gs://swipeaway-7195c.appspot.com/${hotels.id}')
              .putFile(_mobileImage!);

          String downloadURL = await FirebaseStorage.instance
              .ref('gs://swipeaway-7195c.appspot.com/${hotels.id}')
              .getDownloadURL();

          await hotels.update({
            'imageURL': downloadURL,
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
      if (selected != null) {
        setState(() {
          if (kIsWeb) {
            selected.readAsBytes().then((value) {
              _webImage = value; // For web, use Uint8List
            });
          } else {
            _mobileImage = File(selected.path); // For mobile, use File
          }
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotel', style: GoogleFonts.lobster()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              if (kIsWeb && _webImage != null)
                Image.memory(
                  _webImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              if (!kIsWeb && _mobileImage != null)
                Image.file(
                  _mobileImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Hotel Name'),
              ),
              TextField(
                controller: _countyController,
                decoration: InputDecoration(labelText: 'County'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _singleRoomsController,
                decoration: InputDecoration(labelText: 'Number of Single Rooms'),
                keyboardType: TextInputType.number, // For numeric input
              ),
              TextField(
                controller: _doubleRoomsController,
                decoration: InputDecoration(labelText: 'Number of Double Rooms'),
                keyboardType: TextInputType.number, // For numeric input
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3, // To allow for longer descriptions
              ),
              ElevatedButton(
                onPressed: addHotel,
                child: Text('Add Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

