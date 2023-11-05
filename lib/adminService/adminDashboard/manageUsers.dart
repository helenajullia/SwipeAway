import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserDetails>> _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => UserDetails.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      // Handle errors or return an empty list
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<UserDetails>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return UserTile(user: user);
              },
            );
          } else {
            return Center(child: Text('No users found'));
          }
        },
      ),
    );
  }
}

class UserDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    return UserDetails(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}

class UserTile extends StatelessWidget {
  final UserDetails user;

  UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('${user.firstName} ${user.lastName}'),
        children: <Widget>[
          ListTile(
            title: Text('Email'),
            subtitle: Text(user.email),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text(user.phone),
          ),
        ],
      ),
    );
  }
}
