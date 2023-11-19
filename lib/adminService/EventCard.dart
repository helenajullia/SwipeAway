import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'EventModel.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  EventCard({
    required this.event,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
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
            _buildEventDetails(),
            _buildButtons(),
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
                widget.event.imageURLs[index],
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: widget.event.imageURLs.length,
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

  Widget _buildEventDetails() {
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
                  widget.event.name,
                  style: TextStyle(
                    fontSize: 22.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${widget.event.city}, ${widget.event.county}',
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
          child: Text(widget.event.description),
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

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPriceButton(),
        _buildBookNowButton(),
      ],
    );
  }

  Widget _buildPriceButton() {
    return Center( // Use Center to align the button to the middle
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black, // Text color
            textStyle: GoogleFonts.roboto(fontSize: 14), // Font size and style
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0), // Padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            side: BorderSide(color: Colors.white, width: 2), // Border width and color
            minimumSize: Size(180, 40), // Set a fixed width for the button
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

  Widget _buildBookNowButton() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 16.0, left: 8.0, top: 8.0, bottom: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.black,
            textStyle: GoogleFonts.roboto(fontSize: 14),
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(color: Colors.white, width: 2),
            minimumSize: Size(180, 40),
          ),
          onPressed: _handleBookNow,
          child: Text(
            'Book Now',
            style: GoogleFonts.roboto(),
          ),
        ),
      ),
    );
  }

  void _handleBookNow() {

  }

  void _showPriceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Price Details', style: GoogleFonts.roboto()),
          content: Text(
            'Single Room: ${widget.event.pricePerSingleRoomPerNight} RON\n'
                'Double Room: ${widget.event.pricePerDoubleRoomPerNight} RON',
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
