import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  static const String _bookingsKey = 'local_bookings';
  static const String _currentUserKey = 'local_current_user';
  static const String _registeredUsersKey = 'local_registered_users';

  static final LocalDbService instance = LocalDbService._internal();
  LocalDbService._internal();

  // --- USER AUTHENTICATION (LOCAL STORAGE ONLY) ---

  // Check if a user is logged in
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currentUserKey);
  }

  // Get current logged-in user details
  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_currentUserKey);
    if (userStr == null) return null;
    final Map<String, dynamic> decoded = jsonDecode(userStr);
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  // Register a new user locally
  Future<bool> registerUserLocal({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersListStr = prefs.getString(_registeredUsersKey) ?? '[]';
    final List<dynamic> users = jsonDecode(usersListStr);

    // Check if user already exists
    final exists = users.any((u) => u['email'] == email.trim().toLowerCase());
    if (exists) {
      throw Exception('An account with this email already exists.');
    }

    final newUser = {
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
    };

    users.add(newUser);
    await prefs.setString(_registeredUsersKey, jsonEncode(users));

    // Auto-login the registered user
    await prefs.setString(_currentUserKey, jsonEncode({'name': newUser['name'], 'email': newUser['email']}));
    return true;
  }

  // Login a user locally
  Future<bool> loginUserLocal({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersListStr = prefs.getString(_registeredUsersKey) ?? '[]';
    final List<dynamic> users = jsonDecode(usersListStr);

    final user = users.firstWhere(
      (u) => u['email'] == email.trim().toLowerCase() && u['password'] == password,
      orElse: () => null,
    );

    if (user == null) {
      throw Exception('Invalid email or password.');
    }

    await prefs.setString(_currentUserKey, jsonEncode({'name': user['name'], 'email': user['email']}));
    return true;
  }

  // Logout current user
  Future<void> logoutUserLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // --- BOOKINGS (LOCAL STORAGE ONLY) ---

  // Get all bookings from local storage
  Future<List<Map<String, dynamic>>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsStr = prefs.getString(_bookingsKey);
    if (bookingsStr == null) return [];
    
    final List<dynamic> decoded = jsonDecode(bookingsStr);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  // Add a new booking locally
  Future<void> addBooking({
    required List<String> scrapTypes,
    required String estimatedWeight,
    required String pickupAddress,
    required String date,
    required String time,
    double? estimatedPrice,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final bookings = await getBookings();

    final user = await getCurrentUser();
    final userEmail = user?['email'] ?? 'guest@example.com';

    // Fallback calculation for price if not provided
    double price = estimatedPrice ?? 0.0;
    if (estimatedPrice == null) {
      final double weight = double.tryParse(estimatedWeight) ?? 0.0;
      double maxRate = 15.0;
      for (final t in scrapTypes) {
        double rate = 15.0;
        if (t.toLowerCase().contains('metal')) {
          rate = 75.0;
        } else if (t.toLowerCase().contains('e-waste')) {
          rate = 50.0;
        } else if (t.toLowerCase().contains('plastic')) {
          rate = 15.0;
        } else if (t.toLowerCase().contains('paper') || t.toLowerCase().contains('cardboard')) {
          rate = 12.0;
        } else if (t.toLowerCase().contains('glass')) {
          rate = 8.0;
        }
        if (rate > maxRate) {
          maxRate = rate;
        }
      }
      price = weight * maxRate;
    }

    final newBooking = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userEmail': userEmail,
      'scrapTypes': scrapTypes,
      'estimatedWeight': estimatedWeight,
      'pickupAddress': pickupAddress,
      'date': date,
      'time': time,
      'status': 'Pending',
      'createdAt': DateTime.now().toIso8601String(),
      'estimatedPrice': price,
    };

    bookings.insert(0, newBooking); // Add to the top of list
    await prefs.setString(_bookingsKey, jsonEncode(bookings));
    debugPrint('✅ Booking saved locally: $newBooking');
  }

  // Stream of bookings (using ValueNotifier or standard Future for simplicity,
  // or we can just fetch via standard RefreshNotifier if using Riverpod/Stateful widgets)
  // Let's implement a listener helper using standard flutter change notification if needed.
}
