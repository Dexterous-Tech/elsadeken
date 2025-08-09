import 'package:elsadeken/features/members/viewers/presentation/view/widgets/viewers_card.dart';
import 'package:flutter/material.dart';

class ViewersView extends StatefulWidget {
  const ViewersView({Key? key}) : super(key: key);

  @override
  State<ViewersView> createState() => _ViewersViewState();
}

class _ViewersViewState extends State<ViewersView> {
  @override
  Widget build(BuildContext context) {
    final List<ViewersData> viewers = [
      ViewersData(
        name: "Ammar muahmmed",
        age: 56,
        time: "منذ دقيقتين",
      ),
      ViewersData(
        name: "Ammar muahmmed",
        age: 56,
        time: "منذ دقيقتين",
      ),
      ViewersData(
        name: "Ammar muahmmed",
        age: 56,
        time: "منذ دقيقتين",
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
        body: SafeArea(
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
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: viewers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ViewersCard(
                        viewerData: viewers[index],
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

class ViewersData {
  final String name;
  final int age;
  final String time;

  ViewersData({
    required this.name,
    required this.age,
    required this.time,
  });
}
