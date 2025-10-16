import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/home/person_details/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/core/services/localization_service.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../chat/data/models/chat_room_model.dart';
import '../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import '../../../../chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';
import '../../../../profile/profile_details/presentation/manager/profile_details_cubit.dart';

class PersonInfoSheet extends StatefulWidget {
  final PersonModel person;

  const PersonInfoSheet({super.key, required this.person});

  @override
  State<PersonInfoSheet> createState() => _PersonInfoSheetState();
}

class _PersonInfoSheetState extends State<PersonInfoSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  late PersonModel _currentPerson;

  @override
  void initState() {
    super.initState();
    _currentPerson = widget.person;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handle favorite button press
  void _handleFavoritePress() {
    print('Favorite button pressed for user: ${_currentPerson.name}');

    // Call the likeUser method from ProfileDetailsCubit
    context.read<ProfileDetailsCubit>().likeUser(_currentPerson.id);
  }

  /// Format the createdAt date string to a readable format
  String _getRegisteredSince(String createdAt) {
    if (createdAt.isEmpty) return AppLocalizations.of(context)!.notAvailable;

    try {
      // Parse the createdAt date
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(createdDate);
      final days = difference.inDays;

      if (days == 0) {
        return AppLocalizations.of(context)!.sinceToday;
      } else if (days == 1) {
        return AppLocalizations.of(context)!.oneDayAgo;
      } else if (days < 7) {
        return AppLocalizations.of(context)!.daysAgo(days.toString());
      } else if (days < 30) {
        final weeks = (days / 7).floor();
        if (weeks == 1) {
          return AppLocalizations.of(context)!.oneWeekAgo;
        } else {
          return AppLocalizations.of(context)!.weeksAgo(weeks.toString());
        }
      } else if (days < 365) {
        final months = (days / 30).floor();
        if (months == 1) {
          return AppLocalizations.of(context)!.oneMonthAgo;
        } else {
          return AppLocalizations.of(context)!.monthsAgo(months.toString());
        }
      } else {
        final years = (days / 365).floor();
        if (years == 1) {
          return AppLocalizations.of(context)!.oneYearAgo;
        } else {
          return AppLocalizations.of(context)!.yearsAgo(years.toString());
        }
      }
    } catch (e) {
      return AppLocalizations.of(context)!.notAvailable;
    }
  }

  /// Format the lastSeen date string to a readable format
  String _getLastVisit(String? lastSeen) {
    if (lastSeen == null || lastSeen.isEmpty) {
      return AppLocalizations.of(context)!.currentlyOnline;
    }

    try {
      // Parse the lastSeen date
      final lastSeenDate = DateTime.parse(lastSeen);
      final now = DateTime.now();
      final difference = now.difference(lastSeenDate);
      final minutes = difference.inMinutes;
      final hours = difference.inHours;
      final days = difference.inDays;

      // If last seen is within 5 minutes, show "currently online"
      if (minutes < 5) {
        return AppLocalizations.of(context)!.currentlyOnline;
      } else if (minutes < 60) {
        return AppLocalizations.of(context)!.minutesAgo(minutes.toString());
      } else if (hours < 24) {
        if (hours == 1) {
          return AppLocalizations.of(context)!.oneHourAgo;
        } else {
          return AppLocalizations.of(context)!.hoursAgo(hours.toString());
        }
      } else if (days < 7) {
        if (days == 1) {
          return AppLocalizations.of(context)!.oneDayAgo;
        } else {
          return AppLocalizations.of(context)!.daysAgo(days.toString());
        }
      } else if (days < 30) {
        final weeks = (days / 7).floor();
        if (weeks == 1) {
          return AppLocalizations.of(context)!.oneWeekAgo;
        } else {
          return AppLocalizations.of(context)!.weeksAgo(weeks.toString());
        }
      } else if (days < 365) {
        final months = (days / 30).floor();
        if (months == 1) {
          return AppLocalizations.of(context)!.oneMonthAgo;
        } else {
          return AppLocalizations.of(context)!.monthsAgo(months.toString());
        }
      } else {
        final years = (days / 365).floor();
        if (years == 1) {
          return AppLocalizations.of(context)!.oneYearAgo;
        } else {
          return AppLocalizations.of(context)!.yearsAgo(years.toString());
        }
      }
    } catch (e) {
      return AppLocalizations.of(context)!.notAvailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDetailsCubit, ProfileDetailsState>(
      listener: (context, state) {
        if (state is LikeUserSuccess) {
          // Update the person's favorite status
          setState(() {
            _currentPerson = _currentPerson.copyWith(
              isFavorite: !_currentPerson.isFavorite,
            );
          });

          // Show success message from response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.profileDetailsActionResponseModel.message ??
                  (_currentPerson.isFavorite
                      ? AppLocalizations.of(context)!
                          .addedToFavorites(_currentPerson.name)
                      : AppLocalizations.of(context)!.removeFromFavorites)),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is LikeUserFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.5, 0.6, 0.95],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.cosmicLatte,
                  AppColors.antiqueWhite,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: LocalizationService.instance.textDirection,
              children: [
                _buildDragHandle(),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildPersonHeader(),
                      const SizedBox(height: 20),
                      _buildAboutSection(),
                      const SizedBox(height: 30),
                      _buildLogTable(),
                      const SizedBox(height: 30),
                      _buildDataTable(),
                      const SizedBox(height: 30),
                      Center(child: _buildActionButtons()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final isExpanded = _controller.size > 0.7;
        _controller.animateTo(
          isExpanded ? 0.4 : 0.95,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Center(
        child: Container(
          width: 60.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonHeader() {
    final p = _currentPerson;
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: LocalizationService.instance.textDirection,
            children: [
              Text(
                p.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${p.attribute.country}, ${p.attribute.city}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                textDirection: LocalizationService.instance.textDirection,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _handleFavoritePress(),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: p.isFavorite ? Colors.red : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              p.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: p.isFavorite ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    final p = _currentPerson;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.aboutPerson,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: LocalizationService.instance.textDirection,
        ),
        verticalSpace(8),
        Text(
          p.attribute.aboutMe,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        verticalSpace(16),
        Text(
          AppLocalizations.of(context)!.lifePartner,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: LocalizationService.instance.textDirection,
        ),
        verticalSpace(8),
        Text(
          p.attribute.lifePartner,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLogTable() {
    final p = _currentPerson;
    final data = [
      {
        'label': AppLocalizations.of(context)!.registeredSince,
        'value': _getRegisteredSince(p.createdAt)
      },
      {
        'label': AppLocalizations.of(context)!.lastVisitDate,
        'value': _getLastVisit(p.lastSeen)
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius: BorderRadius.circular(2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 15),
              child: Text(
                AppLocalizations.of(context)!.historyRecord,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: LocalizationService.instance.textDirection,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    textDirection: LocalizationService.instance.textDirection,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 150.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lighterOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['value']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 46, 34, 30),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final p = _currentPerson;
    final data = [
      {
        'label': AppLocalizations.of(context)!.nationality,
        'value': p.attribute.nationality
      },
      {
        'label': AppLocalizations.of(context)!.residence,
        'value': p.attribute.city
      },
      {'label': AppLocalizations.of(context)!.city, 'value': p.attribute.city},
      {
        'label': AppLocalizations.of(context)!.typeOfMarriage,
        'value': p.attribute.typeOfMarriage
      },
      {
        'label': AppLocalizations.of(context)!.maritalStatus,
        'value': p.attribute.maritalStatus
      },
      {
        'label': AppLocalizations.of(context)!.numberOfChildren,
        'value': p.attribute.children.toString()
      },
      {
        'label': AppLocalizations.of(context)!.skinColor,
        'value': p.attribute.skinColor
      },
      {
        'label': AppLocalizations.of(context)!.height,
        'value': "${p.attribute.height} ${AppLocalizations.of(context)!.cm}"
      },
      {
        'label': AppLocalizations.of(context)!.weight,
        'value': "${p.attribute.weight} ${AppLocalizations.of(context)!.kg}"
      },
      {
        'label': AppLocalizations.of(context)!.educationalQualification,
        'value': p.attribute.qualification
      },
      {
        'label': AppLocalizations.of(context)!.financialStatusTitle,
        'value': p.attribute.financialSituation
      },
      {
        'label': AppLocalizations.of(context)!.monthlyIncome,
        'value': p.attribute.income
      },
      {
        'label': AppLocalizations.of(context)!.healthStatus,
        'value': p.attribute.healthCondition
      },
      {
        'label': AppLocalizations.of(context)!.smoking,
        'value': p.attribute.smoking
      },
      {
        'label': AppLocalizations.of(context)!.religiousCommitment,
        'value': p.attribute.religiousCommitment
      },
      {
        'label': p.gender == 'male' || p.gender == 'ذكر'
            ? AppLocalizations.of(context)!.beard
            : AppLocalizations.of(context)!.hijab,
        'value': p.gender == 'male' || p.gender == 'ذكر'
            ? p.attribute.beard
            : p.attribute.hijab,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.information,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textDirection: LocalizationService.instance.textDirection,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              textDirection: LocalizationService.instance.textDirection,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    textDirection: LocalizationService.instance.textDirection,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 150.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.lighterOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['value']!.isEmpty
                              ? AppLocalizations.of(context)!.noData
                              : item['value']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 46, 34, 30),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, 'rejected');
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
        horizontalSpace(21),
        GestureDetector(
          onTap: () async {
            try {
              print(
                  '🔍 [PersonInfo] Message icon tapped for user ID: ${_currentPerson.id}');

              // Check if there's an existing chat room first
              final chatListCubit = context.read<ChatListCubit>();

              // Check if chat list is already loaded, if not, load it
              if (chatListCubit.state is! ChatListLoaded) {
                print('🔄 [PersonInfo] Chat list not loaded, loading now...');
                await chatListCubit.forceRefreshChatList();

                // Wait a bit for the state to update
                await Future.delayed(const Duration(milliseconds: 500));
              } else {
                print('✅ [PersonInfo] Chat list already loaded');
              }

              // Find existing chat room between current user and this profile user
              final existingChatRoom =
                  chatListCubit.findExistingChatRoom(_currentPerson.id);

              if (existingChatRoom != null) {
                print(
                    '✅ [PersonInfo] Found existing chat room: ${existingChatRoom.id}, navigating to it');
                // Navigate to existing chat room
                if (mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatConversationScreen,
                    arguments: {
                      "chatRoom": existingChatRoom,
                    },
                  );
                }
              } else {
                print(
                    '🆕 [PersonInfo] No existing chat room found, creating new temporary chat');
                // Create new temporary chat room for new conversation
                if (mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatConversationScreen,
                    arguments: {
                      "chatRoom": ChatRoomModel.fromUser(
                        userId: _currentPerson.id,
                        userName: _currentPerson.name,
                        userImage: _currentPerson.image,
                      ),
                    },
                  );
                }
              }
            } catch (e) {
              print('❌ [PersonInfo] Error in message icon onTap: $e');
              // Fallback to creating new chat
              if (mounted) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatConversationScreen,
                  arguments: {
                    "chatRoom": ChatRoomModel.fromUser(
                      userId: _currentPerson.id,
                      userName: _currentPerson.name,
                      userImage: _currentPerson.image,
                    ),
                  },
                );
              }
            }
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/home_outline_message.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 16)
      ],
    );
  }
}
