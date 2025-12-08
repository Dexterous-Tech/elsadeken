import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomAdvancedToggleSwitch extends StatefulWidget {
  final bool? initialValue;
  final Function(bool)? onChanged;

  const CustomAdvancedToggleSwitch({
    super.key,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<CustomAdvancedToggleSwitch> createState() =>
      _CustomAdvancedToggleSwitchState();
}

class _CustomAdvancedToggleSwitchState extends State<CustomAdvancedToggleSwitch>
    with SingleTickerProviderStateMixin {
  bool _isEnabled = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadInitialState();
  }

  void _loadInitialState() {
    _isEnabled = widget.initialValue ?? false;
    if (_isEnabled) {
      _animationController.value = 1.0;
    } else {
      _animationController.value = 0.0;
    }

  }

  @override
  void didUpdateWidget(CustomAdvancedToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {

      _isEnabled = widget.initialValue ?? false;
      if (_isEnabled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

    }
  }

  Future<void> _handleToggle() async {
    try {
      final newValue = !_isEnabled;

      // Immediately update the UI
      if (newValue) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _isEnabled = newValue;

      // Call the onChanged callback if provided
      widget.onChanged?.call(newValue);

    } catch (e) {

      // Revert the toggle if there was an error
      if (_isEnabled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _isEnabled = !_isEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: _handleToggle,
          child: Container(
            width: 36,
            height: 21,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.philippineBronze),
              color: _isEnabled
                  ? AppColors.philippineBronze // Background when ON (right)
                  : AppColors.white, // Background when OFF (left)
            ),
            child: Stack(
              children: [
                // Animated thumb
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: _isEnabled ? 17.0 : 1.0, // 19 for right, 2 for left
                  top: 1.0,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isEnabled
                          ? AppColors.lavenderBlush // Circle color when ON
                          : AppColors.philippineBronze, // Circle color when OFF
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
