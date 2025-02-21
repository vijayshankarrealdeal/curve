import 'package:flutter/cupertino.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({super.key, required this.mobile, required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 940;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 940;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (size.width >= 940) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
