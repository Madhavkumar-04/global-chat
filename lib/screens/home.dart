import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("/flags/image1.png"), // Set your background image
            fit: BoxFit.cover, // Cover the entire container
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75, // Adjust the width
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () async {
                await authProvider.loginWithGoogle();
              },
              icon: Image.asset(
                "/flags/logos_google-icon.png", // Add Google logo if available
                height: 24.0, // Size of the logo
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Poppins",
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF438E96), // Set button background color here
                foregroundColor: Colors.white, // Set text/icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Set rounded corners
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
