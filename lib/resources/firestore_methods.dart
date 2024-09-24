import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat/models/chat_message.dart';
import 'package:group_chat/models/user.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    String res = "logged in"; // Default response

    try {
      // Create the UserModel object with all the provided fields

      // Store the user data in Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toJson());

      res = "User created successfully"; // Success response
    } catch (e) {
      res = e.toString(); // Capture and return error message
    }

    return res; // Return the result of the operation
  }

  Future<dynamic> getUserDetails(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc;
  }

  Future<void> postMsg(ChatMessage chat) async {
    try {
      await _firestore.collection('msg').doc(chat.uid).set(chat.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
