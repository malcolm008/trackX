import 'package:flutter/material.dart';
import '../../../../data/models/web/school.dart';
import 'add_school_dialog.dart';

class ViewSchoolDialog extends StatelessWidget {
  final School school;

  const ViewSchoolDialog({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'School Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Basic Info ─────────────────────────
                _sectionTitle('Basic Information'),
                _infoGrid([
                  _infoItem('School Name', school.name),
                  _infoItem('School Code', school.schoolCode),
                  _infoItem('Status', school.status.capitalize()),
                  _infoItem('Created', _formatDate(school.createdAt)),
                ], isTablet),

                const SizedBox(height: 20),

                // ── Contact Info ───────────────────────
                _sectionTitle('Contact Information'),
                _infoGrid([
                  _infoItem('Email', school.email),
                  _infoItem('Phone', school.phone ?? '-'),
                  _infoItem('Contact Person', school.contactPerson ?? '-'),
                ], isTablet),

                const SizedBox(height: 20),

                // ── Location ──────────────────────────
                _sectionTitle('Location'),
                _infoGrid([
                  _infoItem('Address', school.address ?? '-'),
                  _infoItem('City', school.city ?? '-'),
                  _infoItem('Country', school.country ?? '-'),
                ], isTablet),

                const SizedBox(height: 20),

                // ── Stats ─────────────────────────────
                _sectionTitle('Statistics'),
                Row(
                  children: [
                    _statCard(
                      icon: Icons.people,
                      label: 'Students',
                      value: school.totalStudents.toString(),
                      color: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(width: 1),
                    _statCard(
                      icon: Icons.directions_bus,
                      label: 'Buses',
                      value: school.totalBuses.toString(),
                      color: Colors.teal,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ── Actions ───────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _infoGrid(List<Widget> children, bool isTablet) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isTablet ? 2 : 1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 16,
      childAspectRatio: 5,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color,),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

