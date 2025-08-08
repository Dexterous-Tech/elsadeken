import 'widgets/members_profile_body.dart';
import 'package:flutter/material.dart';

class MembersProfileScreen extends StatelessWidget {
  const MembersProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MembersProfileBody(),
    );
  }
}
