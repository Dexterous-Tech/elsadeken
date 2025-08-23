import 'package:flutter/material.dart';

class ChatFilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isActive;

  const ChatFilterButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 200,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFFE8A5A5)  
              : const Color(0xFFF5F1E8), 
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            color: const Color(0xFF8B7355),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
