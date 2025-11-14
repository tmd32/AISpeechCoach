import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService{
  final auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try{
      final cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try{
      final cred = await auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try{
      if (kIsWeb) {
        final provider = GoogleAuthProvider();

        return await auth.signInWithPopup(provider);
      } else {
        await GoogleSignIn.instance.initialize();
        final user = await GoogleSignIn.instance.authenticate();
        final tokens = await user.authentication;
        final cred = GoogleAuthProvider.credential(idToken: tokens.idToken);
        return await auth.signInWithCredential(cred);
      }
    }catch(e){
      print('Google sign-in error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try{
      await GoogleSignIn.instance.initialize();

      await GoogleSignIn.instance.signOut();

      await auth.signOut();

      print('signed out successfully');
    } catch (e){
      print('Sign-out error: $e');
    }
  }
}