import 'package:fav_places_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var kDarkColorScheme= ColorScheme.fromSeed(
  seedColor: const Color(0xFF331569),
  brightness: Brightness.dark,
);

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(
    child: MaterialApp(
      darkTheme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        scaffoldBackgroundColor: const Color(0xFF282828),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF140B23)
        ),
      ),
    
      themeMode: ThemeMode.dark,
    
      home: const HomeScreen(),
    ),
  ));
}