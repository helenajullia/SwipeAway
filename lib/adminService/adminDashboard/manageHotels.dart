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
    List<String> imageUrls = [];
    if (kIsWeb) {
      for (var image in _webImages) {
        var downloadURL = await uploadWebImage(image, hotels.id);
        if (downloadURL != null) imageUrls.add(downloadURL);
      }
    } else {
      for (var image in _mobileImages) {
        var downloadURL = await uploadMobileImage(image, hotels.id);
        if (downloadURL != null) imageUrls.add(downloadURL);
      }
    }

    // Update Firestore document with image URLs
    if (imageUrls.isNotEmpty) {
      await hotels.update({'imageURLs': imageUrls});
    }
  }

  // Helper methods for image upload
  Future<String?> uploadWebImage(Uint8List image, String hotelId) async {
    String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref('gs://swipeaway-7195c.appspot.com/$hotelId/$fileName');
    try {
      await storageRef.putData(image, SettableMetadata(contentType: 'image/jpeg'));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading web image: $e');
      return null;
    }
  }

  Future<String?> uploadMobileImage(File image, String hotelId) async {
    String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref('gs://swipeaway-7195c.appspot.com/$hotelId/$fileName');
    try {
      await storageRef.putFile(image, SettableMetadata(contentType: 'image/jpeg'));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading mobile image: $e');
      return null;
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        if (kIsWeb) {
          // For web, read all images as bytes and add to _webImages
          List<Uint8List> loadedImages = await Future.wait(selectedImages.map((xFile) => xFile.readAsBytes()));
          setState(() {
            _webImages = loadedImages;
          });
        } else {
          // For mobile, convert paths to File and add to _mobileImages
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
        title: Text('Add Hotel', style: GoogleFonts.lobster()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: pickImages,
                child: Text('Pick Image'),
              ),
              if (kIsWeb)
                ..._webImages.map((image) => Image.memory(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )),
              // Displaying mobile images if not on web
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}