import 'package:flappy_bird_app/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Tắt cái chữ Debug trên góc phải màn hình
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
