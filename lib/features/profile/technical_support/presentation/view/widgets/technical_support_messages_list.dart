import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/technical_support/presentation/view/widgets/technical_support_message.dart';
import 'package:flutter/material.dart';

class TechnicalSupportMessagesList extends StatelessWidget {
  const TechnicalSupportMessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return TechnicalSupportMessage();
      },
      separatorBuilder: (context, index) {
        return verticalSpace(16);
      },
      itemCount: 1,
    );
  }
}
