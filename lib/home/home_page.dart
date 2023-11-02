import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int roomCount = 1;
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
                    style: TextStyle(
                        fontFamily: 'abyssinicaSil',
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
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
                      primary: Colors.black,
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
            hint: Text('Enter County'),
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (selectedDate != null && selectedDate != checkOutDate) setState(() => checkOutDate = selectedDate);
  });

  Widget buildRoomsRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rooms",
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: roomCount,
              onChanged: (value) => setState(() => roomCount = value!),
              isExpanded: false,
              items: List.generate(5, (index) => index + 1).map((number) => DropdownMenuItem(value: number, child: Text(number.toString()))).toList(),
            ),
          ),
        ],
      ),
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
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
