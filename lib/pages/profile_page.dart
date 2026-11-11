import 'package:flutter/material.dart';
import '../services/pref_service.dart';
import '../data/project_repository.dart';
import 'project_list_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.prefs,
    required this.isDark,
    required this.onThemeChanged,
  });

  final PrefService prefs;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _projectRepo = ProjectRepository();
  late Future<int> _countFuture = _projectRepo.count();

  Future<void> _openProjects() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectListPage()),
    );
    if (!mounted) return;
    
    // Kembali dari daftar proyek → segarkan jumlah
    setState(() {
      _countFuture = _projectRepo.count();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const Text(
            'Agustinus Afandi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Teknik Informatika - Polije',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Lab 11: Menu Proyek Saya
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Proyek Saya'),
            subtitle: FutureBuilder<int>(
              future: _countFuture,
              builder: (context, snapshot) => Text('${snapshot.data ?? 0} proyek'),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openProjects,
          ),
          const Divider(),
          
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Mode Gelap'),
            value: widget.isDark,
            onChanged: widget.onThemeChanged,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Aplikasi dibuka'),
            trailing: Text('${widget.prefs.openCount} kali'),
          ),
        ],
      ),
    );
  }
}