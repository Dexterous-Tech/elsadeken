import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/members/online_members/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/app_images.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../gender_filter.dart';

class NewMembersView extends StatefulWidget {
  const NewMembersView({Key? key, this.countryId}) : super(key: key);

  final int? countryId;

  @override
  State<NewMembersView> createState() => _NewMembersViewState();
}

class _NewMembersViewState extends State<NewMembersView> {
  String _activeFilter = 'all'; // Will be localized in UI
  int? _selectedCountryId;
  List<UsersDataModel> _allMembers = [];
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
      print(
          'Loading more new members: current page ${state.currentPage}, next page $nextPage');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.fetch(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          print('Pagination loading completed');
        }
      });
    }
  }

  void _onScroll(BuildContext context) {
    if (_scrollController?.position.pixels != null &&
        _scrollController!.position.pixels >=
            _scrollController!.position.maxScrollExtent - 200) {
      print('Scroll threshold reached, triggering pagination');
      _loadMoreUsers(context);
    }
  }

  Future<void> _onRefresh() async {
    // We'll handle this in the build method where context is available
  }

  List<UsersDataModel> _getFilteredMembers(List<UsersDataModel> allMembers) {
    // Debug: Print unique gender values to help identify what the API returns
    final uniqueGenders = allMembers.map((m) => m.gender).toSet();
    print('🔍 New Members - Unique gender values from API: $uniqueGenders');

    switch (_activeFilter) {
      case 'males':
        return allMembers.where((member) {
          final gender = member.gender?.toLowerCase();
          // Handle both Arabic and English gender values
          return gender == 'ذكر' || gender == 'male' || gender == 'm';
        }).toList();
      case 'females':
        return allMembers.where((member) {
          final gender = member.gender?.toLowerCase();
          // Handle both Arabic and English gender values
          return gender == 'انثى' || gender == 'female' || gender == 'f';
        }).toList();
      default:
        return allMembers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(
      ({int? page}) async {
        final response = await sl<MembersRepository>()
            .getNewMembers(countryId: widget.countryId, page: page);
        return response;
      },
    )..fetch();

    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Stack(
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
                              title: AppLocalizations.of(context)!.newMembers,
                              titleStyle: AppTextStyles.font20WhiteBoldLamaSans
                                  .copyWith(color: AppColors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Align(
                            alignment:
                                LocalizationService.instance.endAlignment,
                            child: GestureDetector(
                              onTap: () async {
                                final result = await showModalBottomSheet<
                                    Map<String, dynamic>>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      const FilterBottomSheet(),
                                );
                                if (result != null) {
                                  setState(() {
                                    _selectedCountryId = result['id'] as int?;
                                  });
                                  // Recreate cubit with country filter
                                  final newCubit =
                                      MembersListCubit<UsersDataModel>(
                                    ({int? page}) async {
                                      final response =
                                          await sl<MembersRepository>()
                                              .getNewMembers(
                                                  countryId:
                                                      _selectedCountryId);
                                      return response.data ?? [];
                                    },
                                  );
                                  // Push a new provider scope with updated loader
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider<
                                          MembersListCubit<UsersDataModel>>(
                                        create: (_) => newCubit..fetch(),
                                        child: NewMembersView(
                                          countryId: _selectedCountryId,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                textDirection:
                                    LocalizationService.instance.textDirection,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.filter,
                                    style: TextStyle(
                                        color: Color(0xFFD4AF37), fontSize: 16),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Color(0xFFD4AF37)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 24.0),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F1E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GenderFilter(
                                    text: AppLocalizations.of(context)!.all,
                                    isActive: _activeFilter == 'all',
                                    onTap: () {
                                      setState(() => _activeFilter = 'all');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: GenderFilter(
                                    text: AppLocalizations.of(context)!.males,
                                    isActive: _activeFilter == 'males',
                                    onTap: () {
                                      setState(() => _activeFilter = 'males');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: GenderFilter(
                                    text: AppLocalizations.of(context)!.females,
                                    isActive: _activeFilter == 'females',
                                    onTap: () {
                                      setState(() => _activeFilter = 'females');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                              _allMembers = state.items;
                              final items = _getFilteredMembers(_allMembers);
                              return Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      color: Colors.white,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .resultsCount(items.length),
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
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                      const SizedBox(height: 8),
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

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
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
    );
  }
}
