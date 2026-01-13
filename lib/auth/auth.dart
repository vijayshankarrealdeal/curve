import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();
  
  // FIX: Use .instance singleton (v7 Requirement)
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
    // 1. Firebase Auth Listener
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

    // 2. Initialize Google Sign In (Async in v7)
    _ensureGoogleSignInInitialized();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      try {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;

        // WEB SPECIFIC: Check for existing session (Silent Auth)
        if (kIsWeb) {
          // Because v7 on Web manages session via the iframe/popup, 
          // we check if we can restore authentication silently.
          _checkWebSession();
        }
      } catch (e) {
        debugPrint("Google Sign-In initialization failed: $e");
      }
    }
  }

  Future<void> _checkWebSession() async {
    try {
      final result = await _googleSignIn.attemptLightweightAuthentication();
      if (result != null) {
        await _finalizeGoogleSignIn(result);
      }
    } catch (e) {
      // Silent failure is expected if no user is signed in
      debugPrint("Web silent auth check: $e");
    }
  }

  /// Triggered by Mobile Custom Button
  Future<void> signInWithGoogle() async {
    // On Web, the GoogleButton widget (google_button.dart) handles the flow
    if (kIsWeb) return; 

    isLoading = true;
    notifyListeners();

    try {
      await _ensureGoogleSignInInitialized();
      
      // v7: authenticate() is the new method
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      
      await _finalizeGoogleSignIn(googleUser);
      
      isLoading = false;
      notifyListeners();
    } on GoogleSignInException catch (e) {
      isLoading = false;
      notifyListeners();
      // v7 throws 'canceled' if closed by user
      if (e.code != 'canceled') {
         debugPrint("Google Auth Error: ${e.code}");
         throw Exception("Google Sign In failed: ${e.toString()}");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception("An unknown error occurred: $e");
    }
  }

  /// Exchange Google Account for Firebase Credentials
  Future<void> _finalizeGoogleSignIn(GoogleSignInAccount googleUser) async {
      try {
        // 1. Get ID Token (Synchronous in v7)
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        // 2. Get Access Token (Via authorizationClient in v7)
        final authClient = _googleSignIn.authorizationClient;
        // Request scopes again to get the accessToken
        final authorization = await authClient.authorizationForScopes(['email']);
        
        // 3. Create Firebase Credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authorization?.accessToken, 
          idToken: googleAuth.idToken,
        );

        // 4. Sign in to Firebase
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        // 5. Save to Firestore
        if (userCredential.user != null) {
          await _dbService.createUser(
            userCredential.user!.uid,
            userCredential.user!.email ?? "google_user",
          );
        }
      } catch (e) {
        debugPrint("Error finalizing sign in: $e");
        // Do not throw here to keep UI alive, maybe show toast
      }
  }

  // --- Email/Password Methods ---
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
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e.message ?? "Login failed");
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
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e.message ?? "Registration failed");
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