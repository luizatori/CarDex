import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/providers/theme_provider.dart';
import 'src/providers/cars_provider.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/profile_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// MAIN APENAS INICIALIZA O APP E OS PROVIDERS -
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

//inicia o firebase 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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

      title: "Dex de carros",

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