import 'package:curve/auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:provider/provider.dart';

// Import platform interface to access GSIButtonConfiguration and renderButton
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ------------------------------------
      // WEB: Use the official Rendered Button
      // ------------------------------------
      // The renderButton method returns a Widget that displays the GSI button
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: (GoogleSignInPlatform.instance as dynamic).renderButton(
          configuration: GSIButtonConfiguration(
            type: GSIButtonType.standard,
            theme: GSIButtonTheme.outline,
            size: GSIButtonSize.large,
            shape: GSIButtonShape.pill,
          ),
        ),
      );
    } else {
      // ------------------------------------
      // MOBILE: Render Custom Cupertino Button
      // ------------------------------------
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          try {
            await Provider.of<AuthProvider>(context, listen: false)
                .signInWithGoogle();
          } catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Google Sign In Error"),
                  content: Text(e.toString().replaceAll("Exception: ", "")),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Iconify(Bi.google, color: Colors.black),
              SizedBox(width: 8),
              Text(
                "Sign in with Google",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      );
    }
  }
}
