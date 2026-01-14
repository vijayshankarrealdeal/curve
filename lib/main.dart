import 'package:curve/services/cart_provider.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/gird_provider.dart';
import 'package:curve/services/learn_provider.dart';
import 'package:curve/services/scratch_provider.dart';
import 'package:curve/app/home.dart';
import 'package:curve/services/state.dart';
import 'package:curve/services/settings_model.dart';
import 'package:curve/app/card_scratch.dart';
import 'package:curve/app/learn.dart';
import 'package:curve/auth/auth.dart';
import 'package:curve/auth/auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavBar()),
        ChangeNotifierProvider(create: (_) => ColorsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ScratchProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LearnProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, AuthProvider>(
        builder: (context, colorProvider, auth, _) {
      return MaterialApp(
        title: 'eavesdrops',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.ptSansTextTheme().apply(
            bodyColor: colorProvider.navBarIconActiveColor(),
            displayColor: colorProvider.navBarIconActiveColor(),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: colorProvider.playerCell("s")),
          appBarTheme: AppBarTheme(color: colorProvider.getAppBarColor()),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: colorProvider.getAppBarColor()),
          scaffoldBackgroundColor: colorProvider.getScaffoldColor(),
          navigationBarTheme: NavigationBarThemeData(
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorColor: Colors.transparent),
          colorScheme: ColorScheme.fromSeed(
              primary: colorProvider.primaryColor(),
              seedColor: colorProvider.seedColorColor(),
              brightness: colorProvider.getBrightness()),
          useMaterial3: true,
        ),
        home: auth.authIsLoading
            ? const Scaffold(body: Center(child: CupertinoActivityIndicator()))
            : auth.authState
                ? const AppPage()
                : const AuthScreen(),
      );
    });
  }
}

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavBar, ColorsProvider>(
      builder: (context, navBar, colorPro, _) {
        // BUG FIX: Removed the redundant MultiProvider.
        // The global one in main() already provides these.
        return Scaffold(
          body: [
            const Home(),
            const CardScratch(),
            const Learn()
          ][navBar.idx],
          bottomNavigationBar: NavigationBar(
            backgroundColor: colorPro.getAppBarColor(),
            selectedIndex: navBar.idx,
            onDestinationSelected: (idx) => navBar.change(idx),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.home,
                    size: navBar.idx == 0 ? 32 : 25,
                    color: navBar.idx == 0
                        ? colorPro.primaryColor()
                        : colorPro.navBarIconActiveColor(),
                  ),
                  label: ""),
              NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.app,
                    size: navBar.idx == 1 ? 32 : 25,
                    color: navBar.idx == 1
                        ? colorPro.primaryColor()
                        : colorPro.navBarIconActiveColor(),
                  ),
                  label: ""),
              NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.eyeglasses,
                    size: navBar.idx == 2 ? 32 : 25,
                    color: navBar.idx == 2
                        ? colorPro.primaryColor()
                        : colorPro.navBarIconActiveColor(),
                  ),
                  label: ""),
            ],
          ),
        );
      },
    );
  }
}