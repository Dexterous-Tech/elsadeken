import 'dart:developer';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/members_profile/presentation/manager/members_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MembersProfileCountry extends StatefulWidget {
  const MembersProfileCountry({super.key});

  @override
  State<MembersProfileCountry> createState() => _MembersProfileCountryState();
}

class _MembersProfileCountryState extends State<MembersProfileCountry> {
  String selectedCountry = '';
  int selectedCountryId = 0;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load countries when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpListsCubit>().getCountries();
    });
  }

  void _loadMembersForCountry(int countryId, String countryName) {
    log('Loading members for country: $countryName (ID: $countryId)');
    setState(() {
      selectedCountry = countryName;
      selectedCountryId = countryId;
    });

    // Load members profile for selected country
    context.read<MembersProfileCubit>().getMembersProfile(
          countryId: countryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الدولة',
            style: AppTextStyles.font20LightOrangeMediumLamaSans.copyWith(
              color: Color(0xff2D2D2D),
            ),
          ),
          BlocListener<MembersProfileCubit, MembersProfileState>(
            listener: (context, state) {
              log('Country widget: MembersProfileCubit state changed to ${state.runtimeType}');
            },
            child: BlocBuilder<SignUpListsCubit, SignUpListsState>(
              builder: (context, state) {
                if (state is CountriesSuccess && !isInitialized) {
                  // Set default country to first one in the list
                  if (state.countriesList.isNotEmpty) {
                    final firstCountry = state.countriesList.first;
                    log('Setting default country: ${firstCountry.name} (ID: ${firstCountry.id})');

                    // Load members for the default country
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _loadMembersForCountry(
                        firstCountry.id ?? 1,
                        firstCountry.name ?? '',
                      );
                      isInitialized = true;
                    });
                  }
                }

                return GestureDetector(
                  onTap: () {
                    if (state is CountriesSuccess) {
                      _showCountryDialog(context, state.countriesList);
                    }
                  },
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        selectedCountry.isNotEmpty
                            ? selectedCountry
                            : 'اختر الدولة',
                        style: AppTextStyles.font18GreyRegularLamaSans.copyWith(
                            color: AppColors.darkSunray,
                            fontFamily: FontFamilyHelper.plexSansArabic),
                      ),
                      horizontalSpace(8),
                      Image.asset(
                        AppImages.bottomArrowProfile,
                        width: 18.w,
                        height: 18.h,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryDialog(BuildContext context, List<dynamic> countries) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'اختر الدولة',
            textAlign: TextAlign.center,
            style: AppTextStyles.font18GreyRegularLamaSans.copyWith(
                color: AppColors.darkSunray,
                fontWeight: FontWeightHelper.semiBold),
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return ListTile(
                  title: Text(
                    country.name ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16BlackSemiBoldLamaSans,
                  ),
                  onTap: () {
                    log('Country selected: ${country.name} (ID: ${country.id})');
                    _loadMembersForCountry(
                      country.id ?? 1,
                      country.name ?? '',
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
