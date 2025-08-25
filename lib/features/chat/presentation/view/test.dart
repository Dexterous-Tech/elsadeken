import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool _isOnline = false;
  bool _newMessagesNotification = false;
  bool _profilePictureNotification = false;
  String _selectedAgeCategory = 'أي شخص';
  String _selectedNationalities = 'كل الجنسيات';
  String _selectedCountries = 'كل الدول';

  @override
  Widget build(BuildContext context) {
    try {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      );
    } catch (e) {
      // Fallback UI if something goes wrong
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const CustomArrowBack(),
          title: Text(
            'إعدادات الرسائل',
            style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.w, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                'حدث خطأ في تحميل الشاشة',
                style: AppTextStyles.font16BlackSemiBoldLamaSans,
              ),
              SizedBox(height: 8.h),
              Text(
                'يرجى المحاولة مرة أخرى',
                style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'إعدادات الرسائل',
        style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        // Background image with error handling
        Positioned.fill(
          child: _buildBackgroundImage(),
        ),

        // Main content
        SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Main settings card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFFF0F0).withOpacity(0.9), // More transparent to show background
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Connection Status Section
                      _buildConnectionStatusSection(),

                      SizedBox(height: 24.h),
                      _buildDivider(),
                      SizedBox(height: 24.h),

                      // Who can send messages Section
                      _buildWhoCanSendSection(),

                      SizedBox(height: 24.h),
                      _buildDivider(),
                      SizedBox(height: 24.h),

                      // Notification Settings Section
                      _buildNotificationSettingsSection(),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Save Button
              _buildSaveButton(),

              SizedBox(height: 100.h), // Space for bottom navigation
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/chat/mail 1.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to colored background if image fails
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFF0F0).withOpacity(0.3),
          ),
        );
      },
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
          title: 'متصل اللآن',
          subtitle: 'أظهر أنك متصل',
          trailing: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Switch(
                value: _isOnline,
                onChanged: (value) {
                  setState(() {
                    _isOnline = value;
                  });
                },
                activeColor: AppColors.primaryOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhoCanSendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'من يستطيع إرسال الرسائل إليك؟',
          style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),

        // Age Category
        _buildSettingRow(
          title: 'الفئة العمرية',
          subtitle: _selectedAgeCategory,
          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
          onTap: () => _showAgeCategoryDialog(),
        ),

        SizedBox(height: 12.h),

        // Nationalities
        _buildSettingRow(
          title: 'الجنسيات',
          subtitle: _selectedNationalities,
          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
          onTap: () => _showNationalitiesDialog(),
        ),

        SizedBox(height: 12.h),

        // Countries
        _buildSettingRow(
          title: 'الدول',
          subtitle: _selectedCountries,
          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
          onTap: () => _showCountriesDialog(),
        ),
      ],
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
          subtitle: 'إشعارات الرسائل الجديدة',
          trailing: Switch(
            value: _newMessagesNotification,
            onChanged: (value) {
              setState(() {
                _newMessagesNotification = value;
              });
            },
            activeColor: AppColors.primaryOrange,
          ),
        ),

        SizedBox(height: 12.h),

        _buildSettingRow(
          title: 'من سمح لي برؤية صورته؟',
          subtitle: 'إشعارات الصور الشخصية',
          trailing: Switch(
            value: _profilePictureNotification,
            onChanged: (value) {
              setState(() {
                _profilePictureNotification = value;
              });
            },
            activeColor: AppColors.primaryOrange,
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Color(0xFFfbecef).withOpacity(0.7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

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
    return Container(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          'حفظ',
          style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAgeCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختر الفئة العمرية'),
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
        title: Text('اختر الجنسيات'),
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
        title: Text('اختر الدول'),
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