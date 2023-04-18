import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gmail_signin/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser?>? get user {
    return _auth.authStateChanges().map((user) => _userFromFirebaseUser(user));
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userData = {'name': user.displayName, 'email': user.email};
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);
      }

      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(
//         scopes: [
//           'email',
//           // 'https://www.googleapis.com/auth/contacts.readonly',
//         ],
//         clientId:
//             "758071054197-6v9lgafup3unpkeuoja8c5jstomcquo6.apps.googleusercontent.com",
//       );

//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser!.authentication;

//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         final userData = {'name': user.displayName, 'email': user.email};
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .set(userData);
//       }

//       return user;
//     } catch (e) {
//       debugPrint(e.toString());
//       return null;
//     }
//   }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? AppUser(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
          )
        : null;
  }
}
