import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../app_routes.dart';
import '../providers/app_provider.dart';
import '../widgets/app_shell.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _uploadingAvatar = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppReviewProvider>().profile;
    _nameController = TextEditingController(text: profile.fullName);
    _usernameController = TextEditingController(text: profile.username);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 85,
      );
      if (image == null) return;
      setState(() => _uploadingAvatar = true);
      final app = context.read<AppReviewProvider>();
      final error = await app.uploadAvatar(File(image.path));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error == null ? 'Avatar updated!' : 'Upload failed: $error')),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _handleSave() async {
    final app = context.read<AppReviewProvider>();
    final error = await app.updateProfile(
      fullName: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? 'Profile updated!' : 'Error: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReviewProvider>(
      builder: (context, app, _) {
        if (!app.isLoggedIn) {
          return AppShell(
            currentRoute: AppRoutes.profile,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyStateView(
                title: 'Login required',
                message: 'Please log in to access your profile.',
                buttonLabel: 'Go To Login',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
            ),
          );
        }

        final profile = app.profile;
        return AppShell(
          currentRoute: AppRoutes.profile,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              SurfaceCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _uploadingAvatar ? null : _pickAvatar,
                      child: Stack(children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundImage: profile.avatarUrl.isNotEmpty ? NetworkImage(profile.avatarUrl) : null,
                          child: profile.avatarUrl.isEmpty
                              ? Text(profile.fullName.isNotEmpty ? profile.fullName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 28))
                              : null,
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).cardColor, width: 2),
                            ),
                            child: _uploadingAvatar
                                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(profile.fullName.isNotEmpty ? profile.fullName : 'New User',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                        if (profile.username.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('@${profile.username}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                        if (profile.bio.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(profile.bio, style: const TextStyle(color: AppColors.textMuted)),
                        ],
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats
              Wrap(spacing: 12, runSpacing: 12, children: [
                _ProfileStat(label: 'Reviews Written', value: '${profile.reviewsWritten}', icon: Icons.rate_review_outlined),
                _ProfileStat(label: 'Helpful Votes', value: '${profile.helpfulVotes}', icon: Icons.thumb_up_outlined),
                _ProfileStat(label: 'Theme', value: app.themeMode == ThemeMode.dark ? 'Dark' : 'Light', icon: Icons.palette_outlined),
              ]),
              const SizedBox(height: 16),

              // Edit Form
              SurfaceCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
                  const SizedBox(height: 16),
                  TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
                  const SizedBox(height: 16),
                  TextField(controller: _bioController, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio')),
                  const SizedBox(height: 20),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    FilledButton.icon(
                      onPressed: app.isLoading ? null : _handleSave,
                      icon: app.isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_outlined),
                      label: const Text('Save Changes'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.dashboard),
                      icon: const Icon(Icons.dashboard_outlined),
                      label: const Text('Open Dashboard'),
                    ),
                  ]),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 220,
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ])),
        ]),
      ),
    );
  }
}
