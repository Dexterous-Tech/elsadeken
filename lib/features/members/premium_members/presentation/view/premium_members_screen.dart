import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../profile/widgets/profile_header.dart';
import '../../../online_members/presentation/view/widgets/filter_buttom_sheet.dart';

class PremiumMembersView extends StatefulWidget {
  const PremiumMembersView({super.key, this.countryName});

  final String? countryName;

  @override
  State<PremiumMembersView> createState() => _PremiumMembersViewState();
}

class _PremiumMembersViewState extends State<PremiumMembersView> {
  String? _selectedCountryName;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _selectedCountryName = widget.countryName;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreUsers() {
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreUsers();
    }
  }

  Future<void> _onRefresh() async {
    context.read<MembersListCubit<UsersDataModel>>().fetch(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(({int? page}) async {
      final response = await sl<MembersRepository>().getDistinguishedMembers(
        countryName: _selectedCountryName,
      );
      return response.data ?? [];
    })..fetch();

    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
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
                  create: (_) => cubit,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: ProfileHeader(
                          title: AppLocalizations.of(context)!.premiumMembers,
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
                              AppLocalizations.of(context)!.premiumMembers,
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
                                      builder: (context) => FilterBottomSheet(
                                        selectedCountryId:
                                            null, // We'll use country name instead
                                      ),
                                    );
                                if (result != null) {
                                  setState(() {
                                    _selectedCountryName =
                                        result['name'] as String?;
                                  });
                                  // Recreate cubit with country filter
                                  final newCubit =
                                      MembersListCubit<UsersDataModel>(({
                                        int? page,
                                      }) async {
                                        final response =
                                            await sl<MembersRepository>()
                                                .getDistinguishedMembers(
                                                  countryName:
                                                      _selectedCountryName,
                                                );
                                        return response.data ?? [];
                                      });
                                  // Push a new provider scope with updated loader
                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BlocProvider<
                                              MembersListCubit<UsersDataModel>
                                            >(
                                              create: (_) => newCubit..fetch(),
                                              child: PremiumMembersView(
                                                countryName:
                                                    _selectedCountryName,
                                              ),
                                            ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Row(
                                textDirection:
                                    LocalizationService.instance.textDirection,
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
                      SizedBox(height: 16),
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
                                  )!.noPremiumMembers,
                                  textAlign: TextAlign.center,
                                  textDirection: LocalizationService
                                      .instance
                                      .textDirection,
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
                                      )!.premiumMembersCount(items.length),
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
                                      onRefresh: _onRefresh,
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
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.loadingMore,
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          LocalizationService
                                                              .instance
                                                              .textDirection,
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
                                              bottom: 12,
                                            ),
                                            child: ContainerItem(
                                              favUser: m,
                                              isSpecial: true,
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
