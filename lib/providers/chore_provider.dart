import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../models/chore_model.dart';
import '../models/submission_model.dart';

/// Provider for managing chore state
class ChoreProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  List<ChoreModel> _chores = [];
  List<SubmissionModel> _pendingSubmissions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ChoreModel> get chores => _chores;
  List<ChoreModel> get activeChores => _chores.where((c) => c.isActive).toList();
  List<ChoreModel> get completedChores => _chores.where((c) => c.isCompleted).toList();
  List<SubmissionModel> get pendingSubmissions => _pendingSubmissions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Stream all family chores
  void streamFamilyChores(String familyId) {
    _firestoreService.getFamilyChores(familyId).listen(
      (chores) {
        _chores = chores;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Stream user's chores
  void streamUserChores(String familyId, String userId) {
    _firestoreService.getUserChores(familyId, userId).listen(
      (chores) {
        _chores = chores;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Stream pending submissions
  void streamPendingSubmissions(String familyId) {
    _firestoreService.getPendingSubmissions(familyId).listen(
      (submissions) {
        _pendingSubmissions = submissions;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Create a new chore
  Future<bool> createChore({
    required String familyId,
    required String title,
    required String description,
    required int pointValue,
    required String assignedTo,
    required String createdBy,
    DateTime? dueDate,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _firestoreService.createChore(
        familyId: familyId,
        title: title,
        description: description,
        pointValue: pointValue,
        assignedTo: assignedTo,
        createdBy: createdBy,
        dueDate: dueDate,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Update a chore
  Future<bool> updateChore({
    required String familyId,
    required String choreId,
    required Map<String, dynamic> data,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _firestoreService.updateChore(familyId, choreId, data);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Delete a chore
  Future<bool> deleteChore(String familyId, String choreId) async {
    _setLoading(true);
    _error = null;

    try {
      await _firestoreService.deleteChore(familyId, choreId);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Submit chore with photo
  Future<bool> submitChore({
    required String familyId,
    required String choreId,
    required String submittedBy,
    required File imageFile,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Generate submission ID
      final submissionId = _uuid.v4();

      // Upload image to Firebase Storage
      final imageUrl = await _storageService.uploadSubmissionImage(
        familyId: familyId,
        submissionId: submissionId,
        imageFile: imageFile,
      );

      // Create submission in Firestore
      await _firestoreService.createSubmission(
        familyId: familyId,
        choreId: choreId,
        submittedBy: submittedBy,
        imageUrl: imageUrl,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Approve submission
  Future<bool> approveSubmission({
    required String familyId,
    required String submissionId,
    required String choreId,
    required String reviewedBy,
    required String submittedBy,
    required int points,
    String? reviewNotes,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _firestoreService.approveSubmission(
        familyId: familyId,
        submissionId: submissionId,
        choreId: choreId,
        reviewedBy: reviewedBy,
        submittedBy: submittedBy,
        points: points,
        reviewNotes: reviewNotes,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Reject submission
  Future<bool> rejectSubmission({
    required String familyId,
    required String submissionId,
    required String choreId,
    required String reviewedBy,
    String? reviewNotes,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _firestoreService.rejectSubmission(
        familyId: familyId,
        submissionId: submissionId,
        choreId: choreId,
        reviewedBy: reviewedBy,
        reviewNotes: reviewNotes,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Get chore by ID
  ChoreModel? getChoreById(String choreId) {
    try {
      return _chores.firstWhere((chore) => chore.id == choreId);
    } catch (e) {
      return null;
    }
  }

  /// Get chores assigned to a specific user
  List<ChoreModel> getChoresForUser(String userId) {
    return _chores.where((chore) => chore.assignedTo == userId).toList();
  }

  /// Get submission for a chore
  Future<SubmissionModel?> getSubmissionForChore(String familyId, String choreId) async {
    try {
      return await _firestoreService.getSubmissionByChoreId(familyId, choreId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _chores = [];
    _pendingSubmissions = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
