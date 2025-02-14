import 'package:curve/api/cart_provider.dart';
import 'package:curve/api/colors_provider.dart';
import 'package:curve/api/gird_provider.dart';
import 'package:curve/api/scratch_provider.dart';
import 'package:curve/app/home.dart';
import 'package:curve/api/state.dart';
import 'package:curve/api/settings_model.dart';
import 'package:curve/app/card_scratch.dart';
import 'package:curve/auth/auth.dart';
import 'package:curve/auth/auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Supabase.initialize(
    url: 'https://igzyldsgabtqtzoptvvb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlnenlsZHNnYWJ0cXR6b3B0dnZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcxODA1MzEsImV4cCI6MjA1Mjc1NjUzMX0.LCThsIMH0dq10IkXi_v05Hasz11bLl6Exgi0H68v44g',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavBar()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => ScratchProvider()),
        ChangeNotifierProvider(create: (context) => ColorsProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
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
        home: StreamBuilder<AuthState>(
            stream: auth.getAuth(),
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data!.session != null)) {
                return const AppPage();
              }
              return AuthScreen();
            }),
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
        return Scaffold(
          body: [
            Home(), CardScratch(),

            //Gift()
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
              // NavigationDestination(
              //     icon: Icon(
              //       CupertinoIcons.gift,
              //       size: navBar.idx == 2 ? 32 : 25,
              //       color: navBar.idx == 2
              //           ? colorPro.primaryColor()
              //           : colorPro.navBarIconActiveColor(),
              //     ),
              //     label: ""),
            ],
          ),
        );
      },
    );
  }
}
