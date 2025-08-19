import 'dart:async';

import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';

import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/swipeable_card.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/results/presentation/view/results_screen.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../members/members_section/view/members_screen.dart';
import '../../../notification/presentation/view/notification_screen.dart';
import '../../data/models/user_model.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileDetailsCubit>(),
      child: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
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
    _loadMatchesUsers();
    _loadUserData();

    _focusNode.addListener(() {
      setState(() {
        showHistory = _focusNode.hasFocus && _searchController.text.isEmpty;
        showSuggestions = _searchController.text.isNotEmpty;
        if (_searchController.text.isNotEmpty) {}
      });
    });
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
        currentUsers.addAll(data.map((userJson) => UserModel(
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
            )));

        hasMore = response.data['links']['next'] != null;
        if (hasMore) currentPage++;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load matches';
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
        final apiService = await ApiServices.init();
        context.read<ProfileDetailsCubit>().likeUser(swipedUser.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم الإعجاب!', textAlign: TextAlign.center),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );
      } else {
        // سوايب ليفت: مفيش أي API Call
        print("User ${swipedUser.id} removed by swipe left");
      }

      if (currentUsers.length < 3 && hasMore) {
        _loadMatchesUsers(loadMore: true);
      }
    } catch (e) {
      print("fashal error: $e");
      setState(() {
        currentUsers = tempUsers;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تسجيل الإجراء', textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    final user = await LoginCubit.getUserData();
    if (user != null) {
      setState(() {
        // city = user.city;
        // country = user.country;
        name = user.name;
      });
      print("Loaded user: ${user.name}, ${user.email}");
    } else {
      print("No user data found");
    }
  }

  Widget buildHomeContent() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 47.w,
                          height: 47.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFCF8F5),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/home/home_notification.png',
                              width: 22.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            //  textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeightHelper.semiBold,
                                ),
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Image.asset(
                                    'assets/images/home/home_location.png',
                                    width: 15.w,
                                    height: 18.h,
                                  ),
                                  SizedBox(width: 13),
                                  Text(
                                    '$country $city',
                                    style: TextStyle(
                                        color:
                                            Color(0xff000000).withOpacity(0.87),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeightHelper.medium),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-vector/hijab-girl-cartoon-illustration-vector-design_1058532-14452.jpg?w=1380',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 21.h),
                  CustomTextFormField(
                    focusNode: _focusNode,
                    onChanged: (value) {
                      context.read<SearchCubit>().updateUsername(value);
                      _onSearchChanged(value);
                    },
                    // context.read<SearchCubit>().updateUsername(value);
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.searchResultScreen,
                    //   arguments: context.read<SearchCubit>(),
                    // );

                    hintText: '...بحث',
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff949494),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
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
                    children: [
                      Text(errorMessage!),
                      ElevatedButton(
                        onPressed: _loadMatchesUsers,
                        child: Text('حاول مرة أخرى'),
                      ),
                    ],
                  ),
                )
              else if (currentUsers.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_outline,
                          size: 80.w, color: Colors.grey[400]),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد مطابقات جديدة',
                        style:
                            TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
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
    );
  }

  Widget getBody() {
    switch (_currentIndex) {
      case 0:
        return buildHomeContent();
      case 1:
        return Center(child: Text('الرسائل'));
      case 2:
        return MembersScreen();
      case 3:
        return ProfileBody();
      default:
        return buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: getBody(),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          elevation: 1,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Color(0xffA0A4B0),
          selectedItemColor:
              _currentIndex == 3 ? Color(0xffD54B16) : Color(0xffFFB74D),
          unselectedLabelStyle: TextStyle(
              color: Color(0xffA0A4B0),
              fontSize: 12.sp,
              fontFamily: FontFamilyHelper.lamaSansArabic,
              fontWeight: FontWeightHelper.medium),
          selectedLabelStyle: TextStyle(
              color: Color(0xffFFB74D),
              fontSize: 12.sp,
              fontFamily: FontFamilyHelper.lamaSansArabic,
              fontWeight: FontWeightHelper.medium),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home/home_gray.png',
                width: 24.w,
                height: 24.h,
              ),
              label: 'الرئيسية',
              activeIcon: Image.asset(
                'assets/images/home/home_orange.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home/message_gray.png',
                width: 24.w,
                height: 24.h,
              ),
              label: 'الرسائل',
              activeIcon: Image.asset(
                'assets/images/home/message_orange.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home/group_gray.png',
                width: 24.w,
                height: 24.h,
              ),
              label: 'الاعضاء',
              activeIcon: Image.asset(
                'assets/images/home/group_orange.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home/profile_gray.png',
                width: 24.w,
                height: 24.h,
              ),
              label: 'الحساب',
              activeIcon: Image.asset(
                'assets/images/home/profile_orange.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
