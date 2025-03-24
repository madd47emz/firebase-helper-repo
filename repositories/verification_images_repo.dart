import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class VerificationImagesRepo {

  final FirebaseStorage storage = FirebaseStorage.instance;
  final targetPath = '${Directory.systemTemp.path}/compressed_image.jpg';

  Future<String?> uploadProfile(File imageFile, String imageName) async {
    try {
      // Compress image with moderate quality (adjust as needed)
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 80,
      );

      // Get a reference to the storage location
      final imageRef = storage.ref().child("images/profile/$imageName");

      // Upload the image file
      final uploadTask = imageRef.putFile(File(compressedImage!.path));

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print("Error uploading image: ${e.message}");
      return null;
    }
  }
  Future<String?> uploadIdImage(File imageFile, String imageName) async {
    try {
      final imageRef = storage.ref().child("images/verification/$imageName");

      final uploadTask = imageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print("Error uploading image: ${e.message}");
      return null;
    }
  }

  Future<String> deleteProfile(String imageName) async {
    try {
      final imageRef = storage.ref().child("images/profile/$imageName");

      await imageRef.delete();

      return "Image deleted successfully.";
    } on FirebaseException catch (e) {
      return "${e.message}";
    }
  }

  Future<String> deleteIdImage(String imageName) async {
    try {
      final imageRef = storage.ref().child("images/verification/$imageName");

      await imageRef.delete();

      return "Image deleted successfully.";
    } on FirebaseException catch (e) {
      return "${e.message}";
    }
  }
}
