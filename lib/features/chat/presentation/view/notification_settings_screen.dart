import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';

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
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildChatContent(),
                SizedBox(height: 100.h), // Bottom padding for scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Top Bar with background
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.h),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              color: AppColors.white,
            ),
            child: const ProfileHeader(title: 'إعدادات الإشعارات'),
          ),
          Positioned(
            top: 0,
            left: -20,
            child: Image.asset(
              AppImages.starProfile,
              width: 400.w,
              height: 250.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  /// Settings List
  Widget _buildChatContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(_settings.length, (index) {
          return Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                title: Text(
                  _settings[index]["title"],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                value: _settings[index]["value"],
                onChanged: (bool newValue) {
                  setState(() {
                    _settings[index]["value"] = newValue;
                  });
                  // Add debug print to verify the switch is working
                  print('Switch ${_settings[index]["title"]} changed to: $newValue');
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
              ),
              if (index < _settings.length - 1)
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
            ],
          );
        }),
      ),
    );
  }
}
