import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'HotelModel.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  HotelCard({
    required this.hotel,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  _HotelCardState createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildImageCarousel(screenSize),
            _buildHotelDetails(),
            _buildPriceButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: SizedBox(
        height: screenSize.height * 0.66,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.hotel.imageURLs[index],
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: widget.hotel.imageURLs.length,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: Colors.white,
            ),
          ),
          control: SwiperControl(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHotelDetails() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.hotel.name,
                  style: TextStyle(
                    fontSize: 22.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${widget.hotel.city}, ${widget.hotel.county}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // Here you can add more details like room count or other amenities
              ],
            ),
          ),
          // This is the info button
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: _showFullDescription,
          ),
        ],
      ),
    );
  }

  void _showFullDescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Description'),
        content: SingleChildScrollView(
          child: Text(widget.hotel.description),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceButton() {
    return Center( // Use Center to align the button to the middle
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black, // Background color
            onPrimary: Colors.white, // Text color
            textStyle: GoogleFonts.roboto(fontSize: 14), // Font size and style
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0), // Padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            side: BorderSide(color: Colors.white, width: 2), // Border width and color
            minimumSize: Size(200, 40), // Set a fixed width for the button
          ),
          onPressed: _showPriceDialog,
          child: Text(
            'View Price/Night',
            style: GoogleFonts.roboto(), // Roboto font
          ),
        ),
      ),
    );
  }

  void _showPriceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Price Details', style: GoogleFonts.roboto()),
          content: Text(
            'Single Room: ${widget.hotel.pricePerSingleRoomPerNight} RON\n'
                'Double Room: ${widget.hotel.pricePerDoubleRoomPerNight} RON',
            style: GoogleFonts.roboto(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                  'Close', style: GoogleFonts.roboto(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
