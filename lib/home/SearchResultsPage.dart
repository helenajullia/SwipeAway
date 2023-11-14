import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Hotel> searchResults;

  SearchResultsPage({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return HotelCard(hotel: searchResults[index]);
        },
      ),
    );
  }
}
