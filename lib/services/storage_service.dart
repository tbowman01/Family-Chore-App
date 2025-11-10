import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_constants.dart';

/// Service for handling Firebase Storage operations
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Upload image for chore submission
  Future<String> uploadSubmissionImage({
    required String familyId,
    required String submissionId,
    required File imageFile,
  }) async {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '$timestamp.jpg';

      // Create storage path
      final path = FirestoreConstants.getSubmissionImagePath(
        familyId,
        submissionId,
        filename,
      );

      // Upload file
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'familyId': familyId,
            'submissionId': submissionId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete submission image
  Future<void> deleteSubmissionImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      // Ignore error if file doesn't exist
      if (e.code != 'object-not-found') {
        throw Exception('Failed to delete image: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get upload progress stream
  Stream<TaskSnapshot> uploadSubmissionImageWithProgress({
    required String familyId,
    required String submissionId,
    required File imageFile,
  }) {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '$timestamp.jpg';

      // Create storage path
      final path = FirestoreConstants.getSubmissionImagePath(
        familyId,
        submissionId,
        filename,
      );

      // Upload file
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'familyId': familyId,
            'submissionId': submissionId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      return uploadTask.snapshotEvents;
    } catch (e) {
      throw Exception('Failed to start upload: $e');
    }
  }

  /// Get image download URL from storage path
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get download URL: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Check if file exists in storage
  Future<bool> fileExists(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false;
      }
      rethrow;
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get file metadata: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }
}
