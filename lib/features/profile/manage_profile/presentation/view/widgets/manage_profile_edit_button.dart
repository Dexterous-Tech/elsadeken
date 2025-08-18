import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileEditButton extends StatelessWidget {
  const ManageProfileEditButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CustomElevatedButton(
          height: 66.h,
          onPressed: onPressed ?? () {},
          textButton: 'تعديل',
        ));
  }
}
