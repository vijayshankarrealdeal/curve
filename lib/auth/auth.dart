import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async'; // For unawaited

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  AuthProvider() {
    initAuth();
  }

  bool isLogin = true;
  bool isLoading = false;
  bool authState = false;
  bool authIsLoading = true;
  String? userId;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void initAuth() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        authState = true;
        userId = user.uid;
      } else {
        authState = false;
        userId = null;
      }
      authIsLoading = false;
      notifyListeners();
    });

    // 2. Initialize Google Sign In & Listen for Events
  }

  // --- Standard Email/Password Auth (Unchanged) ---
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      UserCredential cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        await _dbService.createUser(cred.user!.uid, email);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      try {
        final provider = GoogleAuthProvider();
        // optional scopes / params:
        provider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        // provider.setCustomParameters({'login_hint': 'user@example.com'});

        UserCredential credential =
            await FirebaseAuth.instance.signInWithPopup(provider);
        if (credential.user != null) {
          await _dbService.createUser(
              credential.user!.uid, credential.user!.email!);
        }
      } catch (e) {
        print("Error during Google Sign-In on Web: $e");
      }

      notifyListeners();
      // Or: return FirebaseAuth.instance.signInWithRedirect(provider);
    }
  }

  Future<void> signup(String email, String password) async {
    if (password != confirmPasswordController.text) {
      throw Exception('Passwords do not match');
    }
    isLoading = true;
    notifyListeners();
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        await _dbService.createUser(cred.user!.uid, email);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        if (_isGoogleSignInInitialized) _googleSignIn.signOut(),
      ]);
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      throw Exception(e);
    }
  }

  void toggleAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
