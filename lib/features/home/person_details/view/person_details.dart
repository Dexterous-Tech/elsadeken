import 'package:elsadeken/features/home/person_details/view/widgets/person_image.dart';
import 'package:elsadeken/features/home/person_details/view/widgets/person_info.dart';
import 'package:flutter/material.dart';

class PersonDetailsView extends StatefulWidget {
  final String personId;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Stack(
        children: [
          PersonImageHeader(imageUrl: widget.imageUrl),
          PersonInfoSheet(personId: widget.personId),
        ],
      ),
    );
  }
}
