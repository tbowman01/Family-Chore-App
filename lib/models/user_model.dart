import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';

/// Represents a family member (parent or child)
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final int totalPoints;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.totalPoints = 0,
    this.avatarUrl,
  });

  /// Creates a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data[FirestoreConstants.memberName] ?? '',
      email: data[FirestoreConstants.memberEmail] ?? '',
      role: data[FirestoreConstants.memberRole] ?? '',
      totalPoints: data[FirestoreConstants.memberTotalPoints] ?? 0,
      avatarUrl: data[FirestoreConstants.memberAvatarUrl],
    );
  }

  /// Creates a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map[FirestoreConstants.memberName] ?? '',
      email: map[FirestoreConstants.memberEmail] ?? '',
      role: map[FirestoreConstants.memberRole] ?? '',
      totalPoints: map[FirestoreConstants.memberTotalPoints] ?? 0,
      avatarUrl: map[FirestoreConstants.memberAvatarUrl],
    );
  }

  /// Converts UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.memberName: name,
      FirestoreConstants.memberEmail: email,
      FirestoreConstants.memberRole: role,
      FirestoreConstants.memberTotalPoints: totalPoints,
      if (avatarUrl != null) FirestoreConstants.memberAvatarUrl: avatarUrl,
    };
  }

  /// Creates a copy with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    int? totalPoints,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      totalPoints: totalPoints ?? this.totalPoints,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Checks if user is a parent
  bool get isParent => role == 'parent';

  /// Checks if user is a child
  bool get isChild => role == 'child';

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, totalPoints: $totalPoints)';
  }
}
