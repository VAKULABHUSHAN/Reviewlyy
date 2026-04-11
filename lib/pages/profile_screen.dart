import 'package:flutter/material.dart';
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
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppReviewProvider>().profile;
    _nameController = TextEditingController(text: profile.fullName);
    _bioController = TextEditingController(text: profile.bio);
    _locationController = TextEditingController(text: profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
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
              SurfaceCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(profile.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(profile.email,
                              style: const TextStyle(color: AppColors.textMuted)),
                          const SizedBox(height: 8),
                          Text(profile.bio),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ${profile.location}',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ProfileStat(label: 'Reviews Written', value: '${profile.reviewsWritten}'),
                  _ProfileStat(label: 'Helpful Votes', value: '${profile.helpfulVotes}'),
                  _ProfileStat(label: 'Theme', value: app.themeMode == ThemeMode.dark ? 'Dark' : 'Light'),
                ],
              ),
              const SizedBox(height: 16),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Profile',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bioController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Bio'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: () {
                            app.updateProfile(
                              fullName: _nameController.text.trim(),
                              bio: _bioController.text.trim(),
                              location: _locationController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated')),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save Changes'),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.dashboard,
                          ),
                          child: const Text('Open Dashboard'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
