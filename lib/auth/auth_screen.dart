import 'package:curve/services/colors_provider.dart';
import 'package:curve/auth/animated_screen.dart';
import 'package:curve/auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Form(
                            key: authProvider.formKey,
                            child: Column(
                              children: [
                                Text(
                                  "Curves",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                TextFormField(
                                  controller: authProvider.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 1),
                                TextFormField(
                                  controller: authProvider.passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 1),

                                // Confirm Password only for sign up
                                if (!authProvider.isLogin)
                                  AnimatedSize(
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: TextFormField(
                                      controller: authProvider
                                          .confirmPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      validator: (value) {
                                        if (value !=
                                            authProvider
                                                .passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 13),

                                authProvider.isLoading
                                    ? Consumer<ColorsProvider>(
                                        builder: (context, color, _) {
                                        return CircularProgressIndicator(
                                          color: color.lodingColor(),
                                        );
                                      })
                                    : CupertinoButton(
                                        onPressed: () async {
                                          if (!authProvider
                                              .formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          try {
                                            if (authProvider.isLogin) {
                                              authProvider.login(
                                                authProvider
                                                    .emailController.text
                                                    .trim(),
                                                authProvider
                                                    .passwordController.text
                                                    .trim(),
                                              );
                                            } else {
                                              authProvider.signup(
                                                authProvider
                                                    .emailController.text
                                                    .trim(),
                                                authProvider
                                                    .passwordController.text
                                                    .trim(),
                                              );
                                            }
                                          } catch (e) {
                                            // Show error

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Error"),
                                                  content: Text(
                                                      "An error occurred. Please try again."),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("OK"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } finally {}
                                        },
                                        child: Text(
                                          authProvider.isLogin
                                              ? 'LOGIN'
                                              : 'SIGN UP',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),

                                // Toggle between login and sign up
                                TextButton(
                                  onPressed: () {
                                    authProvider.toggleAuthMode();
                                  },
                                  child: Text(
                                    authProvider.isLogin
                                        ? "Don't have an account? Sign Up"
                                        : "Already have an account? Login",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
