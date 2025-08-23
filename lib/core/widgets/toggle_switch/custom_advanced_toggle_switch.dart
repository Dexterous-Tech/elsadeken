import 'dart:developer';

import 'package:elsadeken/core/services/firebase_notification_service.dart';
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
  final _notificationService = FirebaseNotificationService.instance;
  bool _isLoading = false;
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
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final isEnabled = await _notificationService.isNotificationEnabled();
      _isEnabled = isEnabled;
      if (isEnabled) {
        _animationController.value = 1.0;
      } else {
        _animationController.value = 0.0;
      }
      log('Notification state loaded: $isEnabled');
    } catch (e) {
      log('Error loading notification state: $e');
      _isEnabled = widget.initialValue ?? true;
      if (_isEnabled) {
        _animationController.value = 1.0;
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleToggle() async {
    if (_isLoading) return;

    try {
      final newValue = !_isEnabled;
      log('Toggle requested: $newValue, current value: $_isEnabled');

      setState(() {
        _isLoading = true;
      });

      await _notificationService.toggleNotifications(newValue);

      // Animate the toggle
      if (newValue) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      _isEnabled = newValue;
      log('Toggle updated to: $_isEnabled');

      // Call the onChanged callback if provided
      widget.onChanged?.call(newValue);

      // Show feedback to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newValue ? 'تم تفعيل الإشعارات' : 'تم إيقاف الإشعارات',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
            backgroundColor: newValue ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      log('Error toggling notifications: $e');
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ في تغيير إعدادات الإشعارات',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: 36,
        height: 21,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.philippineBronze,
            ),
          ),
        ),
      );
    }

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
              color: _isEnabled
                  ? AppColors.philippineBronze // Background when ON (right)
                  : AppColors.lavenderBlush, // Background when OFF (left)
            ),
            child: Stack(
              children: [
                // Animated thumb
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: _isEnabled ? 19.0 : 2.0, // 19 for right, 2 for left
                  top: 2.0,
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
                          color: Colors.black.withOpacity(0.2),
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
