import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final String avatarAsset;
  final VoidCallback onTap;

  const MenuItemWidget({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.avatarAsset,
    required this.onTap,
  }) : super(key: key);

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = _isPressed;
    final textColor = isHighlighted ? Colors.white : Colors.black;
    final bgColor = _isPressed
        ? AppColors.shimmeringBlush.withOpacity(0.8)
        : widget.backgroundColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        setState(() => _isPressed = true);
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          setState(() => _isPressed = false);
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Icon(Icons.chevron_left, color: textColor, size: 28),
              const Spacer(),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 17,
                  color: textColor,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 20),
              _buildAvatar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          widget.avatarAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.person, size: 28, color: Colors.grey[600]),
            );
          },
        ),
      ),
    );
  }
}
