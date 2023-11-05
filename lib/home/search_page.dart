import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/home/saved_page.dart';
import 'myAccount/myAccount_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/SearchPage.jpeg'),
              fit: BoxFit.cover,
              // Apply color filter here
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.85), // 50% Opacity
                BlendMode.dstATop, // This blend mode allows the image to show through the color
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    onPressed: () {}, // Handle search
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
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: date?.toLocal().toString().split(' ')[0] ?? hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.black)),
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