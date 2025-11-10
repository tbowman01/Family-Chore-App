import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';

/// Represents a family group
class FamilyModel {
  final String id;
  final String name;
  final String createdBy;
  final DateTime createdAt;
  final List<String> memberIds;

  FamilyModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.memberIds,
  });

  /// Creates a FamilyModel from Firestore document
  factory FamilyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyModel(
      id: doc.id,
      name: data[FirestoreConstants.familyName] ?? '',
      createdBy: data[FirestoreConstants.familyCreatedBy] ?? '',
      createdAt: (data[FirestoreConstants.familyCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      memberIds: List<String>.from(data[FirestoreConstants.familyMemberIds] ?? []),
    );
  }

  /// Creates a FamilyModel from a Map
  factory FamilyModel.fromMap(Map<String, dynamic> map, String id) {
    return FamilyModel(
      id: id,
      name: map[FirestoreConstants.familyName] ?? '',
      createdBy: map[FirestoreConstants.familyCreatedBy] ?? '',
      createdAt: (map[FirestoreConstants.familyCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      memberIds: List<String>.from(map[FirestoreConstants.familyMemberIds] ?? []),
    );
  }

  /// Converts FamilyModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.familyName: name,
      FirestoreConstants.familyCreatedBy: createdBy,
      FirestoreConstants.familyCreatedAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.familyMemberIds: memberIds,
    };
  }

  /// Creates a copy with updated fields
  FamilyModel copyWith({
    String? id,
    String? name,
    String? createdBy,
    DateTime? createdAt,
    List<String>? memberIds,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
    );
  }

  @override
  String toString() {
    return 'FamilyModel(id: $id, name: $name, createdBy: $createdBy, memberCount: ${memberIds.length})';
  }
}
