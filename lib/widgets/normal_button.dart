import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onTap;
  final double width;
  final Color bgColor;

  const NormalButton({
    super.key,
    required this.btnText,
    required this.onTap,
    this.width = 160,
    this.bgColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onTap,
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}