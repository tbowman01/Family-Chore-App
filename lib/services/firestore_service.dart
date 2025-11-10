import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_constants.dart';
import '../models/family_model.dart';
import '../models/user_model.dart';
import '../models/chore_model.dart';
import '../models/submission_model.dart';

/// Service for handling Firestore database operations
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== Family Operations ====================

  /// Create a new family
  Future<String> createFamily({
    required String familyName,
    required String createdBy,
  }) async {
    try {
      final familyRef = await _db.collection(FirestoreConstants.familiesCollection).add({
        FirestoreConstants.familyName: familyName,
        FirestoreConstants.familyCreatedBy: createdBy,
        FirestoreConstants.familyCreatedAt: FieldValue.serverTimestamp(),
        FirestoreConstants.familyMemberIds: [createdBy],
      });
      return familyRef.id;
    } catch (e) {
      throw Exception('Failed to create family: $e');
    }
  }

  /// Get family by ID
  Future<FamilyModel?> getFamily(String familyId) async {
    try {
      final doc = await _db.collection(FirestoreConstants.familiesCollection).doc(familyId).get();
      if (!doc.exists) return null;
      return FamilyModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get family: $e');
    }
  }

  /// Update family
  Future<void> updateFamily(String familyId, Map<String, dynamic> data) async {
    try {
      await _db.collection(FirestoreConstants.familiesCollection).doc(familyId).update(data);
    } catch (e) {
      throw Exception('Failed to update family: $e');
    }
  }

  /// Add member to family
  Future<void> addMemberToFamily(String familyId, String userId) async {
    try {
      await _db.collection(FirestoreConstants.familiesCollection).doc(familyId).update({
        FirestoreConstants.familyMemberIds: FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to add member to family: $e');
    }
  }

  // ==================== Member Operations ====================

  /// Create a new member
  Future<void> createMember({
    required String familyId,
    required String userId,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.membersCollection)
          .doc(userId)
          .set({
        FirestoreConstants.memberName: name,
        FirestoreConstants.memberEmail: email,
        FirestoreConstants.memberRole: role,
        FirestoreConstants.memberTotalPoints: 0,
      });
    } catch (e) {
      throw Exception('Failed to create member: $e');
    }
  }

  /// Get member by ID
  Future<UserModel?> getMember(String familyId, String userId) async {
    try {
      final doc = await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.membersCollection)
          .doc(userId)
          .get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get member: $e');
    }
  }

  /// Get all members of a family
  Stream<List<UserModel>> getFamilyMembers(String familyId) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.membersCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  /// Get children only
  Stream<List<UserModel>> getChildren(String familyId) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.membersCollection)
        .where(FirestoreConstants.memberRole, isEqualTo: 'child')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  /// Update member points
  Future<void> updateMemberPoints(String familyId, String userId, int points) async {
    try {
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.membersCollection)
          .doc(userId)
          .update({
        FirestoreConstants.memberTotalPoints: FieldValue.increment(points),
      });
    } catch (e) {
      throw Exception('Failed to update member points: $e');
    }
  }

  // ==================== Chore Operations ====================

  /// Create a new chore
  Future<String> createChore({
    required String familyId,
    required String title,
    required String description,
    required int pointValue,
    required String assignedTo,
    required String createdBy,
    DateTime? dueDate,
  }) async {
    try {
      final choreRef = await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.choresCollection)
          .add({
        FirestoreConstants.choreTitle: title,
        FirestoreConstants.choreDescription: description,
        FirestoreConstants.chorePointValue: pointValue,
        FirestoreConstants.choreAssignedTo: assignedTo,
        FirestoreConstants.choreCreatedBy: createdBy,
        FirestoreConstants.choreStatus: 'active',
        if (dueDate != null) FirestoreConstants.choreDueDate: Timestamp.fromDate(dueDate),
        FirestoreConstants.choreCreatedAt: FieldValue.serverTimestamp(),
      });
      return choreRef.id;
    } catch (e) {
      throw Exception('Failed to create chore: $e');
    }
  }

  /// Get chore by ID
  Future<ChoreModel?> getChore(String familyId, String choreId) async {
    try {
      final doc = await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.choresCollection)
          .doc(choreId)
          .get();
      if (!doc.exists) return null;
      return ChoreModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get chore: $e');
    }
  }

  /// Get all chores for a family
  Stream<List<ChoreModel>> getFamilyChores(String familyId) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.choresCollection)
        .orderBy(FirestoreConstants.choreCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChoreModel.fromFirestore(doc)).toList());
  }

  /// Get chores assigned to a specific user
  Stream<List<ChoreModel>> getUserChores(String familyId, String userId) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.choresCollection)
        .where(FirestoreConstants.choreAssignedTo, isEqualTo: userId)
        .orderBy(FirestoreConstants.choreCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChoreModel.fromFirestore(doc)).toList());
  }

  /// Get chores by status
  Stream<List<ChoreModel>> getChoresByStatus(String familyId, String status) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.choresCollection)
        .where(FirestoreConstants.choreStatus, isEqualTo: status)
        .orderBy(FirestoreConstants.choreCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChoreModel.fromFirestore(doc)).toList());
  }

  /// Update chore
  Future<void> updateChore(String familyId, String choreId, Map<String, dynamic> data) async {
    try {
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.choresCollection)
          .doc(choreId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update chore: $e');
    }
  }

  /// Update chore status
  Future<void> updateChoreStatus(String familyId, String choreId, String status) async {
    try {
      final updateData = {
        FirestoreConstants.choreStatus: status,
      };
      if (status == 'completed') {
        updateData[FirestoreConstants.choreCompletedAt] = FieldValue.serverTimestamp();
      }
      await updateChore(familyId, choreId, updateData);
    } catch (e) {
      throw Exception('Failed to update chore status: $e');
    }
  }

  /// Delete chore
  Future<void> deleteChore(String familyId, String choreId) async {
    try {
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.choresCollection)
          .doc(choreId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete chore: $e');
    }
  }

  // ==================== Submission Operations ====================

  /// Create a new submission
  Future<String> createSubmission({
    required String familyId,
    required String choreId,
    required String submittedBy,
    required String imageUrl,
  }) async {
    try {
      final submissionRef = await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.submissionsCollection)
          .add({
        FirestoreConstants.submissionChoreId: choreId,
        FirestoreConstants.submissionSubmittedBy: submittedBy,
        FirestoreConstants.submissionImageUrl: imageUrl,
        FirestoreConstants.submissionStatus: 'pending',
        FirestoreConstants.submissionSubmittedAt: FieldValue.serverTimestamp(),
      });

      // Update chore status to 'submitted'
      await updateChoreStatus(familyId, choreId, 'submitted');

      return submissionRef.id;
    } catch (e) {
      throw Exception('Failed to create submission: $e');
    }
  }

  /// Get submission by chore ID
  Future<SubmissionModel?> getSubmissionByChoreId(String familyId, String choreId) async {
    try {
      final querySnapshot = await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.submissionsCollection)
          .where(FirestoreConstants.submissionChoreId, isEqualTo: choreId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return SubmissionModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get submission: $e');
    }
  }

  /// Get all pending submissions
  Stream<List<SubmissionModel>> getPendingSubmissions(String familyId) {
    return _db
        .collection(FirestoreConstants.familiesCollection)
        .doc(familyId)
        .collection(FirestoreConstants.submissionsCollection)
        .where(FirestoreConstants.submissionStatus, isEqualTo: 'pending')
        .orderBy(FirestoreConstants.submissionSubmittedAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => SubmissionModel.fromFirestore(doc)).toList());
  }

  /// Approve submission
  Future<void> approveSubmission({
    required String familyId,
    required String submissionId,
    required String choreId,
    required String reviewedBy,
    required String submittedBy,
    required int points,
    String? reviewNotes,
  }) async {
    try {
      // Update submission status
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.submissionsCollection)
          .doc(submissionId)
          .update({
        FirestoreConstants.submissionStatus: 'approved',
        FirestoreConstants.submissionReviewedBy: reviewedBy,
        FirestoreConstants.submissionReviewedAt: FieldValue.serverTimestamp(),
        if (reviewNotes != null) FirestoreConstants.submissionReviewNotes: reviewNotes,
      });

      // Update chore status to completed
      await updateChoreStatus(familyId, choreId, 'completed');

      // Award points to child
      await updateMemberPoints(familyId, submittedBy, points);
    } catch (e) {
      throw Exception('Failed to approve submission: $e');
    }
  }

  /// Reject submission
  Future<void> rejectSubmission({
    required String familyId,
    required String submissionId,
    required String choreId,
    required String reviewedBy,
    String? reviewNotes,
  }) async {
    try {
      // Update submission status
      await _db
          .collection(FirestoreConstants.familiesCollection)
          .doc(familyId)
          .collection(FirestoreConstants.submissionsCollection)
          .doc(submissionId)
          .update({
        FirestoreConstants.submissionStatus: 'rejected',
        FirestoreConstants.submissionReviewedBy: reviewedBy,
        FirestoreConstants.submissionReviewedAt: FieldValue.serverTimestamp(),
        if (reviewNotes != null) FirestoreConstants.submissionReviewNotes: reviewNotes,
      });

      // Update chore status back to active
      await updateChoreStatus(familyId, choreId, 'rejected');
    } catch (e) {
      throw Exception('Failed to reject submission: $e');
    }
  }
}
