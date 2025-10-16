import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/members/online_members/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../profile/widgets/profile_header.dart';

class OnlineMembersView extends StatefulWidget {
  const OnlineMembersView({super.key});

  @override
  State<OnlineMembersView> createState() => _OnlineMembersViewState();
}

class _OnlineMembersViewState extends State<OnlineMembersView> {
  int? _selectedCountryId;
  String _selectedCountryName = '';
  ScrollController? _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _loadMoreUsers(BuildContext context) {
    final cubit = context.read<MembersListCubit<UsersDataModel>>();
    final state = cubit.state;

    if (state is MembersListLoaded<UsersDataModel> &&
        state.hasNextPage &&
        !_isLoadingMore) {
      final nextPage = state.currentPage + 1;
      setState(() {
        _isLoadingMore = true;
      });
      cubit.fetch(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  void _onScroll(BuildContext context) {
    if (_scrollController?.position.pixels != null &&
        _scrollController!.position.pixels >=
            _scrollController!.position.maxScrollExtent - 200) {
      _loadMoreUsers(context);
    }
  }

  void _onCountryFilterChanged(Map<String, dynamic> filterData) {
    print('_onCountryFilterChanged called with: $filterData');
    setState(() {
      _selectedCountryId = filterData['id'];
      _selectedCountryName = filterData['name'] ?? '';
    });
    print(
        'Updated _selectedCountryId to: $_selectedCountryId, _selectedCountryName to: $_selectedCountryName');

    // If "all" is selected, clear the filters
    if (filterData['name'] == 'all') {
      _selectedCountryId = null;
      _selectedCountryName = '';
      print('Cleared filters because "all" was selected');
    }
  }

  // String _getLocationText(UsersDataModel member) {
  //   final country = member.attribute?.country;
  //   final city = member.attribute?.city;
  //
  //   // Helper function to check if a string is valid
  //   bool isValidString(String? str) {
  //     return str != null &&
  //         str.isNotEmpty &&
  //         str != 'لا يوجد' &&
  //         str != 'null' &&
  //         str != 'undefined' &&
  //         str.trim().isNotEmpty;
  //   }
  //
  //   final hasValidCountry = isValidString(country);
  //   final hasValidCity = isValidString(city);
  //
  //   if (!hasValidCountry && !hasValidCity) {
  //     return AppLocalizations.of(context)!.notSpecified;
  //   }
  //
  //   if (hasValidCountry && hasValidCity) {
  //     return '$country، $city';
  //   }
  //
  //   if (hasValidCountry) {
  //     return country!;
  //   }
  //
  //   return city!;
  // }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(
      ({int? page}) async {
        final response =
            await sl<MembersRepository>().getOnlineMembers(page: page);
        return response;
      },
    )..fetch();

    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.cosmicLatte,
                AppColors.antiqueWhite,
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: -20,
                child: Image.asset(
                  AppImages.starProfile,
                  width: 488.w,
                  height: 325.h,
                ),
              ),
              SafeArea(
                child: BlocProvider<MembersListCubit<UsersDataModel>>(
                  create: (_) => cubit,
                  child: Builder(
                    builder: (context) {
                      // Initialize scroll controller here where context is available
                      _scrollController ??= ScrollController()
                        ..addListener(() => _onScroll(context));

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: ProfileHeader(
                                title:
                                    AppLocalizations.of(context)!.onlineMembers,
                                titleStyle: AppTextStyles
                                    .font20WhiteBoldLamaSans
                                    .copyWith(color: AppColors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.all(24.0),
                            child: Row(
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.onlineMembers,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(width: 20),
                                Row(
                                  textDirection: LocalizationService
                                      .instance.textDirection,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final result =
                                            await showModalBottomSheet<
                                                Map<String, dynamic>>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            print(
                                                'Creating FilterBottomSheet with selectedCountryId: $_selectedCountryId, selectedCountryName: $_selectedCountryName');
                                            return BlocProvider(
                                              create: (context) =>
                                                  sl<SignUpListsCubit>(),
                                              child: FilterBottomSheet(
                                                selectedCountryId:
                                                    _selectedCountryId,
                                                selectedCountryName:
                                                    _selectedCountryName,
                                              ),
                                            );
                                          },
                                        );
                                        if (result != null) {
                                          _onCountryFilterChanged(result);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .filter,
                                            style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                fontSize: 18),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Color(0xFFD4AF37)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (_selectedCountryName.isNotEmpty &&
                              _selectedCountryName != 'all')
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Color(0xFFD4AF37), size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .filteredByCountry(
                                            _selectedCountryName),
                                    style: TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCountryId = null;
                                        _selectedCountryName = '';
                                      });
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.clearFilter,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 16),
                          BlocBuilder<MembersListCubit<UsersDataModel>,
                              MembersListState<UsersDataModel>>(
                            builder: (context, state) {
                              if (state is MembersListLoading<UsersDataModel>) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: AppColors.beer,
                                  )),
                                );
                              }
                              if (state is MembersListError<UsersDataModel>) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }
                              if (state is MembersListEmpty<UsersDataModel>) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .noResultsCurrently,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              if (state is MembersListLoaded<UsersDataModel>) {
                                final items = state.items;
                                return Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .onlineMembersCount(items.length),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFFD4AF37),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: RefreshIndicator(
                                          onRefresh: () async {
                                            context
                                                .read<
                                                    MembersListCubit<
                                                        UsersDataModel>>()
                                                .fetch(page: 1);
                                          },
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            itemCount: items.length +
                                                (_isLoadingMore ? 1 : 0),
                                            itemBuilder: (context, index) {
                                              if (index == items.length &&
                                                  _isLoadingMore) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .loadingMore,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              final m = items[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12),
                                                child: ContainerItem(
                                                  favUser: m,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
