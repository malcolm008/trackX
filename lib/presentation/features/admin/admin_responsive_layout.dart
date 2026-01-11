import 'package:bustracker_007/presentation/features/admin/screens/live_map_screen.dart';
import 'package:flutter/material.dart';

class AdminResponsiveLayout extends StatefulWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const AdminResponsiveLayout({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  State<AdminResponsiveLayout> createState() => _AdminResponsiveLayoutState();
}

class _AdminResponsiveLayoutState extends State<AdminResponsiveLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return _buildDesktopLayout(context);
        } else if (isTablet) {
          return _buildTabletLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // Left Navigation Drawer (permanent for desktop)
          Container(
            width: 280,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1F2937)
                : Colors.white,
            child: _buildAdminNavigation(context),
          ),
          // Main Content Area
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: widget.actions,
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: widget.body,
              ),
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 280,
        child: _buildAdminNavigation(context),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.body,
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: _buildAdminNavigation(context),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: widget.body,
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Widget _buildAdminNavigation(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1F2937)
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School Transport',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Admin Panel',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildNavItem(
                  context,
                  Icons.dashboard,
                  'Dashboard',
                  isActive: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.subscriptions,
                  'Subscriptions',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.people,
                  'Users',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.school,
                  'Schools',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.business,
                  'Organizations',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.directions_bus,
                  'Buses',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.route,
                  'Routes',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.map,
                  'Live Map',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LiveMapScreen()),
                    );
                  },
                ),
                _buildNavItem(
                  context,
                  Icons.receipt,
                  'Billing',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.analytics,
                  'Analytics',
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  Icons.settings,
                  'Settings',
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('AD'),
                  ),
                  title: const Text('Admin User'),
                  subtitle: const Text('admin@schoolsystem.com'),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {},
                    tooltip: 'Logout',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      IconData icon,
      String label, {
        bool isActive = false,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isActive
            ? Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}