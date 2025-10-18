import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/ignore_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/dialog/report_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_data.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
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
  UsersDataModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    // Call getProfileDetails once when widget initializes
    context.read<ProfileDetailsCubit>().getProfileDetails(widget.userId);
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
              Row(
                // spacing: 37.75,
                textDirection: LocalizationService.instance.textDirection,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                    listenWhen: (context, current) =>
                        current is ShareUserLoading ||
                        current is ShareUserFailure ||
                        current is ShareUserSuccess,
                    listener: (context, state) {
                      if (state is ShareUserLoading) {
                        // loadingDialog(context);
                      } else if (state is ShareUserFailure) {
                        context.pop();
                        errorDialog(context: context, error: state.error);
                      }
                      // else if (state is ShareUserSuccess) {
                      //   context.pop();
                      //   _showShareSuccessDialog(
                      //     context: context,
                      //     message: state
                      //             .profileDetailsActionResponseModel.message ??
                      //         AppLocalizations.of(context)!.shareLinkCreated,
                      //     shareUrl: state
                      //         .profileDetailsActionResponseModel.data?.shareUrl,
                      //   );
                      // }
                      else if (state is ShareUserSuccess) {
                        // context.pop(); // close loading dialog if open

                        final shareUrl = state
                            .profileDetailsActionResponseModel.data?.shareUrl;

                        if (shareUrl != null && shareUrl.isNotEmpty) {
                          // ✅ New API syntax
                          SharePlus.instance.share(
                            ShareParams(
                              text:
                                  '${AppLocalizations.of(context)!.checkOutProfile}: \n$shareUrl',
                              subject: 'User Profile',
                            ),
                          );
                        } else {
                          errorDialog(
                              context: context,
                              error: AppLocalizations.of(context)!
                                  .noShareLinkAvailable);
                        }
                      }
                    },
                    child: CustomContainer(
                      img: AppImages.share,
                      text: AppLocalizations.of(context)!.share,
                      onTap: () {
                        context
                            .read<ProfileDetailsCubit>()
                            .shareUser(widget.userId);
                      },
                    ),
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

                        // Update the current user's favorite status
                        setState(() {
                          _currentUser = _currentUser?.copyWith(
                            isFavorite: !(_currentUser?.isFavorite ?? false),
                          );
                        });

                        // Reload profile data to get updated information
                        context
                            .read<ProfileDetailsCubit>()
                            .getProfileDetails(widget.userId);

                        successDialog(
                            context: context,
                            message: state.profileDetailsActionResponseModel
                                    .message ??
                                AppLocalizations.of(context)!.liked,
                            onPressed: () {
                              context.pop();
                            });
                      }
                    },
                    child: (_currentUser?.isBlocked ?? false)
                        ? Opacity(
                            opacity: 0.3,
                            child: CustomContainer(
                              img: AppImages.like,
                              text: AppLocalizations.of(context)!.interest,
                              onTap: null, // Disable tap when blocked
                            ),
                          )
                        : (_currentUser?.isIgnore ?? false)
                            ? Opacity(
                                opacity: 0.3,
                                child: CustomContainer(
                                  img: AppImages.like,
                                  text: AppLocalizations.of(context)!.interest,
                                  onTap: () {
                                    ignoreDialog(
                                        afterSuccess: () {
                                          setState(() {
                                            _currentUser =
                                                _currentUser?.copyWith(
                                              isIgnore:
                                                  !(_currentUser?.isIgnore ??
                                                      false),
                                            );
                                          });
                                        },
                                        context: context,
                                        message: AppLocalizations.of(context)!
                                            .unignorePersonQu,
                                        textButton:
                                            AppLocalizations.of(context)!
                                                .unignoreButton,
                                        userId: widget.userId);
                                  }, // Disable tap when ignored
                                ),
                              )
                            : CustomContainer(
                                img: AppImages.like,
                                text: (_currentUser?.isFavorite ?? false)
                                    ? AppLocalizations.of(context)!.liked
                                    : AppLocalizations.of(context)!.interest,
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
                      if (state is IgnoreUserSuccess) {
                        // Update the current user's ignore status
                        setState(() {
                          _currentUser = _currentUser?.copyWith(
                            isIgnore: !(_currentUser?.isIgnore ?? false),
                          );
                        });
                      }
                    },
                    child: (_currentUser?.isBlocked ?? false)
                        ? Opacity(
                            opacity: 0.3,
                            child: CustomContainer(
                              img: AppImages.thumbDown,
                              text: AppLocalizations.of(context)!.reported,
                              onTap: null, // Disable tap when blocked
                            ),
                          )
                        : (_currentUser?.isFavorite ?? false)
                            ? Opacity(
                                opacity: 0.3,
                                child: CustomContainer(
                                  img: AppImages.thumbDown,
                                  text: AppLocalizations.of(context)!.ignore,
                                  onTap: null,
                                ),
                              )
                            : CustomContainer(
                                img: AppImages.thumbDown,
                                text: (_currentUser?.isIgnore ?? false)
                                    ? AppLocalizations.of(context)!.ignored
                                    : AppLocalizations.of(context)!.ignore,
                                onTap: () {
                                  ignoreDialog(
                                      afterSuccess: () {
                                        setState(() {
                                          _currentUser = _currentUser?.copyWith(
                                            isIgnore:
                                                !(_currentUser?.isIgnore ??
                                                    false),
                                          );
                                        });
                                      },
                                      context: context,
                                      message: _currentUser?.isIgnore ?? false
                                          ? AppLocalizations.of(context)!
                                              .sureUnignoreQu
                                          : AppLocalizations.of(context)!
                                              .sureIgnoreQu,
                                      textButton:
                                          _currentUser?.isIgnore ?? false
                                              ? AppLocalizations.of(context)!
                                                  .unignoreButton
                                              : AppLocalizations.of(context)!
                                                  .yesIgnore,
                                      userId: widget.userId);
                                },
                              ),
                  ),
                  (_currentUser?.isBlocked ?? false)
                      ? Opacity(
                          opacity: 0.3,
                          child: CustomContainer(
                            img: AppImages.message,
                            text: AppLocalizations.of(context)!.chats,
                            onTap: null,
                          ),
                        )
                      : (_currentUser?.isIgnore ?? false)
                          ? Opacity(
                              opacity: 0.3,
                              child: CustomContainer(
                                img: AppImages.message,
                                text: AppLocalizations.of(context)!.chats,
                                onTap: () {
                                  ignoreDialog(
                                      afterSuccess: () {
                                        setState(() {
                                          _currentUser = _currentUser?.copyWith(
                                            isIgnore:
                                                !(_currentUser?.isIgnore ??
                                                    false),
                                          );
                                        });
                                      },
                                      context: context,
                                      message: AppLocalizations.of(context)!
                                          .messageUnignoreQu,
                                      textButton: AppLocalizations.of(context)!
                                          .unignoreButton,
                                      userId: widget.userId);
                                },
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                try {
                                  // Check if there's an existing chat room first
                                  final chatListCubit =
                                      context.read<ChatListCubit>();

                                  // Check if chat list is already loaded, if not, load it silently

                                  // Check if chat list is already loaded, if not, load it
                                  if (chatListCubit.state is! ChatListLoaded) {
                                    await chatListCubit.forceRefreshChatList();

                                    // Wait a bit for the state to update
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                  } else {}

                                  // Find existing chat room between current user and this profile user
                                  final existingChatRoom = chatListCubit
                                      .findExistingChatRoom(widget.userId);

                                  if (existingChatRoom != null) {
                                    // Navigate to existing chat room
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.chatConversationScreen,
                                        arguments: {
                                          "chatRoom": existingChatRoom,
                                        },
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      // Get user data from the current state if available
                                      final cubit =
                                          context.read<ProfileDetailsCubit>();
                                      final state = cubit.state;

                                      String userName = 'User';
                                      String userImage = '';

                                      if (state is GetProfileDetailsSuccess) {
                                        final userData = state
                                            .profileDetailsResponseModel.data;
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
                                  }
                                } catch (e) {
                                  // Fallback to creating new chat
                                  if (context.mounted) {
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
                                }
                              },
                              child: CustomContainer(
                                img: AppImages.message,
                                text: AppLocalizations.of(context)!.chats,
                              ),
                            ),
                  BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
                    listenWhen: (context, current) =>
                        current is ReportUserLoading ||
                        current is ReportUserFailure ||
                        current is ReportUserSuccess,
                    listener: (context, state) {},
                    child: CustomContainer(
                      img: AppImages.block,
                      text: (_currentUser?.isBlocked ?? false)
                          ? AppLocalizations.of(context)!.reported
                          : AppLocalizations.of(context)!.report,
                      onTap: () {
                        reportDialog(context: context, userId: widget.userId);
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
      ),
    );
  }

  // void _showShareSuccessDialog({
  //   required BuildContext context,
  //   required String message,
  //   String? shareUrl,
  // }) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => PopScope(
  //       canPop: false,
  //       onPopInvokedWithResult: (didPop, result) {
  //         if (!didPop) {
  //           Navigator.pop(context, true);
  //         }
  //       },
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //         child: Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           backgroundColor: Colors.transparent,
  //           child: Container(
  //             width: 370,
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //             decoration: ShapeDecoration(
  //               color: AppColors.white,
  //               shape: RoundedRectangleBorder(
  //                 side: BorderSide(color: Colors.transparent),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               textDirection: LocalizationService.instance.textDirection,
  //               children: [
  //                 // Success icon
  //                 Container(
  //                   width: 80,
  //                   height: 80,
  //                   decoration: BoxDecoration(
  //                     color: Colors.green.withValues(alpha: 0.1),
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.check_circle,
  //                     color: Colors.green,
  //                     size: 50,
  //                   ),
  //                 ),
  //                 verticalSpace(20),
  //
  //                 // Success message
  //                 Text(
  //                   message,
  //                   textAlign: TextAlign.center,
  //                   textDirection: LocalizationService.instance.textDirection,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 verticalSpace(20),
  //
  //                 // Share URL display (if available)
  //                 if (shareUrl != null && shareUrl.isNotEmpty) ...[
  //                   GestureDetector(
  //                     onTap: () async {
  //                       try {
  //                         await Clipboard.setData(
  //                             ClipboardData(text: shareUrl));
  //                         if (context.mounted) {
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               content: Text(
  //                                 AppLocalizations.of(context)!.linkedCopied,
  //                                 textDirection: LocalizationService
  //                                     .instance.textDirection,
  //                                 textAlign: LocalizationService
  //                                     .instance.textAlignment,
  //                               ),
  //                               backgroundColor: Colors.green,
  //                               duration: Duration(seconds: 2),
  //                             ),
  //                           );
  //                         }
  //                       } catch (e) {
  //                         if (context.mounted) {
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               content: Text(
  //                                 '${AppLocalizations.of(context)!.errorCopyLink} : $e',
  //                                 textDirection: LocalizationService
  //                                     .instance.textDirection,
  //                                 textAlign: LocalizationService
  //                                     .instance.textAlignment,
  //                               ),
  //                               backgroundColor: Colors.red,
  //                             ),
  //                           );
  //                         }
  //                       }
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       textDirection:
  //                           LocalizationService.instance.textDirection,
  //                       children: [
  //                         const Icon(
  //                           Icons.link,
  //                           color: Colors.blue,
  //                           size: 24,
  //                         ),
  //                         const SizedBox(width: 8),
  //                         Text(
  //                           AppLocalizations.of(context)!.copySharingLink,
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.black87,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   verticalSpace(20),
  //                 ],
  //
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: CustomElevatedButton(
  //                     onPressed: () {
  //                       context.pop();
  //                     },
  //                     textButton: AppLocalizations.of(context)!.continueButton,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
