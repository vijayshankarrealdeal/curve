import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

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
  }

  // --- Standard Email/Password Auth ---
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

  // --- Google Sign In (Web & Mobile without external package) ---
  Future<void> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Create the Provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Optional: Add scopes if you need contacts or specific data
      googleProvider.addScope('email');
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      UserCredential userCredential;

      if (kIsWeb) {
        // 2. WEB: Use Popup
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // 3. MOBILE (Android/iOS): Use signInWithProvider
        // This triggers a browser-based OAuth flow (Chrome Custom Tabs / ASWebAuthenticationSession)
        // This works NATIVELY with firebase_auth and does not require google_sign_in package.
        userCredential = await _firebaseAuth.signInWithProvider(googleProvider);
      }

      // 4. Update Database if successful
      if (userCredential.user != null) {
        await _dbService.createUser(
            userCredential.user!.uid, userCredential.user!.email ?? "No Email");
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors (e.g., popup closed by user)
      print("Firebase Google Auth Error: ${e.code} - ${e.message}");
      if (e.code == 'web-context-cancelled' || e.code == 'canceled') {
        throw Exception("Sign in cancelled");
      }
      throw Exception(e.message ?? "Google Sign-In failed");
    } catch (e) {
      print("General Auth Error: $e");
      throw Exception("An unexpected error occurred during Google Sign-In");
    } finally {
      isLoading = false;
      notifyListeners();
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
      await _firebaseAuth.signOut();
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
