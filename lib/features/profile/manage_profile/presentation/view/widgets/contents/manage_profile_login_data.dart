import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProfileLoginData extends StatelessWidget {
  const ManageProfileLoginData({
    super.key,
    this.profileData,
    this.isLoading = false,
  });

  final MyProfileDataModel? profileData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'رقم العضوية',
          itemContent: ManageProfileContentText(
            text: profileData?.id?.toString() ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'اسم المستخدم',
          itemContent: ManageProfileContentText(
            text: profileData?.name ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'رقم الهاتف',
          itemContent: ManageProfileContentText(
            text: profileData?.phone ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'تاريخ التسجيل',
          itemContent: ManageProfileContentText(
            text: _formatDate(profileData?.createdAt),
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'كلمة المرور',
          itemContent: ManageProfileContentText(
            text: '**********',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'البريد الإلكتروني',
          itemContent: ManageProfileContentText(
            text: profileData?.email ?? '',
            isLoading: isLoading,
          ),
        ),
        ManageProfileCustomSeparator(),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: isLoading ? null : () => _showLoginDataEditDialog(context),
        )
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'اليوم';
      } else if (difference.inDays == 1) {
        return 'منذ يوم واحد';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'منذ $weeks أسابيع';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'منذ $months أشهر';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'منذ $years سنوات';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _showLoginDataEditDialog(BuildContext context) {
    final updateProfileCubit = context.read<UpdateProfileCubit>();

    final dialogData = ManageProfileDialogData(
      title: 'تعديل بيانات تسجيل الدخول',
      cubit: updateProfileCubit,
      fields: [
        ManageProfileField(
          label: 'اسم المستخدم',
          hint: 'أدخل اسم المستخدم',
          currentValue: profileData?.name ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.text,
        ),
        ManageProfileField(
          label: 'رقم الهاتف',
          hint: 'أدخل رقم الهاتف',
          currentValue: profileData?.phone ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.phone,
        ),
        ManageProfileField(
          label: 'البريد الإلكتروني',
          hint: 'أدخل البريد الإلكتروني',
          currentValue: profileData?.email ?? '',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.emailAddress,
        ),
        ManageProfileField(
          label: 'كلمة المرور',
          hint: 'أدخل كلمة المرور الجديدة',
          currentValue: '',
          type: ManageProfileFieldType.password,
        ),
        ManageProfileField(
          label: 'تأكيد كلمة المرور',
          hint: 'أدخل تأكيد كلمة المرور',
          currentValue: '',
          type: ManageProfileFieldType.password,
        ),
      ],
    );

    manageProfileDialog(context, dialogData);
  }
}
