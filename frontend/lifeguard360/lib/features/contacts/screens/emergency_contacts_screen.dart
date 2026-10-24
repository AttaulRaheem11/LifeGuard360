import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../models/emergency_contact_model.dart';

/// Screen 9 of 16: Emergency Contacts Screen.
/// Manage prioritized circle of trusted responders receiving SMS and Push alerts.
class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<EmergencyContactModel> _contacts = [
    EmergencyContactModel(
      id: 1,
      contactName: 'Sarah Jenkins',
      phoneNumber: '+14155552671',
      relationship: 'Spouse',
      priorityOrder: 1,
      notifySms: true,
      notifyPush: true,
    ),
    EmergencyContactModel(
      id: 2,
      contactName: 'Dr. Robert Jenkins',
      phoneNumber: '+14155552672',
      relationship: 'Parent',
      priorityOrder: 2,
      notifySms: true,
      notifyPush: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkNavy,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.emergencyRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Contact', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addEditContact),
      ),
      body: SafeArea(
        child: _contacts.isEmpty
            ? EmptyStateWidget(
                icon: Icons.contact_emergency_rounded,
                title: 'No Emergency Contacts Added',
                message: 'Add at least one trusted contact to receive automated distress alerts and SMS dispatches.',
                actionButtonText: 'Add First Contact',
                onAction: () => Navigator.of(context).pushNamed(AppRoutes.addEditContact),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.emergencyRed.withOpacity(0.15),
                                child: Text(
                                  '#${contact.priorityOrder}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.emergencyRed,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.contactName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${contact.relationship} • ${contact.phoneNumber}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppTheme.textMuted, size: 20),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.addEditContact,
                                    arguments: contact,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildChannelChip('SMS Dispatch', contact.notifySms),
                              const SizedBox(width: 8),
                              _buildChannelChip('Push Notification', contact.notifyPush),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildChannelChip(String label, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isEnabled
            ? AppTheme.safeEmerald.withOpacity(0.15)
            : AppTheme.slateBorder.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isEnabled ? AppTheme.safeEmerald : AppTheme.slateBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnabled ? Icons.check_circle_rounded : Icons.cancel_outlined,
            size: 12,
            color: isEnabled ? AppTheme.safeEmerald : AppTheme.textMuted,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isEnabled ? AppTheme.safeEmeraldLight : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
