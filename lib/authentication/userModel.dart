class UserModel{
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String telephoneNumber;
  final String password;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephoneNumber,
    required this.password,
    });

    toJson(){
      return {
        "FirstName" : firstName,
        "LastName" : lastName,
        "Email" : email,
        "PhoneNo:" : telephoneNumber,
        "Password" : password,
      };
    }
}