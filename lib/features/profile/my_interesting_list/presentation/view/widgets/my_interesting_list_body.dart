import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/view/widgets/my_interesting_list_items.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_success_way.dart';
import '../../../../widgets/profile_header.dart';

class MyInterestingListBody extends StatelessWidget {
  const MyInterestingListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: LocalizationService.instance.textDirection,
        children: [
          ProfileHeader(title: AppLocalizations.of(context)!.whoInterestsMe),
          verticalSpace(42),
          ContainerSuccessWay(),
          verticalSpace(32),
          Expanded(child: MyInterestingListItems()),
        ],
      ),
    );
  }
}
