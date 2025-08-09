import 'package:elsadeken/features/members/special_members/presentation/view/widgets/action_button.dart';
import 'package:elsadeken/features/members/special_members/presentation/view/widgets/details_table.dart';
import 'package:flutter/material.dart';
import 'package:elsadeken/core/helper/app_images.dart';

class SpecialMembersScreen extends StatelessWidget {
  const SpecialMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              AppImages.specialMembersAvatar,
              width: 176,
              height: 195,
            ),
            SizedBox(height: 12),
            const Text(
              'مطلق - 56 سنه',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    iconPath: AppImages.specialMembersReportIcon,
                    label: 'الإبلاغ',
                    backgroundColor: const Color(0xFFFFEDEC),
                    onTap: () {},
                  ),
                  ActionButton(
                    iconPath: AppImages.specialMembersMessageIcon,
                    label: 'رسائل',
                    backgroundColor: Colors.grey.shade200,
                    onTap: () {},
                  ),
                  ActionButton(
                    iconPath: AppImages.specialMembersDislikeIcon,
                    label: 'تجاهل',
                    backgroundColor: const Color(0xFFFFEDEC),
                    onTap: () {},
                  ),
                  ActionButton(
                    iconPath: AppImages.specialMembersLikeIcon,
                    label: 'إهتمام',
                    backgroundColor: Color(0xFFFFEDEC),
                    onTap: () {},
                  ),
                  ActionButton(
                    iconPath: AppImages.specialMembersShareIcon,
                    label: 'مشاركة',
                    backgroundColor: const Color(0xFFD5E5F1),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const DetailsTable(),
          ],
        ),
      ),
    );
  }
}
