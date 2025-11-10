import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';

/// Represents a chore assigned to a family member
class ChoreModel {
  final String id;
  final String title;
  final String description;
  final int pointValue;
  final String assignedTo;
  final String createdBy;
  final String status;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  ChoreModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.pointValue,
    required this.assignedTo,
    required this.createdBy,
    required this.status,
    this.dueDate,
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a ChoreModel from Firestore document
  factory ChoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChoreModel(
      id: doc.id,
      title: data[FirestoreConstants.choreTitle] ?? '',
      description: data[FirestoreConstants.choreDescription] ?? '',
      pointValue: data[FirestoreConstants.chorePointValue] ?? 0,
      assignedTo: data[FirestoreConstants.choreAssignedTo] ?? '',
      createdBy: data[FirestoreConstants.choreCreatedBy] ?? '',
      status: data[FirestoreConstants.choreStatus] ?? 'active',
      dueDate: (data[FirestoreConstants.choreDueDate] as Timestamp?)?.toDate(),
      createdAt: (data[FirestoreConstants.choreCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data[FirestoreConstants.choreCompletedAt] as Timestamp?)?.toDate(),
    );
  }

  /// Creates a ChoreModel from a Map
  factory ChoreModel.fromMap(Map<String, dynamic> map, String id) {
    return ChoreModel(
      id: id,
      title: map[FirestoreConstants.choreTitle] ?? '',
      description: map[FirestoreConstants.choreDescription] ?? '',
      pointValue: map[FirestoreConstants.chorePointValue] ?? 0,
      assignedTo: map[FirestoreConstants.choreAssignedTo] ?? '',
      createdBy: map[FirestoreConstants.choreCreatedBy] ?? '',
      status: map[FirestoreConstants.choreStatus] ?? 'active',
      dueDate: (map[FirestoreConstants.choreDueDate] as Timestamp?)?.toDate(),
      createdAt: (map[FirestoreConstants.choreCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (map[FirestoreConstants.choreCompletedAt] as Timestamp?)?.toDate(),
    );
  }

  /// Converts ChoreModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.choreTitle: title,
      FirestoreConstants.choreDescription: description,
      FirestoreConstants.chorePointValue: pointValue,
      FirestoreConstants.choreAssignedTo: assignedTo,
      FirestoreConstants.choreCreatedBy: createdBy,
      FirestoreConstants.choreStatus: status,
      if (dueDate != null) FirestoreConstants.choreDueDate: Timestamp.fromDate(dueDate!),
      FirestoreConstants.choreCreatedAt: Timestamp.fromDate(createdAt),
      if (completedAt != null) FirestoreConstants.choreCompletedAt: Timestamp.fromDate(completedAt!),
    };
  }

  /// Creates a copy with updated fields
  ChoreModel copyWith({
    String? id,
    String? title,
    String? description,
    int? pointValue,
    String? assignedTo,
    String? createdBy,
    String? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return ChoreModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointValue: pointValue ?? this.pointValue,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Checks if chore is active
  bool get isActive => status == 'active';

  /// Checks if chore is submitted
  bool get isSubmitted => status == 'submitted';

  /// Checks if chore is completed
  bool get isCompleted => status == 'completed';

  /// Checks if chore is rejected
  bool get isRejected => status == 'rejected';

  /// Checks if chore is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  @override
  String toString() {
    return 'ChoreModel(id: $id, title: $title, status: $status, points: $pointValue)';
  }
}
