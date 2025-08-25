import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  // images
  static const String imagesAssetsPath = 'assets/images/';
  static const String splashAssetsPath = 'assets/images/splash/';
  static const String onBoardingAssetsPath = 'assets/images/on_boarding/';
  static const String authAssetsPath = 'assets/images/auth/';
  static const String authHomePath = 'assets/images/home/';
  static const String profileAssetsPath = 'assets/images/profile/';
  static const String specialMembersPath = 'assets/images/special_members/';
  static const String blogPath = 'assets/images/blog/';
  static const String chatPath = 'assets/images/chat/';

  static const String notificationAssetsPath = 'assets/images/notification/';
  // svg
  static const String svgAssetsPath = 'assets/svg/';
  // lottie
  static const String lottiePath = 'assets/lottie/';
  //padding
  static const double defaultPadding = 16.0;
  static double defaultWidthPadding = 16.0.w;
  static double defaultHeightPadding = 16.0.h;

  static const double defaultBorderRadius = 12.0;
  static const double searchFieldHeight = 50.0;
}

// Pusher Configuration
class PusherConfig {
  static const String appId = '1893366';
  static const String appKey = '488b28cd543c3e616398';
  static const String appSecret = 'bb14accaa8c913fd988f';
  static const String cluster = 'eu';
  static const int port = 443;
  static const bool encrypted = true;
}
