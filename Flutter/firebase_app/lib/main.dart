import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_screen.dart';
import 'screens/posts_screen.dart';
import 'screens/add_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFCAC2A7),
        scaffoldBackgroundColor: Color(0xFFF5F1E9),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFCAC2A7),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: AuthScreen(),
      routes: {
        '/posts': (context) => PostsScreen(),
        '/add_post': (context) => AddPostScreen(),
      },
    );
  }
}