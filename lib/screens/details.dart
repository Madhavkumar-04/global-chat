import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/resources/firestore_methods.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  String? _gender = 'Male'; // Default gender selection
  String? _selectedCountry;
  Country? _selectedPhoneCountry= Country.parse('IN');
  String? _selectedState;
  String? _selectedCity;
  bool _isPasswordVisible = false;// Default country code
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // Date of Birth
  List<String> countries = ['USA', 'India', 'Canada'];
  List<String> states = ['California', 'Texas', 'Ontario'];
  List<String> cities = ['Los Angeles', 'Houston', 'Toronto'];

  @override
  void initState() {
    super.initState();

    // Get the current user from Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Set full name and email to the controllers
      _fullNameController.text = currentUser.displayName ?? '';
      _emailController.text = currentUser.email ?? '';
    }
  }

  // Password validation regex
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Regex: at least one uppercase, one digit, one special character
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=[\]{};":\\|,.<>?]).+$').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one number, and one special character.';
    }
    return null;
  }
  String createAccount(){
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      UserModel newUser = UserModel(
        uid: currentUser!.uid,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        country: _selectedPhoneCountry?.name ?? 'India',
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
        state: _selectedState!,
        city: _selectedCity!,
        postalCode: _postalCodeController.text,
        dateOfBirth: _dobController.text,
        gender: _gender!,
      );

      // Do something with the newUser, e.g., print or send to the backend
      FirestoreMethods().createUser(newUser);
      print(newUser.toString());
    }
    print("success");
    String res = "success";
    return res;
  }
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFF438E96), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 2),
      ),
      contentPadding: const EdgeInsets.all(15),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF438E96),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Please enter your credentials to proceed",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3A4750),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 40),

                // Full Name
                const Text("Full Name", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  decoration: inputDecoration("Enter your full name"),
                  controller: _fullNameController,
                ),
                const SizedBox(height: 20),

                // Phone
                const Text("Phone", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none, // This removes the border
                        padding: EdgeInsets.zero
                      ),
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true, // Show country phone code
                          onSelect: (Country country) {
                            setState(() {
                              _selectedPhoneCountry = country;
                            });
                          },
                        );
                      },
                      child: Text(
                        _selectedPhoneCountry != null
                            ? '${_selectedPhoneCountry!.flagEmoji} +${_selectedPhoneCountry!.phoneCode}'
                            : 'Select Country',
                        style: const TextStyle(fontSize: 16), // You can customize the text style here
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration("Enter your phone number"),
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email Address
                const Text("Email Address", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  decoration: inputDecoration("Enter your email"),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  enabled: false,
                ),
                const SizedBox(height: 20),

                // Password
                const Text("Password", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  controller: _passwordController,
                  decoration: inputDecoration("Enter your password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 20),

                // Address (3 lines)
                const Text("Address", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  controller: _addressController,
                  decoration: inputDecoration("Enter your address"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Country Dropdown
                const Text("Country", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration("Select your country"),
                  value: _selectedCountry,
                  items: countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // State Dropdown
                const Text("State", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96), fontWeight: FontWeight.w300)),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration("Select your state"),
                  value: _selectedState,
                  items: states.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // City Dropdown
                const Text("City", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration("Select your city"),
                  value: _selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Postal Code
                const Text("Postal Code", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: inputDecoration("Enter your postal code"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Date of Birth
                const Text("Date of Birth", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF438E96))),
                TextFormField(
                  controller: _dobController,
                  decoration: inputDecoration("Enter your date of birth").copyWith(
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    // Open date picker
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),  // Current date as default
                      firstDate: DateTime(1900),  // Earliest possible date
                      lastDate: DateTime.now(),  // Latest possible date (today)
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        _dobController.text = formattedDate; // Update the controller
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Gender (Radio Buttons)
                const Text("Gender", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Color(0xFF438E96))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Male',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          activeColor: Color(0xFF438E96),
                        ),
                        const Text('Male', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF3A4750))),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          activeColor: Color(0xFF438E96),
                        ),
                        const Text('Female', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF3A4750))),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Prefer not to say',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          activeColor: Color(0xFF438E96),
                        ),
                        const Text('Prefer not to say', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF3A4750))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: createAccount,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF438E96),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF438E96).withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
