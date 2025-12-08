import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/features/members/Health_statuses/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../profile/widgets/profile_header.dart';

class HealthStatusesView extends StatefulWidget {
  const HealthStatusesView({super.key});

  @override
  State<HealthStatusesView> createState() => _HealthStatusesViewState();
}

class _HealthStatusesViewState extends State<HealthStatusesView> {
  int? _selectedHealthId;
  String _selectedHealthName = '';
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

  void _onFilterChanged(Map<String, dynamic> filterData, BuildContext context) {
    setState(() {
      final healthData = filterData['health'] as Map<String, dynamic>?;
      final countryData = filterData['country'] as Map<String, dynamic>?;

      _selectedHealthId = healthData?['id'];
      _selectedHealthName = healthData?['name'] ?? '';
      _selectedCountryId = countryData?['id'];
      _selectedCountryName = countryData?['name'] ?? '';

      // Clear filters if "all" is selected
      if (healthData?['name'] == 'all') {
        _selectedHealthId = null;
        _selectedHealthName = '';
      }
      if (countryData?['name'] == 'all') {
        _selectedCountryId = null;
        _selectedCountryName = '';
      }
    });

    // Refresh data with new filters using a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MembersListCubit<UsersDataModel>>().fetch(page: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.cosmicLatte, AppColors.antiqueWhite],
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
                  create: (_) =>
                      MembersListCubit<UsersDataModel>(({int? page}) async {
                        final response = await sl<MembersRepository>()
                            .getHealthConditionMembers(
                              healthConditionId: _selectedHealthId,
                              countryId: _selectedCountryId,
                              page: page,
                            );
                        return response;
                      })..fetch(),
                  child: Builder(
                    builder: (context) {
                      // Initialize scroll controller here where context is available
                      _scrollController ??= ScrollController()
                        ..addListener(() => _onScroll(context));

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: ProfileHeader(
                              title: AppLocalizations.of(
                                context,
                              )!.healthStatuses,
                              titleStyle: AppTextStyles.font20WhiteBoldLamaSans
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.conditions,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    final result =
                                        await showModalBottomSheet<
                                          Map<String, dynamic>
                                        >(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              const FilterHealthStatues(),
                                        );
                                    if (result != null && context.mounted) {
                                      _onFilterChanged(result, context);
                                    }
                                  },
                                  child: Row(
                                    textDirection: LocalizationService
                                        .instance
                                        .textDirection,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.filter,
                                        style: TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedHealthName.isNotEmpty &&
                                  _selectedHealthName != 'all' ||
                              _selectedCountryName.isNotEmpty &&
                                  _selectedCountryName != 'all')
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_selectedHealthName.isNotEmpty &&
                                      _selectedHealthName != 'all')
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.health_and_safety,
                                            color: Color(0xFFD4AF37),
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.filteredByHealthStatus(
                                              _selectedHealthName,
                                            ),
                                            style: TextStyle(
                                              color: Color(0xFFD4AF37),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (_selectedCountryName.isNotEmpty &&
                                      _selectedCountryName != 'all')
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xFFD4AF37),
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.filteredByCountry(
                                            _selectedCountryName,
                                          ),
                                          style: TextStyle(
                                            color: Color(0xFFD4AF37),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedHealthId = null;
                                            _selectedHealthName = '';
                                            _selectedCountryId = null;
                                            _selectedCountryName = '';
                                          });
                                          // Refresh data after clearing filters
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (mounted) {
                                                  context
                                                      .read<
                                                        MembersListCubit<
                                                          UsersDataModel
                                                        >
                                                      >()
                                                      .fetch(page: 1);
                                                }
                                              });
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.clearFilter,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          BlocBuilder<
                            MembersListCubit<UsersDataModel>,
                            MembersListState<UsersDataModel>
                          >(
                            builder: (context, state) {
                              if (state is MembersListLoading<UsersDataModel>) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.beer,
                                    ),
                                  ),
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
                                      AppLocalizations.of(
                                        context,
                                      )!.noHealthStatuses,
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
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.healthStatusesCount(items.length),
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
                                                    UsersDataModel
                                                  >
                                                >()
                                                .fetch(page: 1);
                                          },
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            itemCount:
                                                items.length +
                                                (_isLoadingMore ? 1 : 0),
                                            itemBuilder: (context, index) {
                                              if (index == items.length &&
                                                  _isLoadingMore) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    16.0,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.loadingMore,
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

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                child: ContainerItem(
                                                  favUser: items[index],
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
