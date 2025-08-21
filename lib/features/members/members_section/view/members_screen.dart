import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/members/members_section/view/widgets/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

import '../../Health_statuses/presentation/view/health_statuses_view.dart';
import '../../new_members/presentation/view/new_members_screen.dart';
import '../../online_members/presentation/view/online_members_screen.dart';
import '../../premium_members/presentation/view/premium_members_screen.dart';
import '../../viewers/presentation/view/viewers_screen.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'المتواجدون الان',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item1.png',
      'screen': 'online_members_screen',
    },
    {
      'title': 'من زار بياناتي',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item2.png',
      'screen': 'profile_visitors_screen',
    },
    {
      'title': 'اعضاء جدد',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item3.png',
      'screen': 'new_members_screen',
    },
    {
      'title': 'الاعضاء المميزين',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item4.png',
      'screen': 'premium_members_screen',
    },
    {
      'title': 'الحالات الصحية',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item5.png',
      'screen': 'health_status_screen',
    },
    {
      'title': 'الباحث الآلي',
      'backgroundColor': AppColors.beige,
      'avatarAsset': 'assets/images/members/menu_items/member_item6.png',
      'screen': 'smart_search_screen',
    },
  ];

  void _navigateToScreen(BuildContext context, String screenName) async {
    await Future.delayed(const Duration(milliseconds: 150));

    switch (screenName) {
      case 'online_members_screen':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const OnlineMembersView()));
        break;
      case 'profile_visitors_screen':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ViewersView()));
        break;
      case 'new_members_screen':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const NewMembersView()));
        break;
      case 'premium_members_screen':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PremiumMembersView()));
        break;
      case 'health_status_screen':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const HealthStatusesView()));
      //   break;
      // case 'smart_search_screen':
      //   Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartSearchScreen()));
      //   break;
      default:
        debugPrint('Unknown screen: $screenName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: -20,
            child: Image.asset(
              AppImages.starProfile,
              width: 488.w,
              height: 325.h,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'الاعضاء',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _menuItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return MenuItemWidget(
                          title: item['title'],
                          backgroundColor: item['backgroundColor'],
                          avatarAsset: item['avatarAsset'],
                          onTap: () => _navigateToScreen(context, item['screen']),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
