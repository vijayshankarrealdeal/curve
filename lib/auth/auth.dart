import 'package:curve/api/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    initAuth();
  }
  bool isLogin = true;
  String token = '';
  bool isLoading = false;
  bool authState = false;
  bool authIsLoading = true;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void initAuth() async {
    final _storage = await FlutterSecureStorage();
    String _token = await _storage.read(key: 'token') ?? "";
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      String email = await _storage.read(key: 'email') ?? "";
      String password = await _storage.read(key: 'password') ?? "";
      _token = await login(email, password);
    } else if (_token.isNotEmpty && !JwtDecoder.isExpired(_token)) {
      authState = true;
      token = _token;
    } else {
      authState = false;
    }
    authIsLoading = false;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    isLoading = true;
    final _storage = await FlutterSecureStorage();
    final url = Uri.parse(APIUrls.LOGIN);
    notifyListeners();
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      token = jsonDecode(response.body)['token'];
      await Future.wait([
        _storage.write(key: 'token', value: token),
        _storage.write(key: 'email', value: email),
        _storage.write(key: 'password', value: password),
      ]);

      isLoading = false;
      authState = true;
      isLoading = false;
      notifyListeners();
      return token;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  void signup(String email, String password) async {
    if (password.compareTo(confirmPasswordController.text) != 0) {
      throw Exception('Passwords do not match');
    }
    isLoading = true;
    final _storage = await FlutterSecureStorage();
    final url = Uri.parse(APIUrls.REGISTER);
    notifyListeners();
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      token = jsonDecode(response.body)['token'];
      await Future.wait([
        _storage.write(key: 'token', value: token),
        _storage.write(key: 'email', value: email),
        _storage.write(key: 'password', value: password),
      ]);
      isLoading = false;
      authState = true;
      isLoading = false;
      notifyListeners();
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
      final _storage = await FlutterSecureStorage();
      await _storage.deleteAll();
      token = '';
      authState = false;
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  void toggleAuthMode() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
