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
    // استدعاء البحث مباشرة عند تحميل الصفحة
    context.read<SearchCubit>().performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('نتائج البحث', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchSuccess) {
                final results = state.results;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      color: Colors.white,
                      child: Text(
                        'عدد النتائج: ${results.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final person = results[index];
                          return PersonCardWidget(
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
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }

              return const Center(child: Text("ابدأ البحث لعرض النتائج"));
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