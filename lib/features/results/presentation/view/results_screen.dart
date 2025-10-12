import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/results/presentation/view/widgets/result_card.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({super.key});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  ScrollController? _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().performSearch();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _loadMoreUsers(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final state = cubit.state;

    if (state is SearchSuccess && state.hasNextPage && !_isLoadingMore) {
      print(
          'Loading more search results: current page ${state.currentPage}, next page ${state.currentPage + 1}');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.loadMoreResults().then((_) {
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomProfileBody(
          contentBody: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return CustomProfileBody(
                    contentBody: Column(
                  children: [
                    ProfileHeader(
                        title: AppLocalizations.of(context)!.searchResults),
                    verticalSpace(42),
                    Expanded(
                        child:
                            const Center(child: CircularProgressIndicator())),
                  ],
                ));
              } else if (state is SearchSuccess) {
                final results = state.results;
                return Column(
                  children: [
                    ProfileHeader(
                        title: AppLocalizations.of(context)!.searchResults),
                    verticalSpace(42),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Colors.white,
                      child: Text(
                        AppLocalizations.of(context)!
                            .resultsCount(results.length),
                        textAlign: LocalizationService.instance.textAlignment,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // Initialize scroll controller here where context is available
                          _scrollController ??= ScrollController()
                            ..addListener(() => _onScroll(context));

                          return RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<SearchCubit>()
                                  .performSearch(page: 1);
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  results.length + (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == results.length && _isLoadingMore) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .loadingMore,
                                            textAlign: TextAlign.center,
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

                                final person = results[index];
                                return PersonCardWidget(
                                  onTap: () {
                                    // Debug: Print the person ID and its type
                                    print(
                                        'Person ID before navigation: ${person.id} (type: ${person.id.runtimeType})');
                                    context.pushNamed(
                                        AppRoutes.profileDetailsScreen,
                                        arguments: person.id);
                                  },
                                  personData: PersonData(
                                    name: person.name,
                                    age: person.age,
                                    location:
                                        '${person.city}, ${person.country}',
                                    country: person.country,
                                    city: person.city,
                                    profileImageUrl: person.profileImage,
                                    isOnline: person.isOnline,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is SearchError) {
                return CustomProfileBody(
                    contentBody: Column(
                  children: [
                    ProfileHeader(
                        title: AppLocalizations.of(context)!.searchResults),
                    verticalSpace(42),
                    Expanded(
                        child: Center(
                            child: Text(state.message,
                                style: const TextStyle(color: Colors.red)))),
                  ],
                ));
              }

              return CustomProfileBody(
                  contentBody: Column(
                children: [
                  ProfileHeader(
                      title: AppLocalizations.of(context)!.searchResults),
                  verticalSpace(42),
                  Expanded(
                      child: Center(
                          child: Text(AppLocalizations.of(context)!
                              .startSearchToShowResults))),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}

class PersonData {
  final int? id;
  final String name;
  final int age;
  final String country;
  final String city;
  final String location;
  final String profileImageUrl;
  final bool isOnline;

  PersonData({
    this.id,
    required this.name,
    required this.age,
    required this.country,
    required this.city,
    required this.location,
    required this.profileImageUrl,
    required this.isOnline,
  });
}
