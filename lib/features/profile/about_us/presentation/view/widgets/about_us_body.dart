import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class AboutUsBody extends StatefulWidget {
  const AboutUsBody({super.key});

  @override
  State<AboutUsBody> createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends State<AboutUsBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 25.w),
          child: VsScrollbar(
            controller: _scrollController,
            showTrackOnHover: true,
            isAlwaysShown: true,
            scrollbarFadeDuration: const Duration(milliseconds: 500),
            scrollbarTimeToFade: const Duration(milliseconds: 800),
            style: VsScrollbarStyle(
              hoverThickness: 5.0,
              radius: const Radius.circular(10),
              thickness: 8.0,
              color: AppColors.desire.withValues(alpha: 0.474),
            ),
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomArrowBack(),
                    Text(
                      'نبذه عننا',
                      style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                        fontWeight: FontWeightHelper.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
                verticalSpace(16),
                Text(
                  'من نحن',
                  style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeightHelper.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                verticalSpace(16),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                verticalSpace(30),
                Text(
                  'لوريم إيبسوم(Lorem Ipsum) هو ببساطة نص شكلي (بمعنى أن الغاية هي الشكل وليس المحتوى) ويُستخدم في صناعات المطابع ودور النشر. كان لوريم إيبسوم ولايزال المعيار للنص الشكلي منذ القرن الخامس عشر عندما قامت مطبعة مجهولة برص مجموعة من الأحرف بشكل عشوائي أخذتها من نص',
                  style: AppTextStyles.font14LightGrayRegularLamaSans
                      .copyWith(color: AppColors.lightMixGrayAndBlue),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
