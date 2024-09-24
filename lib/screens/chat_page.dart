import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/resources/firestore_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  dynamic userDetail;
  String imageUrl = ""; // To handle image URLs
  bool isLoadingImage = false; // Loading indicator for image upload
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var snapshot = await FirestoreMethods().getUserDetails(currentUser.uid);
      setState(() {
        userDetail = snapshot.data(); // Assuming snapshot is a DocumentSnapshot
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty || imageUrl.isNotEmpty) {
      ChatMessage chat = ChatMessage(
        uid: DateTime.now().toString(),
        userId: userDetail['uid'],
        username: userDetail['fullName'],
        content: _controller.text.isNotEmpty ? _controller.text : "[Image]",
        timestamp: DateTime.now(),
        imageUrl: imageUrl, // Handle image URL if image is sent
      );

      FirestoreMethods().postMsg(chat).then((_) {
        setState(() {
          _controller.clear(); // Clear the input field
          imageUrl = ""; // Reset image URL
        });
      }).catchError((error) {
        print("Failed to send message: $error");
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isLoadingImage = true; // Start loading indicator
      });
      try {
        Uint8List imageBytes = await image.readAsBytes(); // Read image as bytes
        String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique filename
        Reference ref = FirebaseStorage.instance.ref().child('msg');
        UploadTask uploadTask = ref.putData(imageBytes);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL(); // Get download URL

        setState(() {
          imageUrl = downloadUrl; // Update imageUrl with the download URL
        });
      } catch (error) {
        print("Failed to upload image: $error");
        // Show an error message to the user
      } finally {
        setState(() {
          isLoadingImage = false; // Stop loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFF438E96),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Group Chat',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  if (userDetail != null) // Check for user details
                    Text(
                      "hi, ${userDetail["fullName"]}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('msg').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No messages yet'));
                }

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var messageData = docs[index];

                    // Convert Firestore Timestamp to DateTime
                    ChatMessage message = ChatMessage.fromJson(messageData.data() as Map<String, dynamic>);

                    // Determine if the current user is the one who sent the message
                    final isCurrentUser = message.userId == userDetail!['uid'];

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isCurrentUser ? "you" : message.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF438E96),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  DateFormat.jm().format(message.timestamp), // Properly format DateTime
                                  style: TextStyle(fontSize: 10, color: Colors.black54, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDeff0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                              ),
                            ),
                            if (message.imageUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.network(
                                  message.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 200, // Adjust width as needed
                                  height: 200,
                                ),
                              ),
// Display the image here
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),


          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF438E96),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Color(0x40438E96),
                  border: Border.all(
                    color: Color(0xFF438E96),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {
                        // Handle emoji selection
                      },
                      color: Color(0xFF438E96),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                    isLoadingImage? // Show loading indicator while image uploads
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ):
                    IconButton(
                      icon: Icon(Icons.image_outlined),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF438E96),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Transform.rotate(
                angle: -0.8,
                child: IconButton(
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
