import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/view/forget_password_screen.dart';
import 'package:elsadeken/features/auth/login/presentation/view/login_screen.dart';
import 'package:elsadeken/features/auth/new_password/presentation/view/new_password_screen.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/signup_screen.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/view/verification_email_screen.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/home/home/presentation/view/home_screen.dart';
import 'package:elsadeken/features/home/notification/notification/presentation/view/notification_screen.dart';
import 'package:elsadeken/features/home/person_details/view/person_details.dart';
import 'package:elsadeken/features/on_boarding/presentation/view/on_boarding_screen.dart';
import 'package:elsadeken/features/profile/about_us/presentation/view/about_us_screen.dart';
import 'package:elsadeken/features/profile/blog/presentation/cubit/blog_cubit.dart';
import 'package:elsadeken/features/profile/blog/presentation/view/blog_screen.dart';
import 'package:elsadeken/features/profile/contact_us/presentation/view/contact_us_screen.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/view/excellence_package_screen.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/view/interests_list_screen.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/manage_profile_screen.dart';
import 'package:elsadeken/features/profile/members_profile/presentation/view/members_profile_screen.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/view/my_excellence_screen.dart';
import 'package:elsadeken/features/profile/my_image/presentation/view/my_image_screen.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/view/my_interesting_list_screen.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/profile_screen.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/profile_details_screen.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/view/success_story_screen.dart';
import 'package:elsadeken/features/profile/technical_support/presentation/view/technical_support_screen.dart';
import 'package:elsadeken/features/results/presentation/view/results_screen.dart';
import 'package:elsadeken/features/search/logic/use_cases/search_use_cases.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/search/presentation/view/search_page.dart';
import 'package:elsadeken/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/chat/presentation/view/chat_conversation_screen.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/presentation/view/chat_settings_screen.dart';
import 'package:elsadeken/features/chat/presentation/view/chat_settings_screen_example.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_messages/cubit/chat_messages_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/pusher_cubit/cubit/pusher_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';

import '../../features/profile/my_ignoring_list/presentation/view/my_ignoring_list_screen.dart';
import 'package:elsadeken/features/profile/terms_conditions/presentation/view/terms_and_conditions_screen.dart';

class AppRouting {
  Route onGenerateRouting(RouteSettings setting) {
    final arguments = setting.arguments;

    switch (setting.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case AppRoutes.signupScreen:
        return MaterialPageRoute(
            builder: (_) => SignupScreen(
                  gender: arguments as String,
                ));
      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case AppRoutes.verificationEmailScreen:
        return MaterialPageRoute(
            builder: (_) => VerificationEmailScreen(
                  email: arguments as String,
                ));
      case AppRoutes.newPasswordScreen:
        return MaterialPageRoute(
            builder: (_) => NewPasswordScreen(
                  email: arguments as String,
                ));
      case AppRoutes.profileScreen:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case AppRoutes.manageProfileScreen:
        return MaterialPageRoute(builder: (_) => ManageProfileScreen());
      case AppRoutes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SearchCubit(sl<SearchUseCase>()),
            child: SearchPage(),
          ),
        );
      case AppRoutes.searchResultScreen:
        final searchCubit = setting.arguments as SearchCubit;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: searchCubit,
            child: const SearchResultsView(),
          ),
        );
      case AppRoutes.homeScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SearchCubit(sl<SearchUseCase>()),
                  child: HomeScreenWrapper(),
                ));
      case AppRoutes.notificationScreen:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case AppRoutes.profileDetailsScreen:
        // Handle UsersDataModel argument
        UsersDataModel user;
        if (arguments is UsersDataModel) {
          user = arguments;
        } else {
          // Fallback for backward compatibility
          int userId = 0;
          if (arguments is int) {
            userId = arguments;
          } else if (arguments is String) {
            userId = int.tryParse(arguments) ?? 0;
          }
          // Create a minimal user model with just the ID
          user = UsersDataModel(id: userId);
        }
        return MaterialPageRoute(
            builder: (_) => ProfileDetailsScreen(user: user));
      case AppRoutes.personDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final personId = args['personId'] as int;
        final imageUrl = args['imageUrl'] as String;
        return MaterialPageRoute(
            builder: (_) => PersonDetailsView(
                  personId: personId,
                  imageUrl: imageUrl,
                ));
      case AppRoutes.profileAboutUsScreen:
        return MaterialPageRoute(builder: (_) => AboutUsScreen());
      case AppRoutes.profileExcellencePackageScreen:
        return MaterialPageRoute(builder: (_) => ExcellencePackageScreen());
      case AppRoutes.profileMyExcellenceScreen:
        return MaterialPageRoute(builder: (_) => MyExcellenceScreen());
      case AppRoutes.profileMyInterestingListScreen:
        return MaterialPageRoute(builder: (_) => MyInterestingListScreen());
      case AppRoutes.profileMyIgnoringListScreen:
        return MaterialPageRoute(builder: (_) => MyIgnoringListScreen());
      case AppRoutes.profileInterestsListScreen:
        return MaterialPageRoute(builder: (_) => InterestsListScreen());
      case AppRoutes.profileMembersProfileScreen:
        return MaterialPageRoute(builder: (_) => MembersProfileScreen());
      case AppRoutes.profileContactUsScreen:
        return MaterialPageRoute(builder: (_) => ContactUsScreen());
      case AppRoutes.profileMyImageScreen:
        return MaterialPageRoute(builder: (_) => MyImageScreen());
      case AppRoutes.profileTechnicalSupportScreen:
        return MaterialPageRoute(builder: (_) => TechnicalSupportScreen());
      case AppRoutes.successStoriesScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: sl<SuccessStoryCubit>()..loadStories(),
                  child: SuccessStoriesScreen(),
                ));
      case AppRoutes.blogScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<BlogCubit>()..loadBlogs(),
            child: BlogScreen(),
          ),
        );
      case AppRoutes.chatConversationScreen:
        final args = arguments as Map<String, dynamic>;
        final chatRoom = args['chatRoom'] as ChatRoomModel;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ChatMessagesCubit>()),
              BlocProvider(create: (context) => sl<ManageProfileCubit>()),
              BlocProvider(create: (context) => sl<SendMessageCubit>()),
              BlocProvider(create: (context) => sl<PusherCubit>()),
              BlocProvider(create: (context) => sl<ChatListCubit>()),
            ],
            child: ChatConversationScreen(chatRoom: chatRoom),
          ),
        );
      case AppRoutes.chatSettingsScreen:
        return MaterialPageRoute(
          builder: (_) => const ChatSettingsScreenWrapper(),
        );
      case AppRoutes.termsAndConditionsScreen:
        return MaterialPageRoute(builder: (_) => TermsAndConditionsScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold());
    }
  }
}

PageRouteBuilder pageRouteBuilder(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0); // From bottom to top
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(seconds: 2), // Slow and smooth
  );
}
