
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = ref.putData(file, metadata);  // Pass metadata
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

}
