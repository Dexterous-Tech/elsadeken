import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card_item.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsData extends StatelessWidget {
  const ProfileDetailsData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
      buildWhen: (context, state) =>
          state is GetProfileDetailsLoading ||
          state is GetProfileDetailsSuccess ||
          state is GetProfileDetailsFailure,
      builder: (context, state) {
        final bool isLoading = state is GetProfileDetailsLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: LocalizationService.instance.textDirection,
          children: [
            ProfileDetailsCard(
              cardTitle: AppLocalizations.of(context)!.recordHistory,
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.registeredSince,
                    itemSubTitle: _getRegisteredSince(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.lastVisitDate,
                    itemSubTitle: _getLastVisit(state, context),
                    loading: isLoading,
                  ),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(27),
            ProfileDetailsCard(
              cardTitle: AppLocalizations.of(context)!.information,
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.nationality,
                    itemSubTitle: _getCountry(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.residence,
                    itemSubTitle: _getResidence(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.city,
                    itemSubTitle: _getCity(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.marriageType,
                    itemSubTitle: _getMarriageType(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.maritalStatus,
                    itemSubTitle: _getMaritalStatus(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.numberOfChildren,
                    itemSubTitle: _getChildren(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.skinColor,
                    itemSubTitle: _getSkinColor(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.height,
                    itemSubTitle: _getHeight(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.weight,
                    itemSubTitle: _getWeight(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.educationalQualification,
                    itemSubTitle: _getEducation(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.financialStatus,
                    itemSubTitle: _getFinancialStatus(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.monthlyIncome,
                    itemSubTitle: _getIncome(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.healthStatus,
                    itemSubTitle: _getHealthStatus(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.smoking,
                    itemSubTitle: _getSmoking(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.religiousCommitment,
                    itemSubTitle: _getReligiousCommitment(state, context),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: AppLocalizations.of(context)!.hijab,
                    itemSubTitle: _getHijab(state, context),
                    loading: isLoading,
                  ),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: AppLocalizations.of(context)!.futureSpouseDescription,
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  _getLifePartner(state, context),
                  textDirection: LocalizationService.instance.textDirection,
                  textAlign: LocalizationService.instance.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                  style: AppTextStyles.font18GreyRegularLamaSans
                      .copyWith(fontFamily: FontFamilyHelper.plexSansArabic),
                ),
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: AppLocalizations.of(context)!.myDescription,
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  _getAboutMe(state, context),
                  textDirection: LocalizationService.instance.textDirection,
                  textAlign: LocalizationService.instance.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                  style: AppTextStyles.font18GreyRegularLamaSans
                      .copyWith(fontFamily: FontFamilyHelper.plexSansArabic),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper methods to extract data from state
  String _getRegisteredSince(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final createdAt = state.profileDetailsResponseModel.data?.createdAt;
      if (createdAt == null) return AppLocalizations.of(context)!.notAvailable;

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
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getLastVisit(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final lastSeen = state.profileDetailsResponseModel.data?.lastSeen;
      if (lastSeen == null) return AppLocalizations.of(context)!.notAvailable;

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
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getCountry(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final country =
          state.profileDetailsResponseModel.data?.attribute?.country;
      return country ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getResidence(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final country =
          state.profileDetailsResponseModel.data?.attribute?.country;
      return country ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getCity(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final city = state.profileDetailsResponseModel.data?.attribute?.city;
      return city ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getMarriageType(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final marriageType =
          state.profileDetailsResponseModel.data?.attribute?.typeOfMarriage;
      return marriageType ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getMaritalStatus(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final maritalStatus =
          state.profileDetailsResponseModel.data?.attribute?.maritalStatus;
      return maritalStatus ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getChildren(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final children =
          state.profileDetailsResponseModel.data?.attribute?.children;
      if (children == null || children == 0) return '0';
      return children.toString();
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getSkinColor(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final skinColor =
          state.profileDetailsResponseModel.data?.attribute?.skinColor;
      return skinColor ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getHeight(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final height = state.profileDetailsResponseModel.data?.attribute?.height;
      if (height == null) return AppLocalizations.of(context)!.notAvailable;
      return '$height ${AppLocalizations.of(context)!.centimeters}';
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getWeight(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final weight = state.profileDetailsResponseModel.data?.attribute?.weight;
      if (weight == null) return AppLocalizations.of(context)!.notAvailable;
      return '$weight ${AppLocalizations.of(context)!.kilograms}';
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getEducation(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final qualification =
          state.profileDetailsResponseModel.data?.attribute?.qualification;
      return qualification ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getFinancialStatus(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final financialSituation =
          state.profileDetailsResponseModel.data?.attribute?.financialSituation;
      return financialSituation ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getIncome(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final income = state.profileDetailsResponseModel.data?.attribute?.income;
      if (income == null) return AppLocalizations.of(context)!.notAvailable;
      return '$income';
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getHealthStatus(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final healthCondition =
          state.profileDetailsResponseModel.data?.attribute?.healthCondition;
      return healthCondition ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getSmoking(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final smoking =
          state.profileDetailsResponseModel.data?.attribute?.smoking;
      return smoking ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getReligiousCommitment(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final religiousCommitment = state
          .profileDetailsResponseModel.data?.attribute?.religiousCommitment;
      return religiousCommitment ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getHijab(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final hijab = state.profileDetailsResponseModel.data?.attribute?.hijab;
      return hijab ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getLifePartner(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final lifePartner =
          state.profileDetailsResponseModel.data?.attribute?.lifePartner;
      return lifePartner ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }

  String _getAboutMe(ProfileDetailsState state, BuildContext context) {
    if (state is GetProfileDetailsLoading) return AppLocalizations.of(context)!.loading;
    if (state is GetProfileDetailsSuccess) {
      final aboutMe =
          state.profileDetailsResponseModel.data?.attribute?.aboutMe;
      return aboutMe ?? AppLocalizations.of(context)!.notAvailable;
    }
    return AppLocalizations.of(context)!.notAvailable;
  }
}
