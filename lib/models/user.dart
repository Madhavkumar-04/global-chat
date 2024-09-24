class UserModel {
  String uid;
  String fullName;
  String phone;
  String country;
  String email;
  String password;
  String address;
  String state;
  String city;
  String postalCode;
  String dateOfBirth;
  String gender;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.country,
    required this.email,
    required this.password,
    required this.address,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.dateOfBirth,
    required this.gender,
  });

  // Factory method to create a UserModel from a map (useful for JSON parsing or databases)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      phone: map['phone'],
      country: map['country'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
      state: map['state'],
      city: map['city'],
      postalCode: map['postalCode'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
    );
  }

  // Method to convert the UserModel into a map (useful for JSON serialization or databases)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phone': phone,
      'country': country,
      'email': email,
      'password': password,
      'address': address,
      'state': state,
      'city': city,
      'postalCode': postalCode,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }

  // Method to convert the UserModel to JSON format
  Map<String, dynamic> toJson() {
    return toMap(); // Simply reusing the toMap method here
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, phone: $phone, country: $country, email: $email, password: $password, address: $address, state: $state, city: $city, postalCode: $postalCode, dateOfBirth: $dateOfBirth, gender: $gender)';
  }
}
