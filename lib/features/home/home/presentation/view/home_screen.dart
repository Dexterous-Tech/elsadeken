import 'dart:async';

import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';

import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/home_header.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/swipeable_card.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/core/services/localization_service.dart';

import '../../../../members/members_section/view/members_screen.dart';
import '../../data/models/user_model.dart';
import 'package:elsadeken/features/chat/presentation/view/chat_page.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key, this.initialTabIndex});

  final int? initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileDetailsCubit>()),
        BlocProvider(create: (context) => sl<ChatListCubit>()),
        BlocProvider(
            create: (context) => sl<SignUpListsCubit>()..getCountries()),
      ],
      child: HomeScreen(initialTabIndex: initialTabIndex),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialTabIndex});

  final int? initialTabIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String country = 'مصر';
  String city = 'القاهرة';
  String name = 'اسم';

  int _currentIndex = 0;
  List<UserModel> currentUsers = [];
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  bool hasMore = true;
  int? selectedCountryId; // null means "All"
  late PageController _pageController;
  Locale? _previousLocale;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if locale has changed
    final currentLocale = Localizations.localeOf(context);
    if (_previousLocale != null && _previousLocale != currentLocale) {
      // Language changed, reload countries and matches
      print(
          '🌐 [HomeScreen] Language changed from ${_previousLocale?.languageCode} to ${currentLocale.languageCode}');
      context.read<SignUpListsCubit>().getCountries();
      _loadMatchesUsers();
    }
    _previousLocale = currentLocale;
  }

  @override
  void initState() {
    super.initState();

    // Initialize PageController
    _pageController = PageController(viewportFraction: 0.9);

    // Add listener to auto-load more when near the end
    _pageController.addListener(() {
      if (_pageController.hasClients && hasMore && !isLoading) {
        final currentPage = _pageController.page ?? 0;
        // Load more when user is 2 cards away from the end
        if (currentPage >= currentUsers.length - 2) {
          _loadMatchesUsers(loadMore: true);
        }
      }
    });

    // Set initial tab index if provided
    if (widget.initialTabIndex != null &&
        widget.initialTabIndex! >= 0 &&
        widget.initialTabIndex! <= 3) {
      _currentIndex = widget.initialTabIndex!;
      print('🏠 [HomeScreen] Initial tab index set to: $_currentIndex');
    }

    // Load countries for filter
    context.read<SignUpListsCubit>().getCountries();

    _loadMatchesUsers();

    // Load chat list so SwipeableCard can access existing chat rooms
    print('🏠 [HomeScreen] Initializing and loading chat list...');
    _loadChatList();
  }

  /// Load chat list with proper error handling and logging
  Future<void> _loadChatList() async {
    try {
      print('🏠 [HomeScreen] Loading chat list...');
      final chatListCubit = context.read<ChatListCubit>();

      // Check current state
      final currentState = chatListCubit.state;
      print(
          '🏠 [HomeScreen] Current chat list state: ${currentState.runtimeType}');

      if (currentState is! ChatListLoaded) {
        print('🏠 [HomeScreen] Chat list not loaded, calling getChatList()...');
        await chatListCubit.getChatList();

        // Wait a bit and check the state again
        await Future.delayed(Duration(milliseconds: 1000));
        final newState = chatListCubit.state;
        print(
            '🏠 [HomeScreen] Chat list state after loading: ${newState.runtimeType}');

        if (newState is ChatListLoaded) {
          print(
              '🏠 [HomeScreen] ✅ Chat list loaded successfully with ${newState.chatList.data.length} chats');
        } else if (newState is ChatListError) {
          print(
              '🏠 [HomeScreen] ❌ Chat list failed to load: ${newState.message}');
        }
      } else {
        print(
            '🏠 [HomeScreen] ✅ Chat list already loaded with ${currentState.chatList.data.length} chats');
      }
    } catch (e) {
      print('🏠 [HomeScreen] ❌ Error loading chat list: $e');
    }
  }

  Future<void> _loadMatchesUsers({bool loadMore = false}) async {
    if (loadMore && !hasMore) return;

    try {
      if (!loadMore) {
        setState(() {
          isLoading = true;
          errorMessage = null;
          currentUsers = [];
          currentPage = 1;
        });
      }

      final apiService = await ApiServices.init();

      // Build query parameters
      Map<String, dynamic> queryParams = {'page': currentPage};
      if (selectedCountryId != null) {
        queryParams['country_id'] = selectedCountryId;
      }

      final response = await apiService.get(
        endpoint: ApiConstants.matchesUsers,
        queryParameters: queryParams,
        requiresAuth: true,
      );

      final data = response.data['data'] as List;
      if (data.isEmpty && !loadMore) {
        setState(() {
          isLoading = false;
          currentUsers = [];
        });
        return;
      }

      setState(() {
        currentUsers.addAll(data.map((userJson) {
          print("Processing user JSON: $userJson");
          print("User ID: ${userJson['id']}, Name: ${userJson['name']}");

          return UserModel(
            //
            id: userJson['id'],
            name: userJson['name'],
            age: userJson['age'],
            profession: userJson['job'],
            location: '${userJson['city']}, ${userJson['country']}',
            imageUrl: userJson['image'],
            matchPercentage: userJson['match_percentage'] is int
                ? userJson['match_percentage']
                : (userJson['match_percentage'] as double).round(),
            isFavorite: userJson['is_favorite'] == 1,
          );
        }));

        print("Total users loaded: ${currentUsers.length}");
        print(
            "First user ID: ${currentUsers.isNotEmpty ? currentUsers.first.id : 'No users'}");

        hasMore = response.data['links']['next'] != null;
        if (hasMore) currentPage++;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.failedToLoadMatches;
        isLoading = false;
      });
    }
  }

  void _onCountrySelected(int? countryId) {
    setState(() {
      selectedCountryId = countryId;
    });
    _loadMatchesUsers();
    // Reset page to first card when filter changes
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  // Handler for like action in carousel mode
  Future<void> _onCarouselLike(int userId) async {
    try {
      context.read<ProfileDetailsCubit>().likeUser(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.likedMessage,
              textAlign: TextAlign.center),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );
    } catch (e) {
      print("error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.actionFailed,
              textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  Widget buildHomeContent() {
    return Container(
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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: LocalizationService.instance.textDirection,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 21.h),
              child: BlocProvider(
                create: (context) => sl<ManageProfileCubit>(),
                child: HomeHeader(),
              ),
            ),

            // Country Filter
            Flexible(
              flex: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: LocalizationService.instance.textDirection,
                children: [
                  verticalSpace(16),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 23.w),
                    child: Text(
                      AppLocalizations.of(context)!.selectCountry,
                      style: AppTextStyles.font20JetRegularLamaSans
                          .copyWith(color: AppColors.black),
                      textAlign: LocalizationService.instance.textAlignment,
                      textDirection: LocalizationService.instance.textDirection,
                    ),
                  ),
                  verticalSpace(14),
                  BlocBuilder<SignUpListsCubit, SignUpListsState>(
                    builder: (context, state) {
                      if (state is CountriesSuccess) {
                        return SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 23.w),
                            itemCount:
                                state.countriesList.length + 1, // +1 for "All"
                            itemBuilder: (context, index) {
                              // First item is "All"
                              if (index == 0) {
                                final isSelected = selectedCountryId == null;
                                return GestureDetector(
                                  onTap: () => _onCountrySelected(null),
                                  child: Container(
                                    margin:
                                        EdgeInsetsDirectional.only(end: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xffDBAE48)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10).r,
                                      border: Border.all(
                                        color: Color(0xffE1E1E1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        LocalizationService
                                                    .instance
                                                    .currentLocale
                                                    .languageCode ==
                                                'ar'
                                            ? 'الكل'
                                            : 'All',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Color(0xffDBAE48),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeightHelper.medium,
                                          fontFamily:
                                              FontFamilyHelper.lamaSansArabic,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Country items
                              final country = state.countriesList[index - 1];
                              final isSelected =
                                  selectedCountryId == country.id;

                              return GestureDetector(
                                onTap: () => _onCountrySelected(country.id),
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(end: 12.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xffDBAE48)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10).r,
                                    border: Border.all(
                                      color: Color(0xffE1E1E1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      country.name ?? '',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Color(0xffDBAE48),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeightHelper.medium,
                                        fontFamily:
                                            FontFamilyHelper.lamaSansArabic,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is CountriesLoading) {
                        return SizedBox(
                          height: 50.h,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // Cards Carousel
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .failedToLoadMatches,
                                style: AppTextStyles.font14JetRegularLamaSans
                                    .copyWith(color: AppColors.red),
                              ),
                              verticalSpace(18),
                              ElevatedButton(
                                onPressed: _loadMatchesUsers,
                                child: Text(
                                    AppLocalizations.of(context)!.tryAgain),
                              ),
                            ],
                          ),
                        )
                      : currentUsers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_outline,
                                      size: 80.w, color: Colors.grey[400]),
                                  SizedBox(height: 16.h),
                                  Text(
                                    AppLocalizations.of(context)!.noNewMatches,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount:
                                  currentUsers.length + (hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                // Load more button at the end
                                if (index == currentUsers.length) {
                                  return Center(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _loadMatchesUsers(loadMore: true),
                                      child: Container(
                                        width: 100.w,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              size: 40.w,
                                              color: Color(0xffDBAE48),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              LocalizationService
                                                          .instance
                                                          .currentLocale
                                                          .languageCode ==
                                                      'ar'
                                                  ? 'المزيد'
                                                  : 'Load More',
                                              style: TextStyle(
                                                color: Color(0xffDBAE48),
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    FontWeightHelper.medium,
                                                fontFamily: FontFamilyHelper
                                                    .lamaSansArabic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                // User card
                                final user = currentUsers[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 10.h),
                                  child: SwipeableCard(
                                    user: user,
                                    onSwipe:
                                        null, // Disable swipe in carousel mode
                                    onLike:
                                        _onCarouselLike, // Enable like in carousel mode
                                    isTop: false, // Not swipeable
                                    scale: 1.0,
                                    verticalOffset: 0,
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    switch (_currentIndex) {
      case 0:
        return buildHomeContent();
      case 1:
        return ChatPage();
      case 2:
        return MembersScreen();
      case 3:
        return ProfileBody();
      default:
        return buildHomeContent();
    }
  }

  Widget _buildNavItem(int index, String svgIcon, String label) {
    bool isSelected = _currentIndex == index;

    // Determine border radius based on index and directionality
    BorderRadius getItemBorderRadius() {
      if (!isSelected) return BorderRadius.zero;

      bool isRTL =
          LocalizationService.instance.textDirection == TextDirection.rtl;

      if (index == 0 || index == 3) {
        // For items 0 and 3, apply radius based on directionality
        if (index == 0) {
          // First item (Home)
          return isRTL
              ? BorderRadius.only(
                  topRight: Radius.circular(25).r,
                  bottomRight: Radius.circular(25).r,
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(25).r,
                  bottomLeft: Radius.circular(25).r,
                );
        } else {
          // Last item (Profile)
          return isRTL
              ? BorderRadius.only(
                  topLeft: Radius.circular(25).r,
                  bottomLeft: Radius.circular(25).r,
                )
              : BorderRadius.only(
                  topRight: Radius.circular(25).r,
                  bottomRight: Radius.circular(25).r,
                );
        }
      } else {
        // For items 1 and 2, no radius (rectangle/square)
        return BorderRadius.zero;
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        height: double.infinity, // Take full height of navigation bar
        // padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffDBAE48) : Colors.transparent,
          borderRadius: getItemBorderRadius(),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Color(0xffDBAE48),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xffDBAE48),
                fontSize: 12.sp,
                fontFamily: FontFamilyHelper.lamaSansArabic,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true, // allows body to paint behind bottomNavigationBar
        body: getBody(),
        bottomNavigationBar: Directionality(
          textDirection: LocalizationService.instance.textDirection,
          child: Container(
            height: 60.h,
            margin: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: 24.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25).r,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildNavItem(0, 'assets/svg/home_icon.svg',
                      AppLocalizations.of(context)!.homeLabel),
                ),
                Expanded(
                  child: _buildNavItem(1, 'assets/svg/message_icon.svg',
                      AppLocalizations.of(context)!.messagesLabel),
                ),
                Expanded(
                  child: _buildNavItem(2, 'assets/svg/group_icon.svg',
                      AppLocalizations.of(context)!.members),
                ),
                Expanded(
                  child: _buildNavItem(3, 'assets/svg/profile_icon.svg',
                      AppLocalizations.of(context)!.accountLabel),
                ),
              ],
            ),
          ),
        ));
  }
}
