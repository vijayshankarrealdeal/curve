import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // Listen to Firebase Auth state changes
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

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      UserCredential cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure user document exists in Firestore and update login time
      if (cred.user != null) {
        await _dbService.createUser(cred.user!.uid, email);
      }

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e.message ?? "Login failed");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception("An unknown error occurred: $e");
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

      // Create user document in Firestore
      if (cred.user != null) {
        await _dbService.createUser(cred.user!.uid, email);
      }

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e.message ?? "Registration failed");
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception("An unknown error occurred: $e");
    }
  }

  Future<void> signout() async {
    try {
      await _firebaseAuth.signOut();
      // Auth state listener will handle UI updates
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
