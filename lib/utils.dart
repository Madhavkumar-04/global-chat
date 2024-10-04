import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image selected");
}