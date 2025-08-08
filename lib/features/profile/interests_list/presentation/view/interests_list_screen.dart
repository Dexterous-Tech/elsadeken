import 'widgets/interests_list_body.dart';
import 'package:flutter/material.dart';

class InterestsListScreen extends StatelessWidget {
  const InterestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InterestsListBody(),
    );
  }
}
