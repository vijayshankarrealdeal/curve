import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool isLogin = true;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Stream<AuthState> getAuth() => supabase.auth.onAuthStateChange;

  void login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
    isLoading = false;
    notifyListeners();
  }

  void signup() async {
    isLoading = true;
    notifyListeners();
    try {
      await supabase.auth.signUp(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      isLoading = false;

      notifyListeners();
      throw Exception(e);
    }
    isLoading = false;
    notifyListeners();
  }

  void signout() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  void toggleAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
