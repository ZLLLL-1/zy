import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo图片
          Image.asset(
            "assets/images/logo.png",
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            "欢迎来到连连看",
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }
}