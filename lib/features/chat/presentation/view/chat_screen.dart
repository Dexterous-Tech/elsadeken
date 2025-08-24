import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_filter_button.dart';
import 'package:elsadeken/features/chat/presentation/widgets/chat_options_card.dart';
import 'package:elsadeken/features/chat/presentation/widgets/empty_chat_illustration.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: _buildEmptyState(), 
              ),
              const ChatOptionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Top Bar
  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.starProfile),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'الرسائل',
            style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
              color: AppColors.darkerBlue,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F1E8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatFilterButton(
                  text: 'الكل',
                  isActive: true,
                  onTap: () {},
                ),
                SizedBox(width: 4.w),
                ChatFilterButton(
                  text: 'القائمة المفضلة',
                  isActive: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyChatIllustration(),
          SizedBox(height: 24.h),
          Text(
            'لا يوجد إشعارات حتى الآن',
            style: AppTextStyles.font23ChineseBlackBoldLamaSans.copyWith(
              color: AppColors.darkerBlue,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'ليس لديك أي إشعارات في الوقت الحالي.',
            style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
              color: AppColors.darkerBlue.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'عد لاحقاً',
            style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
              color: AppColors.darkerBlue.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),       
          ],
      ),
    );
  }
}
