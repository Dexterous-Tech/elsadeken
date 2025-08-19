import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card_item.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
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
          textDirection: TextDirection.rtl,
          children: [
            ProfileDetailsCard(
              cardTitle: 'تاريخ السجل',
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileDetailsCardItem(
                    itemTitle: 'مسجل منذ',
                    itemSubTitle: _getRegisteredSince(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'تاريخ اخر زياره',
                    itemSubTitle: _getLastVisit(state),
                    loading: isLoading,
                  ),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(27),
            ProfileDetailsCard(
              cardTitle: 'المعلومات',
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileDetailsCardItem(
                    itemTitle: 'الجنسيه',
                    itemSubTitle: _getCountry(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الاقامه',
                    itemSubTitle: _getResidence(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'المدينه',
                    itemSubTitle: _getCity(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'نوع الزواج',
                    itemSubTitle: _getMarriageType(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الحاله الاجتماعيه',
                    itemSubTitle: _getMaritalStatus(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'عدد الاطفال',
                    itemSubTitle: _getChildren(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'لون البشره',
                    itemSubTitle: _getSkinColor(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الطول',
                    itemSubTitle: _getHeight(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الوزن',
                    itemSubTitle: _getWeight(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'المؤهل التعليمي',
                    itemSubTitle: _getEducation(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الوضع المادي',
                    itemSubTitle: _getFinancialStatus(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الدخل الشهري',
                    itemSubTitle: _getIncome(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الحالة الصحية',
                    itemSubTitle: _getHealthStatus(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'التدخين',
                    itemSubTitle: _getSmoking(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الإتزام الديني',
                    itemSubTitle: _getReligiousCommitment(state),
                    loading: isLoading,
                  ),
                  ProfileDetailsCardItem(
                    itemTitle: 'الحجاب',
                    itemSubTitle: _getHijab(state),
                    loading: isLoading,
                  ),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: 'موصفات زوجي المستقبلي',
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  _getLifePartner(state),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font18GreyRegularLamaSans
                      .copyWith(fontFamily: FontFamilyHelper.plexSansArabic),
                ),
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: 'موصفاتي انا',
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  _getAboutMe(state),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
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
  String _getRegisteredSince(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final createdAt = state.profileDetailsResponseModel.data?.createdAt;
      if (createdAt == null) return 'لا يوجد';

      try {
        // Parse the createdAt date
        final createdDate = DateTime.parse(createdAt);
        final now = DateTime.now();
        final difference = now.difference(createdDate);
        final days = difference.inDays;

        if (days == 0) {
          return 'منذ اليوم';
        } else if (days == 1) {
          return 'منذ يوم واحد';
        } else if (days < 7) {
          return 'منذ $days أيام';
        } else if (days < 30) {
          final weeks = (days / 7).floor();
          if (weeks == 1) {
            return 'منذ أسبوع واحد';
          } else {
            return 'منذ $weeks أسابيع';
          }
        } else if (days < 365) {
          final months = (days / 30).floor();
          if (months == 1) {
            return 'منذ شهر واحد';
          } else {
            return 'منذ $months أشهر';
          }
        } else {
          final years = (days / 365).floor();
          if (years == 1) {
            return 'منذ سنة واحدة';
          } else {
            return 'منذ $years سنوات';
          }
        }
      } catch (e) {
        return 'لا يوجد';
      }
    }
    return 'لا يوجد';
  }

  String _getLastVisit(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      // You might need to add last visit field to your model
      return 'متواجد حاليا';
    }
    return 'لا يوجد';
  }

  String _getCountry(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final country =
          state.profileDetailsResponseModel.data?.attribute?.country;
      return country ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getResidence(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final country =
          state.profileDetailsResponseModel.data?.attribute?.country;
      return country ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getCity(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final city = state.profileDetailsResponseModel.data?.attribute?.city;
      return city ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getMarriageType(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final marriageType =
          state.profileDetailsResponseModel.data?.attribute?.typeOfMarriage;
      return marriageType ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getMaritalStatus(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final maritalStatus =
          state.profileDetailsResponseModel.data?.attribute?.maritalStatus;
      return maritalStatus ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getChildren(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final children =
          state.profileDetailsResponseModel.data?.attribute?.children;
      if (children == null || children == 0) return '0';
      return children.toString();
    }
    return 'لا يوجد';
  }

  String _getSkinColor(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final skinColor =
          state.profileDetailsResponseModel.data?.attribute?.skinColor;
      return skinColor ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getHeight(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final height = state.profileDetailsResponseModel.data?.attribute?.height;
      if (height == null) return 'لا يوجد';
      return '$height سنتي';
    }
    return 'لا يوجد';
  }

  String _getWeight(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final weight = state.profileDetailsResponseModel.data?.attribute?.weight;
      if (weight == null) return 'لا يوجد';
      return '$weight كيلو';
    }
    return 'لا يوجد';
  }

  String _getEducation(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final qualification =
          state.profileDetailsResponseModel.data?.attribute?.qualification;
      return qualification ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getFinancialStatus(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final financialSituation =
          state.profileDetailsResponseModel.data?.attribute?.financialSituation;
      return financialSituation ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getIncome(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final income = state.profileDetailsResponseModel.data?.attribute?.income;
      if (income == null) return 'لا يوجد';
      return '$income جنية';
    }
    return 'لا يوجد';
  }

  String _getHealthStatus(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final healthCondition =
          state.profileDetailsResponseModel.data?.attribute?.healthCondition;
      return healthCondition ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getSmoking(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final smoking =
          state.profileDetailsResponseModel.data?.attribute?.smoking;
      return smoking ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getReligiousCommitment(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final religiousCommitment = state
          .profileDetailsResponseModel.data?.attribute?.religiousCommitment;
      return religiousCommitment ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getHijab(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final hijab = state.profileDetailsResponseModel.data?.attribute?.hijab;
      return hijab ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getLifePartner(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final lifePartner =
          state.profileDetailsResponseModel.data?.attribute?.lifePartner;
      return lifePartner ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }

  String _getAboutMe(ProfileDetailsState state) {
    if (state is GetProfileDetailsLoading) return 'جاري التحميل...';
    if (state is GetProfileDetailsSuccess) {
      final aboutMe =
          state.profileDetailsResponseModel.data?.attribute?.aboutMe;
      return aboutMe ?? 'لا يوجد';
    }
    return 'لا يوجد';
  }
}
