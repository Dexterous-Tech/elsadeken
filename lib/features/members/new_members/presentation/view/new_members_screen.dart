import 'package:elsadeken/features/members/new_members/presentation/view/widgets/new_members_card.dart';
import 'package:flutter/material.dart';

import '../../../Health_statuses/presentation/view/widgets/gender_filter.dart';

class NewMembersView extends StatefulWidget {
  const NewMembersView({Key? key}) : super(key: key);

  @override
  State<NewMembersView> createState() => _NewMembersViewState();
}

class _NewMembersViewState extends State<NewMembersView> {
  String _activeFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final List<NewMemberData> newMembers = [
      NewMemberData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
        isOnline: true,
      ),
      NewMemberData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
        isOnline: true,
      ),
      NewMemberData(
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
            'أعضاء جدد',
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F1E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GenderFilter(
                      text: 'الكل',
                      isActive: _activeFilter == 'الكل',
                      onTap: () => setState(() => _activeFilter = 'الكل'),
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الذكور',
                      isActive: _activeFilter == 'الذكور',
                      onTap: () => setState(() => _activeFilter = 'الذكور'),
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الإناث',
                      isActive: _activeFilter == 'الإناث',
                      onTap: () => setState(() => _activeFilter = 'الإناث'),
                    ),
                  ],
                ),
              ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: newMembers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NewMemberCard(
                        memberData: newMembers[index],
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

class NewMemberData {
  final String name;
  final int age;
  final String location;
  final String profileImageUrl;
  final bool isOnline;

  NewMemberData({
    required this.name,
    required this.age,
    required this.location,
    required this.profileImageUrl,
    required this.isOnline,
  });
}
