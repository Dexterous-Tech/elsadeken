import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/home/home/presentation/view/widgets/swipeable_card.dart';
import 'package:elsadeken/features/profile/profile/presentation/view/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../notification/presentation/view/notification_screen.dart';
import '../../data/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<UserModel> users = [
    UserModel(
      name: 'عمار محمد',
      age: 23,
      profession: 'محاسب',
      location: 'الرياض',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      matchPercentage: 94,
      isOnline: true,
    ),
    UserModel(
      name: 'أحمد علي',
      age: 28,
      profession: 'مهندس',
      location: 'جدة',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      matchPercentage: 87,
    ),
    UserModel(
      name: 'محمد سالم',
      age: 26,
      profession: 'طبيب',
      location: 'الدمام',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      matchPercentage: 92,
    ),
  ];

  List<UserModel> currentUsers = [];

  @override
  void initState() {
    super.initState();
    currentUsers = List.from(users);
  }

  void _onSwipe(bool isLike) {
    if (currentUsers.isEmpty) return;

    final likedUser = currentUsers[0];

    setState(() {
      currentUsers.removeAt(0);
    });

    if (isLike) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم الإعجاب!', textAlign: TextAlign.center),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );

      // Future.delayed(Duration(milliseconds: 300), () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PersonDetailsView(
      //         personId: likedUser.name,
      //         imageUrl: likedUser.imageUrl,
      //       ),
      //     ),
      //   );
      // });
    }
  }

  Widget buildHomeContent() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Column(
                children: [
                  // ✅ معلومات المستخدم والبحث
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffFCF8F5),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/home/home_notification.png',
                              width: 22,
                              height: 20,
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
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                'Hend Osama',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeightHelper.semiBold,
                                ),
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Image.asset(
                                    'assets/images/home/home_location.png',
                                    width: 15,
                                    height: 18,
                                  ),
                                  SizedBox(width: 13),
                                  Text(
                                    'مصر القليوبية',
                                    style: TextStyle(
                                        color:
                                            Color(0xff000000).withOpacity(0.87),
                                        fontSize: 15,
                                        fontWeight: FontWeightHelper.medium),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-vector/hijab-girl-cartoon-illustration-vector-design_1058532-14452.jpg?w=1380',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),
                  CustomTextFormField(
                    hintText: '...بحث',
                    validator: (value) {},
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(0xff949494),
                      size: 19,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeightHelper.regular,
                      color: Color(0xff949494),
                      fontSize: 16,
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
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              currentUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline,
                              size: 80, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد مطابقات جديدة',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 600, // يمكنك تعديلها حسب الحاجة
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
                              double verticalOffset = 0.0;

                              if (isSecondCard) {
                                scale = 0.95;
                                verticalOffset = 20;
                              } else if (!isTopCard) {
                                scale = 0.9;
                                verticalOffset = 40;
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
        return Center(child: Text('الاعضاء'));
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
              fontSize: 12,
              fontFamily: FontFamilyHelper.lamaSansArabic,
              fontWeight: FontWeightHelper.medium),
          selectedLabelStyle: TextStyle(
              color: Color(0xffFFB74D),
              fontSize: 12,
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
                'assets/images/home/home_orange.png', // Active icon
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
                'assets/images/home/message_orange.png', // Active icon
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
                'assets/images/home/group_orange.png', // Active icon
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
                'assets/images/home/profile_orange.png', // Active icon
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
