import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_data.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routes/app_routes.dart';
import '../../../../../chat/data/models/chat_room_model.dart';
import '../../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import '../../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';

class ProfileDetailsBody extends StatefulWidget {
  const ProfileDetailsBody({super.key, this.user, required this.userId});

  final UsersDataModel? user;
  final int userId;

  @override
  State<ProfileDetailsBody> createState() => _ProfileDetailsBodyState();
}

class _ProfileDetailsBodyState extends State<ProfileDetailsBody> {
  @override
  void initState() {
    super.initState();
    // Call getProfileDetails once when widget initializes
    context.read<ProfileDetailsCubit>().getProfileDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            CustomArrowBack(),
            ProfileDetailsLogo(),
            verticalSpace(20),
            Row(
              // spacing: 37.75,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(
                  img: AppImages.share,
                  color: AppColors.lightBlue.withValues(alpha: 0.07),
                  text: 'مشاركة',
                ),
                BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                  listenWhen: (context, current) =>
                      current is LikeUserLoading ||
                      current is LikeUserFailure ||
                      current is LikeUserSuccess,
                  listener: (context, state) {
                    if (state is LikeUserLoading) {
                      loadingDialog(context);
                    } else if (state is LikeUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is LikeUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم الاعجاب',
                          onPressed: () {
                            context.pop();
                            context.pop();
                          });
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.like,
                    color: AppColors.lightPink.withValues(alpha: 0.07),
                    text: 'اهتمام',
                    onTap: () {
                      context
                          .read<ProfileDetailsCubit>()
                          .likeUser(widget.userId);
                    },
                  ),
                ),
                BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                  listenWhen: (context, current) =>
                      current is IgnoreUserLoading ||
                      current is IgnoreUserFailure ||
                      current is IgnoreUserSuccess,
                  listener: (context, state) {
                    if (state is IgnoreUserLoading) {
                      loadingDialog(context);
                    } else if (state is IgnoreUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is IgnoreUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم التجاهل',
                          onPressed: () {
                            context.pop();
                            context.pop();
                          });
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.thumbDown,
                    color: AppColors.lightPink.withValues(alpha: 0.07),
                    text: 'تجاهل',
                    onTap: () {
                      context
                          .read<ProfileDetailsCubit>()
                          .ignoreUser(widget.userId);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      print('🔍 [ProfileDetails] Message icon tapped for user ID: ${widget.userId}');
                      
                      // Check if there's an existing chat room first
                      final chatListCubit = context.read<ChatListCubit>();
                      
                      // Check if chat list is already loaded, if not, load it silently
                      if (chatListCubit.state is! ChatListLoaded) {
                        print('🔄 [ProfileDetails] Chat list not loaded, loading silently...');
                        await chatListCubit.silentRefreshChatList();
                      } else {
                        print('✅ [ProfileDetails] Chat list already loaded');
                      }
                      
                      // Find existing chat room between current user and this profile user
                      final existingChatRoom = chatListCubit.findExistingChatRoom(widget.userId);
                      
                      if (existingChatRoom != null) {
                        print('✅ [ProfileDetails] Found existing chat room, navigating to it');
                        // Navigate to existing chat room
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatConversationScreen,
                          arguments: {
                            "chatRoom": existingChatRoom,
                          },
                        );
                      } else {
                        print('🆕 [ProfileDetails] No existing chat room found, creating new temporary chat');
                        // Get user data from the current state if available
                        final cubit = context.read<ProfileDetailsCubit>();
                        final state = cubit.state;

                        String userName = 'User';
                        String userImage = '';

                        if (state is GetProfileDetailsSuccess) {
                          final userData = state.profileDetailsResponseModel.data;
                          if (userData != null) {
                            userName = userData.name ?? 'User';
                            userImage = userData.image ?? '';
                          }
                        } else if (widget.user != null) {
                          // Fallback to passed user data if available
                          userName = widget.user!.name ?? 'User';
                          userImage = widget.user!.image ?? '';
                        }

                        // Create new temporary chat room for new conversation
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatConversationScreen,
                          arguments: {
                            "chatRoom": ChatRoomModel.fromUser(
                              userId: widget.userId,
                              userName: userName,
                              userImage: userImage,
                            ),
                          },
                        );
                      }
                    } catch (e) {
                      print('❌ [ProfileDetails] Error in message icon onTap: $e');
                      // Fallback to creating new chat
                      Navigator.pushNamed(
                        context,
                        AppRoutes.chatConversationScreen,
                        arguments: {
                          "chatRoom": ChatRoomModel.fromUser(
                            userId: widget.userId,
                            userName: widget.user?.name ?? 'User',
                            userImage: widget.user?.image ?? '',
                          ),
                        },
                      );
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.message,
                    color: AppColors.orangeLight.withValues(alpha: 0.07),
                    text: 'رسائل',
                  ),
                ),
                BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                  listenWhen: (context, current) =>
                      current is ReportUserLoading ||
                      current is ReportUserFailure ||
                      current is ReportUserSuccess,
                  listener: (context, state) {
                    if (state is ReportUserLoading) {
                      loadingDialog(context);
                    } else if (state is ReportUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is ReportUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم الابلاغ',
                          onPressed: () {
                            context.pop();
                            context.pop();
                          });
                    }
                  },
                  child: CustomContainer(
                    img: AppImages.block,
                    color: AppColors.lightRed.withValues(alpha: 0.07),
                    text: 'ابلاغ',
                    onTap: () {
                      context
                          .read<ProfileDetailsCubit>()
                          .reportUser(widget.userId);
                    },
                  ),
                ),
              ],
            ),
            verticalSpace(40),
            ProfileDetailsData(),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
