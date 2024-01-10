import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  List<CardModel> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserCards();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserCards() async {
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .get();

      List<CardModel> userCards = cardsSnapshot.docs
          .map((doc) => CardModel.fromDocumentSnapshot(doc))
          .toList();

      setState(() {
        _cards = userCards;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }


  final Map<int, bool> _cardVisibility = {};
  void _toggleCardNumberVisibility(int index) {
    print('Toggling visibility for card at index $index');
    setState(() {
      _cardVisibility[index] = !(_cardVisibility[index] ?? false);
      print('Visibility is now: ${_cardVisibility[index]}');
    });
  }

  String formatCardNumber(String cardNumber) {
    // Remove any existing whitespace and then add spaces every 4 digits
    final noSpaces = cardNumber.replaceAll(RegExp(r'\s+'), '');
    List<String> splitNumbers = [];
    for (int i = 0; i < noSpaces.length; i += 4) {
      int end = (i + 4 < noSpaces.length) ? i + 4 : noSpaces.length;
      splitNumbers.add(noSpaces.substring(i, end));
    }
    return splitNumbers.join(' ');
  }

  Future<void> _deleteCardFromUserSubcollection(CardModel card) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user logged in');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .doc(card.id)
          .delete();
      print('Card deleted from Firestore');


      setState(() {
        _cards.removeWhere((item) => item.id == card.id);
      });

    } catch (e) {
      print('Error deleting card: $e');
    }
  }



  Future<void> addCardToUserSubcollection({
    required String cardNumber,
    required String cardHolder,
    required String expiryDate,
    required String cvv,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user logged in');
      return;
    }

    final CollectionReference cardsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cards');

    final formattedCardNumber = formatCardNumber(cardNumber);

    final newCardData = {
      'cardNumber': formattedCardNumber,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };

    try {
      await cardsCollection.add(newCardData);
      _fetchUserCards();
    } catch (e) {
      print('Error adding card: $e');
    }
  }

  void _addCard() {
    if (_formKey.currentState!.validate()) {
      addCardToUserSubcollection(
        cardNumber: _cardNumberController.text,
        cardHolder: _cardHolderController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
      );
      // Clear the text fields
      _cardNumberController.clear();
      _cardHolderController.clear();
      _expiryDateController.clear();
      _cvvController.clear();
      Navigator.of(context).pop(); // Close the dialog
    }
  }


  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Card'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cardHolderController,
                decoration: InputDecoration(labelText: 'Card Holder'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: _addCard, // Call the method to handle adding card
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      // Inside your Scaffold's body, where the ListView.builder is called:
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cards.isEmpty
          ? Center(child: Text('No cards available.'))
          : ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          final isVisible = _cardVisibility[index] ?? false;
          return Dismissible(
            key: Key(card.cardNumber),
            background: Container(
              color: Colors.red,
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await _deleteCardFromUserSubcollection(card);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Card deleted"),
                ),
              );
            },

            child: ListTile(
              leading: Text("${index + 1}."), // This adds the index number to the front
              title: Text(
                isVisible
                    ? formatCardNumber(card.cardNumber) // Using the formatted card number
                    : '**** **** **** ' + card.cardNumber.substring(card.cardNumber.length - 4),
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                card.cardHolder,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () => _toggleCardNumberVisibility(index),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _showAddCardDialog,
        tooltip: 'Add Card',
        child: Icon(Icons.add),
      ),
    );
  }
}
class CardModel {
  String id;
  String cardNumber;
  String cardHolder;
  String expiryDate;
  String cvv;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  factory CardModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CardModel(
      id: doc.id,
      cardNumber: doc['cardNumber'],
      cardHolder: doc['cardHolder'],
      expiryDate: doc['expiryDate'],
      cvv: doc['cvv'],
    );
  }
}