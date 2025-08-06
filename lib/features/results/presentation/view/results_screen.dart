import 'package:elsadeken/features/results/presentation/view/widgets/result_card.dart';
import 'package:flutter/material.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PersonData> searchResults = [
      PersonData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
        isOnline: true,
      ),
      PersonData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
        isOnline: true,
      ),
      PersonData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
        isOnline: true,
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'نتائج البحث',
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
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: const Text(
                  'عدد النتائج: 66',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PersonCardWidget(
                        personData: searchResults[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonData {
  final String name;
  final int age;
  final String location;
  final String profileImageUrl;
  final bool isOnline;

  PersonData({
    required this.name,
    required this.age,
    required this.location,
    required this.profileImageUrl,
    required this.isOnline,
  });
}
