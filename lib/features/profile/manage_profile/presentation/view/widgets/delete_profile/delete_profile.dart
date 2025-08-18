import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteProfile extends StatelessWidget {
  const DeleteProfile({super.key, required this.isLoading});

  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageProfileCubit, ManageProfileState>(
      listenWhen: (previous, current) =>  current is DeleteProfileLoading || current is DeleteProfileFailure  || current is DeleteProfileSuccess,
      listener: (context, state) {
        if(state is DeleteProfileLoading){
          loadingDialog(context);
        }else if(state is DeleteProfileFailure){
          context.pop();
          errorDialog(context: context, error: state.error);
        }else if(state is DeleteProfileSuccess){
          context.pop();
          successDialog(context: context, message: state.profileActionResponseModel.message.toString(), onPressed: (){
            context.pop();
            context.pushNamedAndRemoveUntil(AppRoutes.onBoardingScreen);
          });
        }
      },
      child: GestureDetector(
        onTap: (){
          context.read<ManageProfileCubit>().deleteProfile();
        },
        child: ManageProfileContentItem(
          title: 'حذف حسابي',
          itemContent: ManageProfileContentText(
            text: 'حذف',
            isLoading: isLoading,
            textColor: AppColors.vividRed,
          ),
        ),
      ),
    );
  }
}
