import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/action_buttons/action_buttons_row.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_data.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsBody extends StatefulWidget {
  const ProfileDetailsBody({super.key, this.user, required this.userId});

  final UsersDataModel? user;
  final int userId;

  @override
  State<ProfileDetailsBody> createState() => _ProfileDetailsBodyState();
}

class _ProfileDetailsBodyState extends State<ProfileDetailsBody> {
  UsersDataModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    // Call getProfileDetails once when widget initializes
    context.read<ProfileDetailsCubit>().getProfileDetails(widget.userId);
  }

  void _updateUserState() {
    setState(() {
      _currentUser = _currentUser?.copyWith(
        isFavorite: !(_currentUser?.isFavorite ?? false),
        isIgnore: !(_currentUser?.isIgnore ?? false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
      listenWhen: (context, current) => current is GetProfileDetailsSuccess,
      listener: (context, state) {
        if (state is GetProfileDetailsSuccess) {
          // Update current user data when profile details are loaded
          final userData = state.profileDetailsResponseModel.data;
          if (userData != null) {
            setState(() {
              _currentUser = _currentUser?.copyWith(
                  isFavorite: userData.isFavorite,
                  isIgnore: userData.isIgnore,
                  name: userData.name,
                  image: userData.image,
                  isBlocked: userData.isBlocked);
            });
          }
        }
      },
      child: CustomProfileBody(
        contentBody: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: LocalizationService.instance.textDirection,
            children: [
              CustomArrowBack(),
              ProfileDetailsLogo(),
              verticalSpace(20),
              ActionButtonsRow(
                userId: widget.userId,
                currentUser: _currentUser,
                user: widget.user,
                onUserStateChanged: _updateUserState,
              ),
              verticalSpace(40),
              ProfileDetailsData(),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
