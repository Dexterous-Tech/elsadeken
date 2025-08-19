import 'dart:convert';

import 'package:elsadeken/features/home/person_details/data/data_source/person_service.dart';
import 'package:elsadeken/features/home/person_details/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/person_image.dart';
import 'widgets/person_info.dart';

class PersonDetailsView extends StatefulWidget {
  final int personId;
  final String imageUrl;

  const PersonDetailsView({
    Key? key,
    required this.personId,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<PersonDetailsView> createState() => _PersonDetailsViewState();
}

class _PersonDetailsViewState extends State<PersonDetailsView> {
  PersonModel? person;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<PersonModel> getPersonDetails(String personId) async {
  final response = await http.get(Uri.parse("https://elsadkeen.sharetrip-ksa.com/api/user/show-one-user/$personId"));

  if (response.statusCode == 200) {
    return PersonModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load person details");
  }
}


  Future<void> fetchData() async {
    try {
      final data = await PersonService.fetchPersonDetails(widget.personId);
      setState(() {
        person = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : person == null
              ? const Center(child: Text("No data found"))
              : SafeArea(
                  child: Stack(
                    children: [
                      PersonImageHeader(imageUrl: person!.image),
                      PersonInfoSheet(person: person!),
                    ],
                  ),
                ),
    );
  }
}
