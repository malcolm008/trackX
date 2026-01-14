import 'package:flutter/material.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _locationTracking = true;
  bool _autoCheckIn = false;
  bool _emergencyAlerts = true;
  bool _darkMode = false;

  String _selectedLanguage = 'English';
  String _selectedNotificationSound = 'Default';
  String _selectedMapProvider = 'Google Maps';

  final List<Map<String, dynamic>> _pickupLocations = [
    {
      'id': '1',
      'name': 'Home',
      'address': '123 Main St, Greenwood City',
      'isDefault': true,
      'latitude': 40.7128,
      'longitude': -74.0060,
    },
    {
      'id': '2',
      'name': 'Grandma\'s House',
      'address': '456 Oak Ave, Sunrise Town',
      'isDefault': false,
      'latitude': 40.7589,
      'longitude': -73.9851,
    },
    {
      'id': '3',
      'name': 'Office',
      'address': '789 Business Blvd, Metro City',
      'isDefault': false,
      'latitude': 40.7489,
      'longitude': -73.9680,
    },
  ];

  final List<Map<String, dynamic>> _reminders = [
    {
      'id': '1',
      'title': 'Morning Pickup',
      'time': '7:15 AM',
      'days': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      'enabled': true,
      'type': 'pickup',
    },
    {
      'id': '2',
      'title': 'Afternoon Drop',
      'time': '3:30 PM',
      'days': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      'enabled': true,
      'type': 'drop',
    },
    {
      'id': '3',
      'title': 'Weekly Summary',
      'time': '6:00 PM',
      'days': ['Fri'],
      'enabled': true,
      'type': 'summary',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Settings'),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                tooltip: 'Save Settings',
              ),
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              _buildSection(
                title: 'Profile',
                icon: Icons.person_outline,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: Text('P'),
                    ),
                    title: const Text(
                      'Sarah Johnson',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditProfileDialog();
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: const Text('Phone Number'),
                    subtitle: const Text('+1 (555) 123-4567'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Colors.blue),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Notifications',
                icon: Icons.notifications_outlined,
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive push notifications on your device'),
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() => _pushNotifications = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Receive notifications via email'),
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() => _emailNotifications = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: const Text('Receive notifications via SMS'),
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() => _smsNotifications = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Emergency Alerts'),
                    subtitle: const Text('Receive emergency alerts immediately'),
                    value: _emergencyAlerts,
                    onChanged: (value) {
                      setState(() => _emergencyAlerts = value);
                    },
                  ),
                  ListTile(
                    title: const Text('Notification Sound'),
                    subtitle: Text(_selectedNotificationSound),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showNotificationSoundDialog();
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Pickup Locations',
                icon: Icons.location_on_outlined,
                children: [
                  ..._pickupLocations.map((location) {
                    return ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: location['isDefault'] ? Colors.blue : Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(location['name']),
                      subtitle: Text(location['address']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(location['isDefault'])
                            Chip(
                              label: const Text('Default'),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () {
                              _showEditLocationDialog(location);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            onPressed: () {
                              _showDeleteLocationDialog(location);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  ListTile(
                    leading: Icon(Icons.add_location, color: Theme.of(context).colorScheme.onSurface),
                    title: Text(
                      'Add New Location',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onTap: () {
                      _showAddLocationDialog();
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Reminders',
                icon: Icons.alarm_outlined,
                children: [
                  ..._reminders.map((reminder) {
                    return SwitchListTile(
                      title: Text(reminder['title']),
                      subtitle: Text(
                        '${reminder['time']} • ${(reminder['days'] as List).join(', ')}',
                      ),
                      value: reminder['enabled'],
                      onChanged: (value) {
                        setState(() {
                          reminder['enabled'] = value;
                        });
                      },
                      secondary: Icon(
                        _getReminderIcon(reminder['type']),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
                  ListTile(
                    leading: Icon(Icons.add_alarm, color: Theme.of(context).colorScheme.onSurface),
                    title: Text(
                      'Add New Reminder',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onTap: () {
                      _showAddReminderDialog();
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Privacy & Security',
                icon: Icons.security_outlined,
                children: [
                  SwitchListTile(
                    title: const Text('Location Tracking'),
                    subtitle: const Text('Allow app to track bus location'),
                    value: _locationTracking,
                    onChanged: (value) {
                      setState(() => _locationTracking = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Auto Check-in'),
                    subtitle: const Text('Automatically check-in when near bus'),
                    value: _autoCheckIn,
                    onChanged: (value) {
                      setState(() => _autoCheckIn = value);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.visibility_outlined, color: Colors.blue),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: Colors.blue),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'App Settings',
                icon: Icons.settings_outlined,
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue),
                    title: const Text('Language'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch to dark theme'),
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() => _darkMode = value);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.map_outlined, color: Colors.blue),
                    title: const Text('Map Provider'),
                    subtitle: Text(_selectedMapProvider),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showMapProviderDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage_outlined, color: Colors.blue),
                    title: const Text('Clear Cache'),
                    subtitle: const Text('Clear temporary data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showClearCacheDialog();
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Account',
                icon: Icons.account_circle_outlined,
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.blue),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined, color: Colors.blue),
                    title: const Text('Send Feedback'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showFeedbackDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_outlined, color: Colors.blue),
                    title: const Text('Share App'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'TrackX Parent App',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '© 2024 School Transport System. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                initialValue: 'Sarah Johnson',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                initialValue: '+1 (555) 123-4567',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  IconData _getReminderIcon(String type) {
    switch (type) {
      case 'pickup':
        return Icons.directions_bus;
      case 'drop':
        return Icons.home;
      case 'summary':
        return Icons.summarize;
      default:
        return Icons.notifications;
    }
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Reminder Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Reminder Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Pickup', 'Drop-off', 'Payment', 'Meeting', 'Other'].map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Repeat on:'),
              Wrap(
                spacing: 8,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day){
                  return FilterChip(
                    label: Text(day),
                    selected: false,
                    onSelected: (selected) {},
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reminder added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMapProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Provider'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              final providers = ['Google Maps', 'Apple Maps', 'OpenStreetMap'];
              return RadioListTile(
                title: Text(providers[index]),
                value: providers[index],
                groupValue: _selectedMapProvider,
                onChanged: (value) {
                  setState(() {
                    _selectedMapProvider = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showNotificationSoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Sound'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              final sounds = ['Default', 'Chime', 'Bell', 'Beep', 'Silent'];
              return RadioListTile(
                title: Text(sounds[index]),
                value: sounds[index],
                groupValue: _selectedNotificationSound,
                onChanged: (value) {
                  setState(() {
                    _selectedNotificationSound = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditLocationDialog(Map<String, dynamic> location) {

  }

  void _showDeleteLocationDialog(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text('Are you sure you want to delete "${location['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${location['name']}" deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }



  void _showAddLocationDialog(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Pickup Location',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Set as Default Location'),
                value: false,
                onChanged: (value) {

                }
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location added successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Add Location'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              final languages = ['English', 'Spanish', 'French', 'Arabic'];
              return RadioListTile(
                title: Text(languages[index]),
                value: languages[index],
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all temporary data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Send Feedback',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'We value your feedback to improve our app',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Feedback Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Bug Report', 'Feature Request', 'General Feedback', 'Suggestion']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Please describe your feedback in detail...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Include App Logs'),
                subtitle: const Text('Helps us debug issues faster'),
                value: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feedback sent successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Send Feedback'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}