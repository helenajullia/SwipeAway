import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'HotelModel.dart';

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
    var screenSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      elevation: 4.0,
      margin: EdgeInsets.all(10), // Margin for the card
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image carousel with rounded corners and white borders
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3), // Thicker white border
              ),
              child: SizedBox(
                height: screenSize.height * 0.70, // Adjust the height as needed
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners for each image
                      child: Image.network(
                        widget.hotel.imageURLs[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  itemCount: widget.hotel.imageURLs.length,
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white, // Inactive dot color
                      activeColor: Colors.white, // Active dot color
                    ),
                  ),
                  control: SwiperControl(
                    color: Colors.white, // Arrow color
                  ),
                ),
              ),
            ),
            // Hotel name and city with info icon for the description
            Padding(
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
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${widget.hotel.city}, ${widget.hotel.county}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info icon button to show the full description
                  IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.black),
                    onPressed: _showFullDescription,
                  ),
                ],
              ),
            ),
            // Optional: Additional hotel details or actions
          ],
        ),
      ),
    );
  }

  // Method to show the full description in a dialog
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
}
