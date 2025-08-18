import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/blog_cubit.dart';
import '../cubit/blog_states.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlogCubit, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return CustomProfileBody(
                withStar: false,

                contentBody: Column(
              children: [
                ProfileHeader(title: 'مدونة الصادقون و الصادقات'),
                SizedBox(height: 20.h),
                Expanded(
                    child: const Center(
                        child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ))),
              ],
            ));
          } else if (state is BlogLoaded) {
            return CustomProfileBody(
              withStar: false,

              contentBody: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileHeader(title: 'مدونة الصادقون و الصادقات'),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.blogs.length,
                      separatorBuilder: (_, __) => SizedBox(height: 24.h),
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  blog.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child:
                                        Icon(Icons.broken_image, size: 24.sp),
                                  ),
                                  loadingBuilder: (_, child, progress) =>
                                      progress == null
                                          ? child
                                          : Center(
                                              child: SizedBox(
                                                  height: 24.h,
                                                  width: 24.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2))),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                blog.title,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFBC85),
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                blog.content,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF363636)),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is BlogError) {
            return CustomProfileBody(
                withStar: false,

                contentBody: Column(
              children: [
                ProfileHeader(title: 'مدونة الصادقون و الصادقات'),
                SizedBox(height: 20.h),
                Expanded(child: Center(child: Text(state.message))),
              ],
            ));
          }
          return Container();
        },
      ),
    );
  }
}
