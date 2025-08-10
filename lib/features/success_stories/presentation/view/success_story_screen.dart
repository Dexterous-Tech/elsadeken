import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/success_stories/presentation/view/widget/story_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/success_story_cubit.dart';
import '../cubit/success_story_states.dart';

class SuccessStoriesScreen extends StatelessWidget {
  const SuccessStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 20.spMax),),
        centerTitle: true,
        title: Text(
          "القصص الناجحة",
          style: TextStyle(
              fontSize: 23.spMax,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamilyHelper.lamaSansArabic),
        ),
      ),
      body: BlocBuilder<SuccessStoryCubit, SuccessStoryState>(
        builder: (context, state) {
          if (state is SuccessStoryLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SuccessStoryLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  // Top Image
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        'assets/images/Blog/wedd.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(15.h),
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
                            text: '470,455',
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
                     padding:  EdgeInsets.symmetric(horizontal: 30.w),
                     child: Image.asset(
                       height: 80.h,
                       width: double.infinity,
                       fit: BoxFit.fitWidth,
                       'assets/images/Blog/success2.png',
                     ),
                   ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomElevatedButton(onPressed: (){},
                      textButton: "قصص ناجحة حسب البلدان",styleTextButton: TextStyle(
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
                  ...state.stories.map((story) => StoryCard(name: story.name, age: story.age, message: story.message)),
                  SizedBox(height: 20.h),
                  CustomElevatedButton(onPressed: (){},
                    textButton: "اغلاق",
                    horizontalPadding: 10,
                  ),
                ],
              ),
            );
          }
          if (state is SuccessStoryError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }
}
