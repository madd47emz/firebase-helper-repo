import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixyli/models/artisan.dart';

class ProfileRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = "Db3LoU0Jn61wH8156jFW";
  String name = "Mohamed";

  Future<void> saveUserToFirestore(Artisan userData) async {
    try {
      name = userData.fullName.split(' ').last;
      DocumentReference docRef = await firestore.collection('users').add({
        'is_admin': false,
        'is_artisan': true,
        'is_superadmin': false,
        'is_verified': false,
        'numRegCom': userData.numRegistreComercial,
        'fullName': userData.fullName,
        'phoneNumber': userData.phoneNumber,
        'email': userData.email,
        'points': 15,
        'bio': userData.bio,
        'faceImage': '',
        'truckImage': '',
        'logoImage': '',
        'workImage': '',
        'portfolioImages': [],
        'idRectoImage': '',
        'idVersoImage': '',
      });
      uid = docRef.id;
      print('User data saved successfully!');
    }on FirebaseException catch (error) {
      print(error);
    }
  }

  Future<void> updateProfileImages(List<String> value) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'faceImage': value[0],
        'truckImage': value[1],
        'logoImage': value[2],
        'workImage': value[3],
      });
      print('Profile images updated successfully!');
    }on FirebaseException catch (error) {
      print(error);
    }
  }

  Future<void> updateBio(String value) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'bio': value,
      });
      print('bio updated successfully!');
    } catch (error) {
      print(error);
    }
  }

  Future<void> updatePortfolioImages(List<String> value) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'portfolioImages': value,
      });
      print('Portfolio images updated successfully!');
    }on FirebaseException catch (error) {
      print(error);
    }
  }

  Future<void> updateIdImages(String recto,String verso) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'idRectoImage': recto,
        'idVersoImage': verso,
      });
      print('id images updated successfully!');
    }on FirebaseException catch (error) {
      print(error);
    }
  }
}
