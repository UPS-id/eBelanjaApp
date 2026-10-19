import 'package:flutter/material.dart';
import 'package:mysample/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileTile extends StatefulWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  State<_ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<_ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: Colors.blue.shade900),
      title: Text(widget.label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(
        widget.value,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _fullName;
  String? _username;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final isLoggedIn = await SessionService.isLogin();
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      if (isLoggedIn) {
        _fullName = prefs.getString('userFullName') ?? 'Pengguna';
        _username = prefs.getString('userName') ?? '';
        _email = prefs.getString('userEmail') ?? '';
      } else {
        _fullName = null;
        _username = null;
        _email = null;
      }
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu login kembali untuk membuka akun.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;
    await SessionService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_username == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 56,
                  color: colors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum login',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                const Text('Login untuk melihat informasi akun Anda.'),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final initials = (_fullName ?? 'P')
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.blue.shade900,
                  child: Text(
                    initials.isEmpty ? 'P' : initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _fullName ?? 'Pengguna',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$_username',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.badge_outlined,
                  label: 'Nama lengkap',
                  value: _fullName ?? 'Pengguna',
                ),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                  icon: Icons.alternate_email,
                  label: 'Username',
                  value: _username!,
                ),
                const Divider(height: 1, indent: 58),
                _ProfileTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: _email?.isNotEmpty == true ? _email! : 'Belum diisi',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar'),
            subtitle: const Text('Keluar dari akun di perangkat ini'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}
