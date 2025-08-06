import 'dart:developer';

import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class CustomAdvancedToggleSwitch extends StatefulWidget {
  const CustomAdvancedToggleSwitch({super.key});

  @override
  State<CustomAdvancedToggleSwitch> createState() =>
      _CustomAdvancedToggleSwitchState();
}

class _CustomAdvancedToggleSwitchState
    extends State<CustomAdvancedToggleSwitch> {
  final _controller = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return AdvancedSwitch(
      controller: _controller,
      activeColor: AppColors.philippineBronze,
      inactiveColor: AppColors.lavenderBlush,
      width: 36,
      height: 21,
      borderRadius: BorderRadius.circular(20),
      enabled: true,
      thumb: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (_, value, __) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors.lavenderBlush : AppColors.philippineBronze,
            ),
          );
        },
      ),
      onChanged: (value) {
        log("toggle value $value");
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ Prevents memory leaks
    super.dispose();
  }
}
