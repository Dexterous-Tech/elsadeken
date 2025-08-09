import 'package:flutter/material.dart';

class GenderFilter extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const GenderFilter({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 140,
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
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
