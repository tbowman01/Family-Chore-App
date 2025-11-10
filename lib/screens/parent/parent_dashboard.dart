import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/chore_provider.dart';
import '../../widgets/chore/chore_card.dart';
import 'create_chore_screen.dart';
import 'submission_review_screen.dart';

class ParentDashboard extends StatefulWidget {
  final String familyId;
  final String userId;

  const ParentDashboard({
    super.key,
    required this.familyId,
    required this.userId,
  });

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          // Notifications Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              Consumer<ChoreProvider>(
                builder: (context, choreProvider, _) {
                  final pendingCount = choreProvider.pendingSubmissions.length;
                  if (pendingCount == 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$pendingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // Settings
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'profile') {
                // TODO: Navigate to profile
              } else if (value == 'family') {
                _showFamilyInfo();
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
                value: 'family',
                child: Row(
                  children: [
                    Icon(Icons.family_restroom, size: 20),
                    SizedBox(width: 12),
                    Text('Family Info'),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildChoresTab(),
          _buildReviewsTab(),
          _buildFamilyTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Chores',
          ),
          NavigationDestination(
            icon: _buildReviewBadge(),
            selectedIcon: _buildReviewBadge(selected: true),
            label: 'Reviews',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Family',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateChoreScreen(familyId: widget.familyId),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Chore'),
            )
          : null,
    );
  }

  Widget _buildReviewBadge({bool selected = false}) {
    return Consumer<ChoreProvider>(
      builder: (context, choreProvider, child) {
        final pendingCount = choreProvider.pendingSubmissions.length;

        return Badge(
          isLabelVisible: pendingCount > 0,
          label: Text('$pendingCount'),
          child: Icon(
            selected ? Icons.rate_review : Icons.rate_review_outlined,
          ),
        );
      },
    );
  }

  Widget _buildChoresTab() {
    return Consumer2<ChoreProvider, FamilyProvider>(
      builder: (context, choreProvider, familyProvider, _) {
        if (choreProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final chores = choreProvider.chores;

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
                  'No chores yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first chore to get started',
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
              final assignedToName = familyProvider.getMemberName(chore.assignedTo);

              return ChoreCard(
                chore: chore,
                assignedToName: assignedToName,
                showActions: true,
                onTap: () {
                  // TODO: Navigate to chore details
                },
                onEdit: () {
                  // TODO: Navigate to edit chore
                },
                onDelete: () async {
                  final success = await choreProvider.deleteChore(
                    widget.familyId,
                    chore.id,
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Chore deleted'
                              : 'Failed to delete chore',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return SubmissionReviewScreen(
      familyId: widget.familyId,
      userId: widget.userId,
    );
  }

  Widget _buildFamilyTab() {
    return Consumer<FamilyProvider>(
      builder: (context, familyProvider, _) {
        final members = familyProvider.members;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Family Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Family Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...members.map((member) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF6200EE),
                          child: Text(
                            member.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(member.name),
                        subtitle: Text(member.email),
                        trailing: Chip(
                          label: Text(
                            member.role == 'parent' ? 'Parent' : 'Child',
                          ),
                          backgroundColor: member.role == 'parent'
                              ? const Color(0xFF6200EE).withOpacity(0.1)
                              : const Color(0xFF03DAC6).withOpacity(0.1),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Invite Members Button
            OutlinedButton.icon(
              onPressed: () {
                _showInviteDialog();
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Invite Family Member'),
            ),
          ],
        );
      },
    );
  }

  void _showFamilyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Family Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Family ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            SelectableText(widget.familyId),
            const SizedBox(height: 16),
            const Text(
              'Share this ID with family members so they can join.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Share this Family ID:'),
            const SizedBox(height: 8),
            SelectableText(
              widget.familyId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'New members can use this ID to join your family during signup.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
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
