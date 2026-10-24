import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/emergency_contact_model.dart';

/// Screen 10 of 16: Add / Edit Contact Screen.
/// Form for adding or editing a trusted emergency contact with notification channels.
class AddEditContactScreen extends StatefulWidget {
  final EmergencyContactModel? contactToEdit;

  const AddEditContactScreen({super.key, this.contactToEdit});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late String _relationship;
  late int _priorityOrder;
  late bool _notifySms;
  late bool _notifyPush;
  bool _isLoading = false;

  final List<String> _relationships = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Colleague',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.contactToEdit;
    _nameController = TextEditingController(text: c?.contactName ?? '');
    _phoneController = TextEditingController(text: c?.phoneNumber ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _relationship = c?.relationship ?? 'Parent';
    _priorityOrder = c?.priorityOrder ?? 1;
    _notifySms = c?.notifySms ?? true;
    _notifyPush = c?.notifyPush ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency contact ${_nameController.text.trim()} saved successfully'),
          backgroundColor: AppTheme.safeEmerald,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contactToEdit != null;

    return Scaffold(
      backgroundColor: AppTheme.darkNavy,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'Add Emergency Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name
                TextFormField(
                  key: const Key('contact_name_field'),
                  controller: _nameController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Contact Full Name',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Contact name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Phone
                TextFormField(
                  key: const Key('contact_phone_field'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (E.164 Format)',
                    hintText: '+14155552671',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.textSecondary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Phone number is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Relationship Dropdown
                DropdownButtonFormField<String>(
                  value: _relationship,
                  dropdownColor: AppTheme.deepSlate,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    prefixIcon: Icon(Icons.group_outlined, color: AppTheme.textSecondary),
                  ),
                  items: _relationships.map((rel) {
                    return DropdownMenuItem(value: rel, child: Text(rel));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _relationship = val);
                  },
                ),
                const SizedBox(height: 14),

                // Priority Order Dropdown
                DropdownButtonFormField<int>(
                  value: _priorityOrder,
                  dropdownColor: AppTheme.deepSlate,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Alert Priority (1 = First Responder)',
                    prefixIcon: Icon(Icons.format_list_numbered, color: AppTheme.textSecondary),
                  ),
                  items: [1, 2, 3, 4, 5].map((p) {
                    return DropdownMenuItem(value: p, child: Text('Priority #$p'));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _priorityOrder = val);
                  },
                ),
                const SizedBox(height: 14),

                // Optional Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Email Address (Optional)',
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 20),

                // Channels Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notification Dispatch Channels',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Send SMS Distres Alerts',
                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          value: _notifySms,
                          activeColor: AppTheme.safeEmerald,
                          onChanged: (val) => setState(() => _notifySms = val),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Send Push Notifications',
                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          value: _notifyPush,
                          activeColor: AppTheme.safeEmerald,
                          onChanged: (val) => setState(() => _notifyPush = val),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  key: const Key('save_contact_button'),
                  text: isEditing ? 'Update Contact' : 'Save Emergency Contact',
                  isLoading: _isLoading,
                  onPressed: _saveContact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
