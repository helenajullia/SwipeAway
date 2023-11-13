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

  List<Uint8List> _webImages = [];
  List<File> _mobileImages = [];

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

    DocumentReference hotels = FirebaseFirestore.instance.collection('hotels')
        .doc();
    await hotels.set({
      'name': name,
      'county': county,
      'city': city,
      'singleRooms': singleRooms,
      'doubleRooms': doubleRooms,
      'description': description,
    });

    // Different upload logic for web and mobile
  }
  Future<void> pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        if (kIsWeb) {
          // Wait for all async operations to complete and then update the state
          List<Uint8List> loadedImages = await Future.wait(selectedImages.map((xFile) => xFile.readAsBytes()));
          setState(() {
            _webImages = loadedImages;
          });
        } else {
          setState(() {
            _mobileImages = selectedImages.map((xFile) => File(xFile.path)).toList();
          });
        }
      } else {
        print('No images selected');
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add Hotel', style: GoogleFonts.roboto()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: pickImages,
                child: Text('Pick Images'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
              if (kIsWeb)
                ..._webImages.map((image) => Image.memory(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )),
              if (!kIsWeb)
                ..._mobileImages.map((image) => Image.file(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

