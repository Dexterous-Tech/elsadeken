import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/view/widget/story_card.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/success_story_states.dart';

class SuccessStoriesScreen extends StatelessWidget {
  const SuccessStoriesScreen({super.key});

  String _formatNumber(int number) {
    final numberString = number.toString();
    final buffer = StringBuffer();
    
    for (int i = 0; i < numberString.length; i++) {
      if (i > 0 && (numberString.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(numberString[i]);
    }
    
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SuccessStoryCubit, SuccessStoryState>(
        builder: (context, state) {
          if (state is SuccessStoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SuccessStoryLoaded) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: ProfileHeader(title: 'القصص الناجحة'),
                    ),
                    verticalSpace(32),
                    // Top Image
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          AppImages.weddingBlog,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Text.rich(
                        TextSpan(
                          text: 'بحمد الله ',
                          style: TextStyle(
                            color: AppColors.primaryOrangeMod,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamilyHelper.plexSansArabic,
                          ),
                          children: [
                            TextSpan(
                              text: _formatNumber(state.totalCount),
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamilyHelper.plexSansArabic,
                              ),
                            ),
                            TextSpan(
                              text: ' قصة ناجحة',
                              style: TextStyle(
                                color: AppColors.primaryOrangeMod,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamilyHelper.plexSansArabic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Image.asset(
                        height: 80.h,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        AppImages.success2Blog,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomElevatedButton(
                        onPressed: () {},
                        textButton: "قصص ناجحة حسب البلدان",
                        styleTextButton: TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamilyHelper.plexSansArabic,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        horizontalPadding: 10,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Stories List
                    ...state.stories.map((story) => StoryCard(
                        title: story.title,
                        content: story.content,
                        image: story.image)),
                    SizedBox(height: 20.h),
                    CustomElevatedButton(
                      onPressed: () {},
                      textButton: "اغلاق",
                      horizontalPadding: 10,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is SuccessStoryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
