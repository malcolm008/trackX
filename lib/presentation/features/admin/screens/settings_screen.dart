import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = true;
  bool _twoFactorEnabled = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  String _selectedTheme = 'system';
  String _selectedLanguage = 'en';
  String _selectedTimezone = 'UTC';

  final List<Map<String, dynamic>> _settingsSections = [
    {
      'title': 'General',
      'icon': Icons.settings,
      'color': Colors.blue,
      'items': [
        {'title': 'System Name', 'value': 'School Transport System', 'type': 'text'},
        {'title': 'Contact Email', 'value': 'admin@schoolsystem.com', 'type': 'text'},
        {'title': 'Contact Phone', 'value': '+1 (555) 123-4567', 'type': 'text'},
        {'title': 'Support Hours', 'value': '9 AM - 5 PM', 'type': 'text'},
      ],
    },
    {
      'title': 'Appearance',
      'icon': Icons.palette,
      'color': Colors.purple,
      'items': [
        {'title': 'Theme', 'type': 'dropdown', 'options': ['Light', 'Dark', 'System']},
        {'title': 'Language', 'type': 'dropdown', 'options': ['English', 'Spanish', 'French']},
        {'title': 'Time Zone', 'type': 'dropdown', 'options': ['UTC', 'EST', 'PST', 'GMT']},
      ],
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications,
      'color': Colors.orange,
      'items': [
        {'title': 'Email Notifications', 'type': 'switch', 'value': true},
        {'title': 'Push Notifications', 'type': 'switch', 'value': true},
        {'title': 'SMS Notifications', 'type': 'switch', 'value': false},
        {'title': 'Notification Sound', 'type': 'switch', 'value': true},
      ],
    },
    {
      'title': 'Security',
      'icon': Icons.security,
      'color': Colors.red,
      'items': [
        {'title': 'Two-Factor Authentication', 'type': 'switch', 'value': false},
        {'title': 'Auto Logout', 'type': 'switch', 'value': true},
        {'title': 'Password Policy', 'type': 'text', 'value': 'Strong (12+ chars)'},
        {'title': 'Session Timeout', 'type': 'dropdown', 'options': ['15 min', '30 min', '1 hour', '4 hours']},
      ],
    },
    {
      'title': 'Billing',
      'icon': Icons.payment,
      'color': Colors.green,
      'items': [
        {'title': 'Currency', 'type': 'dropdown', 'options': ['USD', 'EUR', 'GBP', 'CAD']},
        {'title': 'Tax Rate', 'type': 'text', 'value': '8.5%'},
        {'title': 'Auto Invoice', 'type': 'switch', 'value': true},
        {'title': 'Payment Methods', 'type': 'text', 'value': 'Card, Bank Transfer'},
      ],
    },
    {
      'title': 'System',
      'icon': Icons.build,
      'color': Colors.grey,
      'items': [
        {'title': 'Auto Backup', 'type': 'switch', 'value': true},
        {'title': 'Backup Frequency', 'type': 'dropdown', 'options': ['Daily', 'Weekly', 'Monthly']},
        {'title': 'Log Retention', 'type': 'dropdown', 'options': ['30 days', '90 days', '1 year']},
        {'title': 'API Rate Limit', 'type': 'text', 'value': '1000 requests/hour'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configure system preferences and administration settings',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Desktop Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.4,
            ),
            itemCount: _settingsSections.length,
            itemBuilder: (context, index) {
              final section = _settingsSections[index];
              return _buildSettingsSection(section, context, true);
            },
          ),
        ),

        // Save Button
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Reset to defaults
                },
                child: const Text('Reset to Defaults'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Settings',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure system preferences and administration settings',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mobile/Tablet List
            ..._settingsSections.map((section) {
              return _buildSettingsSection(section, context, false);
            }).toList(),

            const SizedBox(height: 24),

            // Save Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Reset to defaults
                  },
                  child: const Text('Reset to Defaults'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings saved successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(Map<String, dynamic> section, BuildContext context, bool isDesktop) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Card(
      margin: EdgeInsets.only(bottom: isDesktop ? 0 : 16),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : (isTablet ? 14 : 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 8 : 6),
                  decoration: BoxDecoration(
                    color: section['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    section['icon'],
                    color: section['color'],
                    size: isDesktop ? 20 : 18,
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 10),
                Text(
                  section['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 18 : (isTablet ? 16 : 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 16 : 12),

            // Settings Items
            ...List.generate(section['items'].length, (index) {
              final item = section['items'][index];
              return Padding(
                padding: EdgeInsets.only(bottom: isDesktop ? 12 : 10),
                child: _buildSettingsItem(item, isDesktop, isTablet),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(Map<String, dynamic> item, bool isDesktop, bool isTablet) {
    switch (item['type']) {
      case 'switch':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['title'],
              style: TextStyle(fontSize: isDesktop ? 14 : (isTablet ? 13 : 12)),
            ),
            Switch(
              value: item['value'] as bool,
              onChanged: (value) {},
            ),
          ],
        );
      case 'dropdown':
      // Fixed: Explicitly type the map function
        final List<String> options = (item['options'] as List<dynamic>).cast<String>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['title'],
              style: TextStyle(fontSize: isDesktop ? 14 : (isTablet ? 13 : 12)),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: options[0],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 12 : 10,
                  vertical: isDesktop ? 8 : 6,
                ),
              ),
              items: options.map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option, style: TextStyle(fontSize: isDesktop ? 14 : 13)),
                );
              }).toList(),
              onChanged: (String? value) {},
            ),
          ],
        );
      case 'text':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['title'],
              style: TextStyle(fontSize: isDesktop ? 14 : (isTablet ? 13 : 12)),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: TextEditingController(text: item['value'] as String),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 12 : 10,
                  vertical: isDesktop ? 8 : 6,
                ),
              ),
              style: TextStyle(fontSize: isDesktop ? 14 : 13),
            ),
          ],
        );
    }
  }
}