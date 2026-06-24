import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // URL for the Node.js backend. Use 10.213.229.69 instead of localhost for Android Emulator.
  final String _backendUrl = 'http://10.213.229.69:3000/api/auth/sync';

  // 1. Sign Up with Email & Password
  Future<UserCredential?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    String role = 'User', // Allows assigning 'Collector' later dynamically
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Firebase Display Name
      await userCredential.user?.updateDisplayName(name);

      // Sync the user with our MySQL Node.js backend
      if (userCredential.user != null) {
        await _syncUserToBackend(
          uid: userCredential.user!.uid,
          name: name,
          email: email,
          role: role,
        );
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      debugPrint('Unexpected Sign Up error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  // 2. Login with Email & Password
  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Optionally sync to ensure DB holds the latest email/name references if needed
      if (userCredential.user != null) {
        await _syncUserToBackend(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'ScrapKart User',
          email: userCredential.user!.email!,
        );
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      debugPrint('Unexpected Login error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  // 3. Google Sign-In
  Future<UserCredential?> signInWithGoogle({String role = 'User'}) async {
    try {
      // Begin Google Auth flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Early abort if user cancelled

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Authenticate with Firebase using Google credentials
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Sync the Google user directly to MySQL Node.js backend
      if (userCredential.user != null) {
        await _syncUserToBackend(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? googleUser.displayName ?? 'Google User',
          email: userCredential.user!.email ?? googleUser.email,
          role: role,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      debugPrint('Unexpected Google Sign In error: $e');
      throw Exception('Failed to sign in with Google. Check your network.');
    }
  }

  // 4. Log out
  Future<void> logOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error during logout: $e');
      throw Exception('Logout failed.');
    }
  }

  // Helper method: API hit to sync User to MySQL Backend 
  Future<void> _syncUserToBackend({
    required String uid,
    required String name,
    required String email,
    String? role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'name': name,
          'email': email,
          'role': ?role,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ User successfully synced with MySQL database!');
      } else {
        debugPrint('❌ Failed to sync. Node status code: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        throw Exception('Failed to sync user database on backend.');
      }
    } catch (e) {
      debugPrint('❌ Network error syncing user backend: $e');
      // We log but generally do not crash user experience if syncing fails network-wise
      // You may consider background retries in a full production system.
      throw Exception('Network error: Cannot reach the backend API.');
    }
  }

  // Helper method: Error Decoding for User Experience
  void _handleAuthError(FirebaseAuthException e) {
    debugPrint('Firebase Auth Error [${e.code}]: ${e.message}');
    switch (e.code) {
      case 'user-not-found':
        throw Exception('No user found matching this email.');
      case 'wrong-password':
      case 'invalid-credential':
        throw Exception('Invalid email or password.');
      case 'email-already-in-use':
        throw Exception('An account already exists for this email.');
      case 'invalid-email':
        throw Exception('This email address gets formatted incorrectly.');
      case 'user-disabled':
        throw Exception('Your account is currently disabled by Admin.');
      case 'too-many-requests':
        throw Exception('Too many attempts. Please try again later.');
      default:
        throw Exception(e.message ?? 'An unknown authentication error occurred.');
    }
  }
}
