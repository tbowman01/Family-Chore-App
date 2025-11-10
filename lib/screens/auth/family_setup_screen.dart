import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/chore_provider.dart';
import '../../core/utils/validators.dart';

class FamilySetupScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userRole;

  const FamilySetupScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
  });

  @override
  State<FamilySetupScreen> createState() => _FamilySetupScreenState();
}

class _FamilySetupScreenState extends State<FamilySetupScreen> {
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _familyIdController = TextEditingController();
  bool _isCreatingFamily = true;

  @override
  void dispose() {
    _familyNameController.dispose();
    _familyIdController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateFamily() async {
    if (!_createFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();
    final choreProvider = context.read<ChoreProvider>();

    final success = await authProvider.createFamilyAndProfile(
      familyName: _familyNameController.text.trim(),
      userName: widget.userName,
      role: widget.userRole,
    );

    if (!mounted) return;

    if (success) {
      // Initialize family and chore providers
      final familyId = authProvider.familyId!;
      final userId = authProvider.firebaseUser!.uid;

      familyProvider.streamFamilyMembers(familyId);
      familyProvider.streamChildren(familyId);

      if (widget.userRole == 'parent') {
        choreProvider.streamFamilyChores(familyId);
        choreProvider.streamPendingSubmissions(familyId);
      } else {
        choreProvider.streamUserChores(familyId, userId);
      }

      // Navigation will happen automatically via auth state change
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to create family'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleJoinFamily() async {
    if (!_joinFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();
    final choreProvider = context.read<ChoreProvider>();

    final success = await authProvider.joinFamily(
      familyId: _familyIdController.text.trim(),
      userName: widget.userName,
      role: widget.userRole,
    );

    if (!mounted) return;

    if (success) {
      // Initialize family and chore providers
      final familyId = authProvider.familyId!;
      final userId = authProvider.firebaseUser!.uid;

      familyProvider.streamFamilyMembers(familyId);
      familyProvider.streamChildren(familyId);

      if (widget.userRole == 'parent') {
        choreProvider.streamFamilyChores(familyId);
        choreProvider.streamPendingSubmissions(familyId);
      } else {
        choreProvider.streamUserChores(familyId, userId);
      }

      // Navigation will happen automatically via auth state change
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to join family'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Setup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Title
              const Text(
                'Set Up Your Family',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a new family or join an existing one',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Toggle Buttons
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Create Family'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Join Family'),
                    icon: Icon(Icons.group_add),
                  ),
                ],
                selected: {_isCreatingFamily},
                onSelectionChanged: (Set<bool> selected) {
                  setState(() {
                    _isCreatingFamily = selected.first;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Create or Join Form
              _isCreatingFamily ? _buildCreateForm() : _buildJoinForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Form(
      key: _createFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6200EE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xFF6200EE),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You\'ll be able to invite family members after setup',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Family Name Field
          TextFormField(
            controller: _familyNameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleCreateFamily(),
            decoration: const InputDecoration(
              labelText: 'Family Name',
              prefixIcon: Icon(Icons.home),
              hintText: 'e.g., Smith Family',
            ),
            validator: (value) =>
                Validators.validateRequired(value, 'Family name'),
          ),
          const SizedBox(height: 24),

          // Create Button
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return ElevatedButton(
                onPressed: authProvider.isLoading ? null : _handleCreateFamily,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Create Family'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJoinForm() {
    return Form(
      key: _joinFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6200EE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xFF6200EE),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ask your family admin for the Family ID',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Family ID Field
          TextFormField(
            controller: _familyIdController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleJoinFamily(),
            decoration: const InputDecoration(
              labelText: 'Family ID',
              prefixIcon: Icon(Icons.key),
              hintText: 'Enter the Family ID',
            ),
            validator: (value) =>
                Validators.validateRequired(value, 'Family ID'),
          ),
          const SizedBox(height: 24),

          // Join Button
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return ElevatedButton(
                onPressed: authProvider.isLoading ? null : _handleJoinFamily,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Join Family'),
              );
            },
          ),
        ],
      ),
    );
  }
}
