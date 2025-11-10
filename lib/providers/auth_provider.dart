import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

/// Provider for managing authentication state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;
  String? _familyId;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  String? get familyId => _familyId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _firebaseUser != null;
  bool get hasCompletedSetup => _userModel != null && _familyId != null;

  /// Initialize auth state listener
  void initialize() {
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData();
      } else {
        _userModel = null;
        _familyId = null;
      }
      notifyListeners();
    });
  }

  /// Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_firebaseUser == null) return;

    try {
      // TODO: Implement logic to find user's family
      // For now, we'll need to store familyId in SharedPreferences or similar
      // This is a temporary implementation
    } catch (e) {
      _error = 'Failed to load user data: $e';
      notifyListeners();
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      await _authService.updateDisplayName(name);
      _firebaseUser = userCredential.user;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _firebaseUser = userCredential.user;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      _firebaseUser = null;
      _userModel = null;
      _familyId = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
    notifyListeners();
  }

  /// Create family and member profile
  Future<bool> createFamilyAndProfile({
    required String familyName,
    required String userName,
    required String role,
  }) async {
    if (_firebaseUser == null) {
      _error = 'No user logged in';
      return false;
    }

    _setLoading(true);
    _error = null;

    try {
      // Create family
      final familyId = await _firestoreService.createFamily(
        familyName: familyName,
        createdBy: _firebaseUser!.uid,
      );

      // Create member profile
      await _firestoreService.createMember(
        familyId: familyId,
        userId: _firebaseUser!.uid,
        name: userName,
        email: _firebaseUser!.email!,
        role: role,
      );

      // Store family ID (in a real app, use SharedPreferences)
      _familyId = familyId;

      // Load user model
      _userModel = await _firestoreService.getMember(familyId, _firebaseUser!.uid);

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Join existing family
  Future<bool> joinFamily({
    required String familyId,
    required String userName,
    required String role,
  }) async {
    if (_firebaseUser == null) {
      _error = 'No user logged in';
      return false;
    }

    _setLoading(true);
    _error = null;

    try {
      // Create member profile
      await _firestoreService.createMember(
        familyId: familyId,
        userId: _firebaseUser!.uid,
        name: userName,
        email: _firebaseUser!.email!,
        role: role,
      );

      // Add member to family
      await _firestoreService.addMemberToFamily(familyId, _firebaseUser!.uid);

      // Store family ID
      _familyId = familyId;

      // Load user model
      _userModel = await _firestoreService.getMember(familyId, _firebaseUser!.uid);

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Set family ID (for navigation after setup)
  void setFamilyId(String familyId) {
    _familyId = familyId;
    notifyListeners();
  }

  /// Set user model (for navigation after setup)
  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
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
}
