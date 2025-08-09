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
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Icon(Icons.arrow_back_ios, size: 20.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'مدونة الصادقون و الصادقات',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.asset(
                                  blog.imageUrl,
                                  width: double.infinity,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  blog.title,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  blog.content,
                                  style: TextStyle(fontSize: 14.sp),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is BlogError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
