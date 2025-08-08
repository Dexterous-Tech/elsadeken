import '../../../../../../core/theme/spacing.dart';
import 'technical_support_messages_list.dart';
import 'technical_support_send.dart';
import '../../../../widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicalSupportBody extends StatelessWidget {
  const TechnicalSupportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: TextDirection.rtl,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          child: ProfileHeader(title: 'الدعم الفني'),
        ),
        verticalSpace(32),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(right: 16.w, left: 30.w),
          child: TechnicalSupportMessagesList(),
        )),
        TechnicalSupportSend(),
      ],
    ));
  }
}
