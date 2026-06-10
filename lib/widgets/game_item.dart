import 'package:flutter/material.dart';

class GameItem extends StatelessWidget {
  final String imgPath;
  final bool isSelected;
  final bool isHide;
  final VoidCallback onItemClick;

  const GameItem({
    super.key,
    required this.imgPath,
    required this.isSelected,
    required this.isHide,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    if (isHide) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[200] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset(imgPath),
        ),
      ),
    );
  }
}