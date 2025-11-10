import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/family_model.dart';
import '../models/user_model.dart';

/// Provider for managing family and member state
class FamilyProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  FamilyModel? _family;
  List<UserModel> _members = [];
  List<UserModel> _children = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  FamilyModel? get family => _family;
  List<UserModel> get members => _members;
  List<UserModel> get children => _children;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load family data
  Future<void> loadFamily(String familyId) async {
    _setLoading(true);
    _error = null;

    try {
      _family = await _firestoreService.getFamily(familyId);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Stream family members
  void streamFamilyMembers(String familyId) {
    _firestoreService.getFamilyMembers(familyId).listen(
      (members) {
        _members = members;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Stream children only
  void streamChildren(String familyId) {
    _firestoreService.getChildren(familyId).listen(
      (children) {
        _children = children;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Get member by ID
  UserModel? getMemberById(String memberId) {
    try {
      return _members.firstWhere((member) => member.id == memberId);
    } catch (e) {
      return null;
    }
  }

  /// Get member name by ID
  String getMemberName(String memberId) {
    final member = getMemberById(memberId);
    return member?.name ?? 'Unknown';
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
    _family = null;
    _members = [];
    _children = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
