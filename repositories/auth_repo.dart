// import 'dart:core';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fixyli/views/utils/primary_button.dart';
// import 'package:fixyli/views/utils/secondary_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AuthRepository {
//
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   String _verificationId = "";
//   int? _resendToken;
//   String phone = '';
//
//   Future<String> emailSignup(String email, String password) async {
//     try {
//       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user !=null ? "success":"failed";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         return 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         return 'The email address is already in use by another account.';
//       } else {
//         return e.message ?? 'An error occurred.'; // return error message
//       }
//     } catch (e) {
//       return 'An error occurred.'; // handle other exceptions
//     }
//   }
//
//   Future<String> emailSignin(String email, String password) async {
//     try {
//       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user !=null ? "success":"failed";
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'No user found for this email.';
//       } else if (e.code == 'wrong-password') {
//         return 'Wrong password provided for this email.';
//       } else {
//         return e.message ?? 'An error occurred.'; // return error message
//       }
//     } catch (e) {
//       return 'An error occurred.'; // handle other exceptions
//     }
//   }
//
//
//   Future<String> resetPassword(String email) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//       return 'success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'No user found for this email.';
//       } else {
//         return 'Error resetting password: ${e.message}';
//       }
//     } catch (e) {
//       return "An error occurred";
//     }
//   }
//
//
//   Future<void> phoneAuth(context)async{
//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: "+213 $phone",
//         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
//           UserCredential result = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//           if(result.user != null){
//
//           };
//         },
//         verificationFailed: (FirebaseAuthException authException) {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text(
//                 "Trouble",
//                 style: TextStyle(color: Colors.red),
//               ),
//               content: Text(authException.message ?? "An error occurred."), // Handle missing message
//               actions: [
//                 SecondaryButton(text: "Cancel", onPressed: () => Navigator.pop(context), icon: null),
//                 const SizedBox(height: 8,),
//                 PrimaryButton(text: "Resend Code", disabled: false, onPressed: () => resendVerification(context),),
//
//
//               ],
//             ),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           _resendToken = resendToken; // Store resend token for future use
//         },
//         timeout: const Duration(seconds: 60), // Set a timeout for verification
//         forceResendingToken: _resendToken, // Use resend token if available
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId; // Update verification ID
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text(
//             "Trouble",
//             style: TextStyle(color: Colors.red),
//           ),
//           content: Text(e.message ?? "An error occurred."), // Handle missing message
//           actions: [
//             SecondaryButton(text: "Ok", onPressed: () => Navigator.pop(context), icon: null),
//           ],
//         ),
//       );
//     }
//
//   }
//
//
//   Future<void> resendVerification(BuildContext context) async {
//     if (_verificationId != "" && _resendToken != null) {
//
//       await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: "+213 $phone",
//         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
//           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//         },
//         verificationFailed: (FirebaseAuthException authException) {
//           showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text(
//                   "Trouble",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 content: Text(authException.code),
//                 actions: [
//                   SecondaryButton(text: "Ok", onPressed: () => Navigator.pop(context), icon: null),
//                 ],
//               ));
//           throw Exception(authException.message);
//         },
//         codeSent: (String verificationId, int? resendToken){
//           _verificationId = verificationId;
//           _resendToken = resendToken;
//         },
//         timeout: const Duration(seconds: 60), // Set a timeout for verification
//         forceResendingToken: _resendToken,
//         codeAutoRetrievalTimeout: (String verificationId) { _verificationId=verificationId; }, // Can be used for resend verification
//       );
//     } else {
//       // Handle case where verification ID or resend token is missing
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Error"),
//           content: const Text("Cannot resend code at this time."),
//           actions: [
//             SecondaryButton(text: "Ok", onPressed: () => Navigator.pop(context), icon: null),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<bool> verifyOTP(String otpCode) async {
//     try {
//       var phoneAuthCredential = await _firebaseAuth.signInWithCredential(
//         PhoneAuthProvider.credential(
//           verificationId: _verificationId,
//           smsCode: otpCode,
//         )
//       );
//
//       return phoneAuthCredential.user != null ? true : false;
//     } on FirebaseAuthException {
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }
//
//
//   Future<String> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//
//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//
//       // Once signed in, return message
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       return userCredential.user !=null ? "success":"failed";
//     } on FirebaseAuthException catch (e) {
//       return e.message ?? 'An error occurred.'; // return error message
//
//     } catch (e) {
//       return 'An error occurred.'; // handle other exceptions
//     }
//   }
//
//
//   Future<String> signInWithFacebook() async {
//     try{
//     //Trigger the sign-in flow
//     final LoginResult loginResult = await FacebookAuth.instance.login();
//
//     //Create a credential from the access token
//     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
//
//     //Once signed in, return message
//     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//     return userCredential.user !=null ? "success":"failed";
//   } on FirebaseAuthException catch (e) {
//   return e.message ?? 'An error occurred.'; // return error message
//
//   } catch (e) {
//   return 'An error occurred.'; // handle other exceptions
//   }
//   }
//
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
//
//
//
//
// }
