import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/app_color.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Settings list
  final List<Map<String, dynamic>> _settings = [
    {"title": "من وضعني في قائمته المفضلة؟", "value": true},
    {"title": "زيارات ملفي الشخصي", "value": true},
    {"title": "من أضافني إلى قائمة التجاهل؟", "value": true},
    {"title": "رسائل جديدة", "value": true},
    {"title": "من سمع لي برؤية صورته؟", "value": true},
    {"title": "قصص ناجحة", "value": true},
    {"title": "إشعار نغمة الرنين", "value": false},
    {"title": "تنبيه بالاهتزاز", "value": false},
    {"title": "أعلمني عند إيقاف تشغيل التطبيق", "value": false},
    {"title": "استلام إشعار على البريد الإلكتروني", "value": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: CustomProfileBody(
          contentBody: Column(
            children: [
              _buildTopBar(),
              SizedBox(height: 12.h),
              Expanded(
                child: _buildChatContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Top Bar with background
  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: const ProfileHeader(
        title: 'إعدادات الإشعارات',
        background: Colors.transparent,
      ),
    );
  }

  /// Settings List
  Widget _buildChatContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _settings.length,
        separatorBuilder: (_, __) => Divider(
          color: Colors.grey[300],
          thickness: 0.5,
          height: 1.h,
        ),
        itemBuilder: (context, index) {
          return SwitchListTile(
            contentPadding:
                EdgeInsets.zero,
            title: Text(
              _settings[index]["title"],
              style: AppTextStyles.font16ChineseBlackMediumLamaSans,
            ),
            value: _settings[index]["value"],
            onChanged: (bool newValue) {
              setState(() {
                _settings[index]["value"] = newValue;
              });
            },
            activeColor: AppColors.primaryOrange,
            activeTrackColor: AppColors.primaryOrange.withOpacity(0.3),
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.grey,
          );
        },
      ),
    );
  }
}
