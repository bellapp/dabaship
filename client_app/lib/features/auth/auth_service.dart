import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Simulate sending OTP via WhatsApp
  Future<bool> sendWhatsAppOTP(String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, this would call your backend to send a WhatsApp message
    return true;
  }

  // Verify the OTP
  Future<bool> verifyOTP(String code) async {
    // Simulate verification
    await Future.delayed(const Duration(seconds: 1));
    return code == '1234';
  }

  // Sign Up with Phone (as Email) and Password
  Future<User?> signUp(String name, String phone, String password) async {
    try {
      // Create user with email: phone@daba.app
      final email = "$phone@daba.app";
      print('AuthService - Attempting sign up with email: $email');
      
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = credential.user;
      print('AuthService - User created: ${user?.uid}');
      
      if (user != null) {
        await user.updateDisplayName(name);
        print('AuthService - Display name updated to: $name');
        
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'isPhoneVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('AuthService - Firestore user document created');
      }
      return user;
    } catch (e) {
      print("Error signing up: $e");
      rethrow;
    }
  }

  // Sign In with Phone and Password
  Future<User?> signIn(String phone, String password) async {
    try {
      final email = "$phone@daba.app";
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Error signing in: $e");
      rethrow;
    }
  }

  // Update Phone Verification Status
  Future<void> setPhoneVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isPhoneVerified': true,
      });
    }
  }

  // Check if phone is verified
  Future<bool> isPhoneVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data()?['isPhoneVerified'] == true;
    }
    return false;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
