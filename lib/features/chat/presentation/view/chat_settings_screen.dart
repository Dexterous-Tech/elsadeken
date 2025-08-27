import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool _isOnline = true;
  bool _newMessagesNotification = false;
  bool _profilePictureNotification = false;
  String _selectedAgeCategory = 'أي شخص';
  String _selectedNationalities = 'كل الجنسيات';
  String _selectedCountries = 'كل الدول';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              // Background image should be behind content
             /* Positioned(
                top: 100.h,
                right: -100.w,
                child: _buildBackgroundImage(),
              ),*/
              // Fallback background decoration
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 300.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              // Content should be on top and interactive
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/chat/mail 1.png',
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildBody(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/chat/mail 1.png',
      width: 400,
      height: 400,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        print('Background image error: $error'); // Debug print
        return Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(200),
          ),
          child: Icon(
            Icons.mail,
            size: 100,
            color: Colors.grey[400],
          ),
        );
      },
    );
  }

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
            child: const ProfileHeader(title: 'إعدادات الرسائل'),
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

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConnectionStatusSection(),
                SizedBox(height: 24.h),
                _buildDivider(),
                SizedBox(height: 24.h),
                _buildWhoCanSendSection(),
                SizedBox(height: 24.h),
                _buildDivider(),
                SizedBox(height: 24.h),
                _buildNotificationSettingsSection(),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
        _buildSaveButton(),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildConnectionStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'حالة الاتصال الخاصة بك',
          style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        _buildSettingRow(
          title: 'متصل الآن',
          subtitle: 'أظهر أنك متصل',
          showGreenDot: true,
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isOnline,
              onChanged: (value) {
                setState(() {
                  _isOnline = value;
                });
              },
              activeColor: Colors.orangeAccent,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWhoCanSendSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'من يستطيع إرسال الرسائل إليك؟',
            style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSettingRow(
            title: 'الفئة العمرية',
            subtitle: _selectedAgeCategory,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showAgeCategoryDialog,
          ),
          SizedBox(height: 12.h),
          _buildSettingRow(
            title: 'الجنسيات',
            subtitle: _selectedNationalities,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showNationalitiesDialog,
          ),
          SizedBox(height: 12.h),
          _buildSettingRow(
            title: 'الدول',
            subtitle: _selectedCountries,
            trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
            onTap: _showCountriesDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'إعدادات الإشعارات',
          style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        _buildSettingRow(
          title: 'رسائل جديدة',
          subtitle: '',
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _newMessagesNotification,
              onChanged: (value) {
                setState(() {
                  _newMessagesNotification = value;
                });
              },
              activeColor: Colors.orangeAccent,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _buildSettingRow(
          title: 'من سمح لي برؤية صورته؟',
          subtitle: '',
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _profilePictureNotification,
              onChanged: (value) {
                setState(() {
                  _profilePictureNotification = value;
                });
              },
              activeColor: Colors.orangeAccent,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showGreenDot = false, // Add this flag
  }) {
    return InkWell(
      splashColor: Colors.blue.withOpacity(0.3),
      highlightColor: Colors.blue.withOpacity(0.1),
      onTap: onTap != null ? () {
        print('Tapped on: $title'); // Debug print
        onTap();
      } : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFfbecef).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (showGreenDot) ...[
                    SizedBox(width: 8.w),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: AppTextStyles.font14BlackRegularLamaSans.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      color: Colors.grey[300],
    );
  }

  Widget _buildSaveButton() {
    return CustomElevatedButton(
      onPressed: _saveSettings,
      textButton: 'حفظ',
      height: 56.h,
      radius: 28.r,
      styleTextButton: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAgeCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الفئة العمرية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('أي شخص', () {
              setState(() => _selectedAgeCategory = 'أي شخص');
              Navigator.pop(context);
            }),
            _buildDialogOption('18-25', () {
              setState(() => _selectedAgeCategory = '18-25');
              Navigator.pop(context);
            }),
            _buildDialogOption('26-35', () {
              setState(() => _selectedAgeCategory = '26-35');
              Navigator.pop(context);
            }),
            _buildDialogOption('36-45', () {
              setState(() => _selectedAgeCategory = '36-45');
              Navigator.pop(context);
            }),
            _buildDialogOption('45+', () {
              setState(() => _selectedAgeCategory = '45+');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showNationalitiesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الجنسيات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('كل الجنسيات', () {
              setState(() => _selectedNationalities = 'كل الجنسيات');
              Navigator.pop(context);
            }),
            _buildDialogOption('عربي', () {
              setState(() => _selectedNationalities = 'عربي');
              Navigator.pop(context);
            }),
            _buildDialogOption('أجنبي', () {
              setState(() => _selectedNationalities = 'أجنبي');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showCountriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الدول'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('كل الدول', () {
              setState(() => _selectedCountries = 'كل الدول');
              Navigator.pop(context);
            }),
            _buildDialogOption('السعودية', () {
              setState(() => _selectedCountries = 'السعودية');
              Navigator.pop(context);
            }),
            _buildDialogOption('الإمارات', () {
              setState(() => _selectedCountries = 'الإمارات');
              Navigator.pop(context);
            }),
            _buildDialogOption('الكويت', () {
              setState(() => _selectedCountries = 'الكويت');
              Navigator.pop(context);
            }),
            _buildDialogOption('قطر', () {
              setState(() => _selectedCountries = 'قطر');
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogOption(String text, VoidCallback onTap) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}
