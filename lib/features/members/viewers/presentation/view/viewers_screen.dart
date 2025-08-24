import 'package:elsadeken/features/members/viewers/presentation/view/widgets/viewers_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/members/data/models/members.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

class ViewersView extends StatefulWidget {
  const ViewersView({Key? key}) : super(key: key);

  @override
  State<ViewersView> createState() => _ViewersViewState();
}

class _ViewersViewState extends State<ViewersView> {
  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<Member>(
      () => sl<MembersRepository>().getVisitors(),
    )..fetch();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            ' من زار بياناتي ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
              child: BlocProvider<MembersListCubit<Member>>(
                create: (_) => cubit,
                child: Column(
                  children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: const Text(
                  'اليوم',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<MembersListCubit<Member>, MembersListState<Member>>(
                builder: (context, state) {
                  if (state is MembersListLoading<Member>) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is MembersListError<Member>) {
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
                  if (state is MembersListEmpty<Member>) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          'لا توجد نتائج حالياً',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is MembersListLoaded<Member>) {
                    final items = state.items;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final m = items[index];
                          final data = ViewersData(
                            id: m.id,
                            name: m.name,
                            age: m.attribute?.age ?? 0,
                            time: m.createdAt,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ViewersCard(
                              viewerData: data,
                            ),
                          );
                        },
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
    );
  }
}

class ViewersData {
  final int id;
  final String name;
  final int age;
  final String time;

  ViewersData({
    required this.id,
    required this.name,
    required this.age,
    required this.time,
  });
}
