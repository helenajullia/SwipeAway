import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/home/saved_page.dart';
import 'package:swipe_away/home/viewEventsPage.dart';
import '../adminService/EventCard.dart';
import '../adminService/EventModel.dart';
import '../adminService/HotelModel.dart';
import '../adminService/HotelCard.dart';
import 'SearchResultsPage.dart';
import 'myAccount/myAccount_page.dart';
import 'package:card_swiper/card_swiper.dart';



class SearchPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _SearchPageState createState() => _SearchPageState();
}

SwiperController swiperController = SwiperController();

class _SearchPageState extends State<SearchPage> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int singleRoomCount = 0;
  int doubleRoomCount = 0;
  String? selectedCounty;
  int _currentIndex = 0;
  List<String> counties = [
    'Alba',
    'Arad',
    'Arges',
    'Bacau',
    'Bihor',
    'Bistrita-Nasaud',
    'Botosani',
    'Braila',
    'Brasov',
    'Bucuresti',
    'Buzau',
    'Calarasi',
    'Caras-Severin',
    'Cluj',
    'Constanta',
    'Covasna',
    'Dambovita',
    'Dolj',
    'Galati',
    'Giurgiu',
    'Gorj',
    'Harghita',
    'Hunedoara',
    'Ialomita',
    'Iasi',
    'Ilfov',
    'Maramures',
    'Mehedinti',
    'Mures',
    'Neamt',
    'Olt',
    'Prahova',
    'Salaj',
    'Satu Mare',
    'Sibiu',
    'Suceava',
    'Teleorman',
    'Timis',
    'Tulcea',
    'Valcea',
    'Vaslui',
    'Vrancea'
  ];

  List<Hotel>? searchResults; // Add this line
  List<Event>? searchEventResults;

  void performSearch() async {
    print("performSearch called");
    var results = await searchHotels();
    print("Found ${results.length} hotels");

    // Navigate to SearchResultsPage with the results
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(searchResults: results),
      ),
    );
  }


  void performEventSearch() async {
    print("performEventSearch called");
    try {
      var results = await searchEvents();
      print("Found ${results.length} events");

      if (results.isNotEmpty) {
        // Navighează la viewEventsPage cu rezultatele
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewEventsPage(searchEventResults: results),
          ),
        );
      } else {
        print('No events found');
        // Afișează un mesaj utilizatorului că nu sunt evenimente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No events found')),
        );
      }
    } catch (e) {
      print('Error while performing event search: $e');
      // Afișează un mesaj de eroare utilizatorului
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events')),
      );
    }
  }

  // Future<List<Event>> searchEvents() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();
  //     return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
  //   } catch (e) {
  //     print('Error fetching events: $e');
  //     return []; // Return an empty list on error
  //   }
  // }



  Future<List<Hotel>> searchHotels() async {
    // Fetch hotels from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('hotels').get();

    // Filter hotels based on search criteria
    return snapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>))
        .where((hotel) =>
    hotel.county == selectedCounty &&
        hotel.singleRooms >= singleRoomCount &&
        hotel.doubleRooms >= doubleRoomCount)
        .toList();

  }

  Future<List<Event>> searchEvents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();

      if (snapshot.docs.isEmpty) {
        print('Collection is empty.');
      } else {
        print('Collection is not empty.');
      }

      return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return []; // Return an empty list on error
    }
  }

  SwiperController swiperController = SwiperController();
  int previousIndex = -1; // Initialize with an invalid index


  Widget buildHotelCards(BuildContext context) {
    return Swiper(
      controller: swiperController,
      itemCount: searchResults!.length,
      itemBuilder: (BuildContext context, int index) {
        return HotelCard(
          hotel: searchResults![index],
          onSwipeLeft: () {
            // You may leave this empty if the swiper automatically handles swiping
          },
          onSwipeRight: () {
            // You may leave this empty if the swiper automatically handles swiping
          },
        );
      },
      layout: SwiperLayout.TINDER,
      itemWidth: MediaQuery.of(context).size.width,
      itemHeight: MediaQuery.of(context).size.height,
      loop: false,
      onIndexChanged: (index) {
        if (previousIndex >= 0 && previousIndex < searchResults!.length) {
          saveHotel(searchResults![previousIndex]);

          // Optional: Add additional logic to handle different swipe directions
          // This can be implemented using additional state variables or methods
        }

        // Update the previous index for the next swipe
        previousIndex = index;
      },
    );
  }

  Widget buildEventCards(BuildContext context) {
    // Check if searchEventResults is null or empty and handle accordingly
    if (searchEventResults == null || searchEventResults!.isEmpty) {
      // Display a message or an empty container when there are no events
      return Center(child: Text('No events available'));
    }
    return Swiper(
      controller: swiperController,
      itemCount: searchEventResults!.length,
      itemBuilder: (BuildContext context, int index) {
        return EventCard(
          event: searchEventResults![index],
          onSwipeLeft: () {
            // You may leave this empty if the swiper automatically handles swiping
          },
          onSwipeRight: () {
            // You may leave this empty if the swiper automatically handles swiping
          },
        );
      },
      layout: SwiperLayout.TINDER,
      itemWidth: MediaQuery.of(context).size.width,
      itemHeight: MediaQuery.of(context).size.height,
      loop: false,
      onIndexChanged: (index) {
        if (previousIndex >= 0 && previousIndex < searchEventResults!.length) {
          saveEvent(searchEventResults![previousIndex]);

          // Optional: Add additional logic to handle different swipe directions
          // This can be implemented using additional state variables or methods
        }

        // Update the previous index for the next swipe
        previousIndex = index;
      },
    );
  }


  void saveHotel(Hotel hotel) {
    // Logic to save the hotel details to Firestore or local storage
  }

  void saveEvent(Event event) {
    // Logic to save the hotel details to Firestore or local storage
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey2,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('View Events', style: GoogleFonts.roboto()),
              onTap: () {
                Navigator.of(context).pop(); // Închide sertarul
                performEventSearch(); // Apelează metoda pentru căutarea evenimentelor
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/SearchPage.jpeg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.90), // Darken the image
                      BlendMode.dstATop,
                    ),
                  ),
                ),
              ),
              // Positioned IconButton that will open the drawer
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => _scaffoldKey2.currentState?.openDrawer(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your existing widgets
                    Center(
                      child: Text(
                        "SwipeAway",
                        style: GoogleFonts.robotoSerif(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    buildCountyDropdown(),
                    const SizedBox(height: 12),
                    buildCheckInTextField(),
                    const SizedBox(height: 12),
                    buildCheckOutTextField(),
                    const SizedBox(height: 12),
                    buildRoomsRow(),
                    Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: performSearch, // Updated line

                        child: Text('Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  DropdownButtonHideUnderline buildCountyDropdown() {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedCounty,
            hint:  Text('Enter County', style: TextStyle(color: Colors.black.withOpacity(0.7)),),
            onChanged: (value) => setState(() => selectedCounty = value),
            items: counties.map((county) => DropdownMenuItem(value: county, child: Text(county))).toList(),
          ),
        ),
      ),
    );
  }
  TextField buildTextField(String hint, DateTime? date, Function() onTap) {
    // Check if dark mode is enabled
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: date?.toLocal().toString().split(' ')[0] ?? hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        suffixIcon: Icon(Icons.calendar_today, color: isDarkMode ? Colors.white : Colors.black),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black)),
        hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  TextField buildCheckInTextField() => buildTextField('Check-in Date', checkInDate, () async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            secondaryHeaderColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null && selectedDate != checkInDate) setState(() => checkInDate = selectedDate);
  });
  TextField buildCheckOutTextField() => buildTextField('Check-out Date', checkOutDate, () async {
    DateTime initialCheckoutDate = checkInDate?.add(Duration(days: 1)) ?? DateTime.now();
    DateTime firstCheckoutDate = initialCheckoutDate.isBefore(DateTime.now()) ? DateTime.now() : initialCheckoutDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialCheckoutDate, // Set initial date to the day after check in date or today if null
      firstDate: firstCheckoutDate, // Ensure we can't pick a date before the check in date
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            secondaryHeaderColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    // Set the state of checkOutDate to the new selection if it is after the checkInDate
    if (selectedDate != null && (checkInDate == null || selectedDate.isAfter(checkInDate!))) {
      setState(() => checkOutDate = selectedDate);
    }
  });

  Widget buildRoomSelectionRow(String roomType, int count, Function(bool) onSelectionChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$roomType Rooms",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.black),
                  onPressed: () => onSelectionChanged(false),
                ),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: () => onSelectionChanged(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildRoomsRow() {
    return Column(
      children: [
        buildRoomSelectionRow("Single", singleRoomCount, (bool increment) {
          setState(() {
            if (increment && singleRoomCount < 6) {
              singleRoomCount++;
            } else if (!increment && singleRoomCount > 0) {
              singleRoomCount--;
            }
          });
        }),
        const SizedBox(height: 12),
        buildRoomSelectionRow("Double", doubleRoomCount, (bool increment) {
          setState(() {
            if (increment && doubleRoomCount < 6) {
              doubleRoomCount++;
            } else if (!increment && doubleRoomCount > 0) {
              doubleRoomCount--;
            }
          });
        }),
      ],
    );
  }
  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade600,
      onTap: (index) {
        setState(() => _currentIndex = index);
        // Assuming index 0 is the search icon
        switch (index) {
          case 0: // Search Page
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SearchPage()),
          // );
            break;
          case 1: // Saved Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedPage()),
            );
            break;
          case 2: // My Account Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAccountPage()),
            );
            break;
        // Handle other indices, if necessary
        }
      },
    );
  }
}