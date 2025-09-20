import 'dart:async';

import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/routes/app_routes.dart';

import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/home_header.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/swipeable_card.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_state.dart';
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
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  bool hasMore = true;

  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      Navigator.pushNamed(
        context,
        AppRoutes.searchResultScreen,
        arguments: context.read<SearchCubit>(),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    // Set initial tab index if provided
    if (widget.initialTabIndex != null &&
        widget.initialTabIndex! >= 0 &&
        widget.initialTabIndex! <= 3) {
      _currentIndex = widget.initialTabIndex!;
      print('🏠 [HomeScreen] Initial tab index set to: $_currentIndex');
    }

    _loadMatchesUsers();

    // Load chat list so SwipeableCard can access existing chat rooms
    print('🏠 [HomeScreen] Initializing and loading chat list...');
    _loadChatList();

    _focusNode.addListener(() {
      setState(() {
        showHistory = _focusNode.hasFocus && _searchController.text.isEmpty;
        showSuggestions = _searchController.text.isNotEmpty;
        if (_searchController.text.isNotEmpty) {}
      });
    });
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
        });
      }

      final apiService = await ApiServices.init();
      final response = await apiService.get(
        endpoint: ApiConstants.matchesUsers,
        queryParameters: {'page': currentPage},
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

  final FocusNode _focusNode = FocusNode();

  List<String> filteredResults = [];
  bool showHistory = false;
  bool showSuggestions = false;

  Future<void> _onSwipe(bool isLike) async {
    if (currentUsers.isEmpty) return;

    final swipedUser = currentUsers[0];
    final tempUsers = List<UserModel>.from(currentUsers);

    setState(() {
      currentUsers.removeAt(0);
    });

    try {
      if (isLike) {
        context.read<ProfileDetailsCubit>().likeUser(swipedUser.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.likedMessage,
                textAlign: TextAlign.center),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );
      } else {
        print("User ${swipedUser.id} removed by swipe left");
      }

      if (currentUsers.length < 3 && hasMore) {
        _loadMatchesUsers(loadMore: true);
      }
    } catch (e) {
      print("error: $e");
      setState(() {
        currentUsers = tempUsers;
      });
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
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
        colors: [
          Color(0xffF8ECD6).withValues(alpha: 0.1),
          Color(0xffF8ECD6),
        ],
      )),
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 23.w, vertical: 21.h),
                  child: Column(
                    crossAxisAlignment:
                        LocalizationService.instance.startCrossAxisAlignment,
                    textDirection: LocalizationService.instance.textDirection,
                    children: [
                      Column(
                        children: [
                          BlocProvider(
                            create: (context) => sl<ManageProfileCubit>(),
                            child: HomeHeader(),
                          ),
                          SizedBox(height: 21.h),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 12.w, end: 12.w),
                            child: CustomTextFormField(
                              focusNode: _focusNode,
                              onChanged: (value) {
                                context
                                    .read<SearchCubit>()
                                    .updateUsername(value);
                                _onSearchChanged(value);
                              },
                              hintText: AppLocalizations.of(context)!.search,
                              validator: (value) {},
                              suffixIcon: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xff949494),
                                  size: 19,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeightHelper.regular,
                                color: Color(0xff949494),
                                fontSize: 16.sp,
                                fontFamily: FontFamilyHelper.lamaSansArabic,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff949494),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff949494),
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                      if (isLoading)
                        Center(child: CircularProgressIndicator())
                      else if (errorMessage != null)
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              verticalSpace(150),
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
                      else if (currentUsers.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              verticalSpace(150),
                              Icon(Icons.favorite_outline,
                                  size: 80.w, color: Colors.grey[400]),
                              SizedBox(height: 16.h),
                              Text(
                                AppLocalizations.of(context)!.noNewMatches,
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          height: 600.h,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Stack(
                            children: currentUsers
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final user = entry.value;

                                  final isTopCard = index == 0;
                                  final isSecondCard = index == 1;

                                  double scale = 1.0;
                                  double verticalOffset = 0.0.h;

                                  if (isSecondCard) {
                                    scale = 0.95;
                                    verticalOffset = 20.h;
                                  } else if (!isTopCard) {
                                    scale = 0.9;
                                    verticalOffset = 40.h;
                                  }

                                  return SwipeableCard(
                                    user: user,
                                    onSwipe: isTopCard ? _onSwipe : null,
                                    isTop: isTopCard,
                                    scale: scale,
                                    verticalOffset: verticalOffset,
                                  );
                                })
                                .toList()
                                .reversed
                                .toList(),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getBody() {
    switch (_currentIndex) {
      case 0:
        return GestureDetector(
            behavior: HitTestBehavior
                .translucent, // Ensures taps are detected on empty space
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: buildHomeContent());
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
