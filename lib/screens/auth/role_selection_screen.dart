import 'package:flutter/material.dart';
import 'family_setup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const RoleSelectionScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  void _handleContinue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your role'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FamilySetupScreen(
          userName: widget.userName,
          userEmail: widget.userEmail,
          userRole: _selectedRole!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Welcome Text
              Text(
                'Welcome, ${widget.userName}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'How will you be using Family Chores?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),

              // Parent Role Card
              _RoleCard(
                icon: Icons.person,
                title: 'Parent',
                description:
                    'Create and assign chores, review submissions, and manage rewards',
                isSelected: _selectedRole == 'parent',
                onTap: () {
                  setState(() {
                    _selectedRole = 'parent';
                  });
                },
              ),
              const SizedBox(height: 16),

              // Child Role Card
              _RoleCard(
                icon: Icons.child_care,
                title: 'Child',
                description:
                    'View assigned chores, submit proof of completion, and earn rewards',
                isSelected: _selectedRole == 'child',
                onTap: () {
                  setState(() {
                    _selectedRole = 'child';
                  });
                },
              ),

              const Spacer(),

              // Continue Button
              ElevatedButton(
                onPressed: _handleContinue,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6200EE)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? const Color(0xFF6200EE).withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6200EE)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF6200EE)
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF6200EE),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
