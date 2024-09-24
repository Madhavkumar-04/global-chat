import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define reusable text styles using Cherry Swash font
class TextStyles {
  static final TextStyle heading = GoogleFonts.cherrySwash(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16,
  );

  static final TextTheme cherrySwashTextTheme = GoogleFonts.cherrySwashTextTheme();
}
