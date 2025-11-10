/// Firestore collection and field name constants
class FirestoreConstants {
  // Collection Names
  static const String familiesCollection = 'families';
  static const String membersCollection = 'members';
  static const String choresCollection = 'chores';
  static const String submissionsCollection = 'submissions';

  // Family Fields
  static const String familyName = 'name';
  static const String familyCreatedBy = 'createdBy';
  static const String familyCreatedAt = 'createdAt';
  static const String familyMemberIds = 'memberIds';

  // Member Fields
  static const String memberName = 'name';
  static const String memberEmail = 'email';
  static const String memberRole = 'role';
  static const String memberTotalPoints = 'totalPoints';
  static const String memberAvatarUrl = 'avatarUrl';

  // Chore Fields
  static const String choreTitle = 'title';
  static const String choreDescription = 'description';
  static const String chorePointValue = 'pointValue';
  static const String choreAssignedTo = 'assignedTo';
  static const String choreCreatedBy = 'createdBy';
  static const String choreStatus = 'status';
  static const String choreDueDate = 'dueDate';
  static const String choreCreatedAt = 'createdAt';
  static const String choreCompletedAt = 'completedAt';

  // Submission Fields
  static const String submissionChoreId = 'choreId';
  static const String submissionSubmittedBy = 'submittedBy';
  static const String submissionImageUrl = 'imageUrl';
  static const String submissionStatus = 'status';
  static const String submissionSubmittedAt = 'submittedAt';
  static const String submissionReviewedAt = 'reviewedAt';
  static const String submissionReviewedBy = 'reviewedBy';
  static const String submissionReviewNotes = 'reviewNotes';

  // Storage Paths
  static String getSubmissionImagePath(String familyId, String submissionId, String filename) {
    return 'families/$familyId/submissions/$submissionId/$filename';
  }
}
