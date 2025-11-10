import 'package:flutter/material.dart';
import 'parent/parent_dashboard.dart';
import 'child/child_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final String userType; // 'parent' or 'child'
  final String familyId;
  final String userId;

  const HomeScreen({
    super.key,
    required this.userType,
    required this.familyId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Route to the appropriate dashboard based on user type
    if (userType == 'parent') {
      return ParentDashboard(
        familyId: familyId,
        userId: userId,
      );
    } else {
      return ChildDashboard(
        familyId: familyId,
        userId: userId,
      );
    }
  }
}
