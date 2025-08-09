import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ActionButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: backgroundColor,
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF424242),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}