import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/chore_provider.dart';
import '../../widgets/chore/chore_card.dart';
import 'chore_detail_screen.dart';

class ChildDashboard extends StatefulWidget {
  final String familyId;
  final String userId;

  const ChildDashboard({
    super.key,
    required this.familyId,
    required this.userId,
  });

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chores'),
        actions: [
          // Profile/Settings
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'profile') {
                // TODO: Navigate to profile
              } else if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Points Banner
          _buildPointsBanner(),

          // Filter Chips
          _buildFilterChips(),

          // Chores List
          Expanded(child: _buildChoresList()),
        ],
      ),
    );
  }

  Widget _buildPointsBanner() {
    return Consumer<FamilyProvider>(
      builder: (context, familyProvider, _) {
        final user = familyProvider.getMemberById(widget.userId);
        final points = user?.totalPoints ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6200EE),
                const Color(0xFF6200EE).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Total Points',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFF03DAC6),
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            value: 'all',
            selectedValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Active',
            value: 'active',
            selectedValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Submitted',
            value: 'submitted',
            selectedValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completed',
            value: 'completed',
            selectedValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChoresList() {
    return Consumer<ChoreProvider>(
      builder: (context, choreProvider, _) {
        if (choreProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var chores = choreProvider.chores;

        // Apply filter
        if (_selectedFilter != 'all') {
          chores = chores.where((chore) => chore.status == _selectedFilter).toList();
        }

        if (chores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFilter == 'all'
                      ? 'No chores assigned yet'
                      : 'No ${_selectedFilter} chores',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new assignments',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Refresh is handled by streams
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chores.length,
            itemBuilder: (context, index) {
              final chore = chores[index];

              return ChoreCard(
                chore: chore,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChoreDetailScreen(
                        familyId: widget.familyId,
                        userId: widget.userId,
                        chore: chore,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().signOut();
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Function(String) onSelected;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF6200EE).withOpacity(0.2),
      checkmarkColor: const Color(0xFF6200EE),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF6200EE) : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
