import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/cars_provider.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CarsProvider()),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Car Collection",

      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E11),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
