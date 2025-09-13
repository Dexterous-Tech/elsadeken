import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/members/members_section/view/widgets/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../Health_statuses/presentation/view/health_statuses_view.dart';
import '../../new_members/presentation/view/new_members_screen.dart';
import '../../online_members/presentation/view/online_members_screen.dart';
import '../../premium_members/presentation/view/premium_members_screen.dart';
import '../../viewers/presentation/view/viewers_screen.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  List<Map<String, dynamic>> _getMenuItems(BuildContext context) => [
        {
          'title': AppLocalizations.of(context)!.onlineMembers,
          'backgroundColor': AppColors.beige,
          'avatarAsset': AppImages.memberItem1,
          'screen': 'online_members_screen',
        },
        {
          'title': AppLocalizations.of(context)!.profileVisitors,
          'backgroundColor': AppColors.beige,
          'avatarAsset': AppImages.memberItem2,
          'screen': 'profile_visitors_screen',
        },
        {
          'title': AppLocalizations.of(context)!.newMembers,
          'backgroundColor': AppColors.beige,
          'avatarAsset': AppImages.memberItem3,
          'screen': 'new_members_screen',
        },
        {
          'title': AppLocalizations.of(context)!.premiumMembers,
          'backgroundColor': AppColors.beige,
          'avatarAsset': AppImages.memberItem4,
          'screen': 'premium_members_screen',
        },
        {
          'title': AppLocalizations.of(context)!.healthStatuses,
          'backgroundColor': AppColors.beige,
          'avatarAsset': AppImages.memberItem5,
          'screen': 'health_status_screen',
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
                            AppLocalizations.of(context)!.members,
                            style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _getMenuItems(context).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final item = _getMenuItems(context)[index];
                        return MenuItemWidget(
                          title: item['title'],
                          backgroundColor: item['backgroundColor'],
                          avatarAsset: item['avatarAsset'],
                          onTap: () =>
                              _navigateToScreen(context, item['screen']),
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
