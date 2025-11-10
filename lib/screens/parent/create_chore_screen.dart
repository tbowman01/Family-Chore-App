import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/chore_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_constants.dart';

class CreateChoreScreen extends StatefulWidget {
  final String familyId;

  const CreateChoreScreen({
    super.key,
    required this.familyId,
  });

  @override
  State<CreateChoreScreen> createState() => _CreateChoreScreenState();
}

class _CreateChoreScreenState extends State<CreateChoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController(text: '10');

  String? _selectedChildId;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateChore() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedChildId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a child to assign this chore'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final choreProvider = context.read<ChoreProvider>();

    final success = await choreProvider.createChore(
      familyId: widget.familyId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      pointValue: int.parse(_pointsController.text),
      assignedTo: _selectedChildId!,
      createdBy: authProvider.firebaseUser!.uid,
      dueDate: _dueDate,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chore created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(choreProvider.error ?? 'Failed to create chore'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Chore'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Chore Title',
                    prefixIcon: Icon(Icons.title),
                    hintText: 'e.g., Clean your room',
                  ),
                  validator: Validators.validateChoreTitle,
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Add details about the chore',
                    alignLabelWithHint: true,
                  ),
                  validator: Validators.validateChoreDescription,
                ),
                const SizedBox(height: 16),

                // Points Field
                TextFormField(
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Points',
                    prefixIcon: Icon(Icons.star),
                    hintText: '10',
                  ),
                  validator: Validators.validatePoints,
                ),
                const SizedBox(height: 16),

                // Assign To Dropdown
                Consumer<FamilyProvider>(
                  builder: (context, familyProvider, _) {
                    final children = familyProvider.children;

                    if (children.isEmpty) {
                      return Card(
                        color: Colors.orange.shade50,
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No children in the family yet. Add children to assign chores.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      value: _selectedChildId,
                      decoration: const InputDecoration(
                        labelText: 'Assign To',
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: children.map((child) {
                        return DropdownMenuItem(
                          value: child.id,
                          child: Text(child.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedChildId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a child';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Due Date Selector
                InkWell(
                  onTap: _selectDueDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dueDate == null
                              ? 'No due date'
                              : '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}',
                        ),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _dueDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Create Button
                Consumer<ChoreProvider>(
                  builder: (context, choreProvider, _) {
                    return ElevatedButton(
                      onPressed: choreProvider.isLoading ? null : _handleCreateChore,
                      child: choreProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Create Chore'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
