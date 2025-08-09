import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:elsadeken/features/blog/data/repository/blog_repo_impl.dart';
import 'package:elsadeken/features/blog/domain/repository/blog_repo.dart';
import 'package:elsadeken/features/blog/presentation/cubit/blog_cubit.dart';
import 'package:elsadeken/features/blog/presentation/view/blog_screen.dart';
import 'package:elsadeken/features/success_stories/data/repository/success_story_repo_impl.dart';
import 'package:elsadeken/features/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:elsadeken/features/success_stories/presentation/view/success_story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';
import 'features/blog/data/datasources/blog_api.dart';
import 'features/blog/domain/use_cases/get_blog_posts.dart';
import 'features/success_stories/domain/repository/success_storie_repo.dart';
import 'features/success_stories/domain/use_cases/get_success_story.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(Elsadeken(appRouting: AppRouting()));
}

class Elsadeken extends StatelessWidget {
   Elsadeken({super.key, required this.appRouting});

   final BlogCubit blogCubit = BlogCubit(GetBlogPosts(BlogApi()));
   final SuccessStoryCubit successStoryCubit = SuccessStoryCubit(GetSuccessStories(SuccessStoryRepositoryImpl()));
   final AppRouting appRouting;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 937),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [DefaultMaterialLocalizations.delegate],
        // supportedLocales: [
        //   Locale('ar', 'SA'), // Arabic
        //   Locale('en', 'US'), // English
        // ],
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        onGenerateRoute: appRouting.onGenerateRouting,
        initialRoute: AppRoutes.profileScreen,

        //start with blog Screen
        home: BlocProvider.value(
          value: blogCubit..getBlogPosts,
          child: BlogScreen(),
    ),
        /* // Start with SuccessStoryScreen
        home: BlocProvider.value(
          value: successStoryCubit..loadStories(),
          child: SuccessStoryScreen(),
        ),*/
      ),
    );
  }
}
