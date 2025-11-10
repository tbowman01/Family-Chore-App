import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';

/// Represents a chore submission (photo proof)
class SubmissionModel {
  final String id;
  final String choreId;
  final String submittedBy;
  final String imageUrl;
  final String status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? reviewNotes;

  SubmissionModel({
    required this.id,
    required this.choreId,
    required this.submittedBy,
    required this.imageUrl,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.reviewNotes,
  });

  /// Creates a SubmissionModel from Firestore document
  factory SubmissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubmissionModel(
      id: doc.id,
      choreId: data[FirestoreConstants.submissionChoreId] ?? '',
      submittedBy: data[FirestoreConstants.submissionSubmittedBy] ?? '',
      imageUrl: data[FirestoreConstants.submissionImageUrl] ?? '',
      status: data[FirestoreConstants.submissionStatus] ?? 'pending',
      submittedAt: (data[FirestoreConstants.submissionSubmittedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (data[FirestoreConstants.submissionReviewedAt] as Timestamp?)?.toDate(),
      reviewedBy: data[FirestoreConstants.submissionReviewedBy],
      reviewNotes: data[FirestoreConstants.submissionReviewNotes],
    );
  }

  /// Creates a SubmissionModel from a Map
  factory SubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return SubmissionModel(
      id: id,
      choreId: map[FirestoreConstants.submissionChoreId] ?? '',
      submittedBy: map[FirestoreConstants.submissionSubmittedBy] ?? '',
      imageUrl: map[FirestoreConstants.submissionImageUrl] ?? '',
      status: map[FirestoreConstants.submissionStatus] ?? 'pending',
      submittedAt: (map[FirestoreConstants.submissionSubmittedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (map[FirestoreConstants.submissionReviewedAt] as Timestamp?)?.toDate(),
      reviewedBy: map[FirestoreConstants.submissionReviewedBy],
      reviewNotes: map[FirestoreConstants.submissionReviewNotes],
    );
  }

  /// Converts SubmissionModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.submissionChoreId: choreId,
      FirestoreConstants.submissionSubmittedBy: submittedBy,
      FirestoreConstants.submissionImageUrl: imageUrl,
      FirestoreConstants.submissionStatus: status,
      FirestoreConstants.submissionSubmittedAt: Timestamp.fromDate(submittedAt),
      if (reviewedAt != null) FirestoreConstants.submissionReviewedAt: Timestamp.fromDate(reviewedAt!),
      if (reviewedBy != null) FirestoreConstants.submissionReviewedBy: reviewedBy,
      if (reviewNotes != null) FirestoreConstants.submissionReviewNotes: reviewNotes,
    };
  }

  /// Creates a copy with updated fields
  SubmissionModel copyWith({
    String? id,
    String? choreId,
    String? submittedBy,
    String? imageUrl,
    String? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? reviewNotes,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      choreId: choreId ?? this.choreId,
      submittedBy: submittedBy ?? this.submittedBy,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewNotes: reviewNotes ?? this.reviewNotes,
    );
  }

  /// Checks if submission is pending review
  bool get isPending => status == 'pending';

  /// Checks if submission is approved
  bool get isApproved => status == 'approved';

  /// Checks if submission is rejected
  bool get isRejected => status == 'rejected';

  @override
  String toString() {
    return 'SubmissionModel(id: $id, choreId: $choreId, status: $status)';
  }
}
