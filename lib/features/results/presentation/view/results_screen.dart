import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/results/presentation/view/widgets/result_card.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({Key? key}) : super(key: key);

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}


class _SearchResultsViewState extends State<SearchResultsView> {
  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomProfileBody(
          contentBody: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return CustomProfileBody(
                    contentBody: Column(
                  children: [
                    ProfileHeader(title: 'نتائج البحث'),
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
                    ProfileHeader(title: 'نتائج البحث'),
                    verticalSpace(42),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Colors.white,
                      child: Text(
                        'عدد النتائج: ${results.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final person = results[index];
                          return PersonCardWidget(
                            onTap: () {
                              // Debug: Print the person ID and its type
                              print(
                                  'Person ID before navigation: ${person.id} (type: ${person.id.runtimeType})');
                              context.pushNamed(AppRoutes.profileDetailsScreen,
                                  arguments: person.id);
                            },
                            personData: PersonData(
                              name: person.name,
                              age: person.age,
                              location: '${person.city}, ${person.country}',
                              country: person.country,
                              city: person.city,
                              profileImageUrl: person.profileImage,
                              isOnline: person.isOnline,
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
                    ProfileHeader(title: 'نتائج البحث'),
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
                  ProfileHeader(title: 'نتائج البحث'),
                  verticalSpace(42),
                  Expanded(
                      child:
                          const Center(child: Text("ابدأ البحث لعرض النتائج"))),
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
  final String name;
  final int age;
  final String country;
  final String city;
  final String location;
  final String profileImageUrl;
  final bool isOnline;

  PersonData({
    required this.name,
    required this.age,
    required this.country,
    required this.city,
    required this.location,
    required this.profileImageUrl,
    required this.isOnline,
  });
}
