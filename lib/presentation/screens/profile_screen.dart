import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/dummy_data.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart'; // 🔥 penting

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    final profile = DummyData.profileData;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildProfileHeader(context, profile),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ================== INFO KEBUN ==================
                ProfileSection(
                  title: AppStrings.infoKebun,
                  cardColor: cardColor,
                  children: [
                    ProfileItem(
                      icon: Icons.grass_rounded,
                      label: AppStrings.luasKebun,
                      trailing: Text(
                        profile['luasKebun'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    ProfileItem(
                      icon: Icons.calendar_today_rounded,
                      label: AppStrings.mulaiTanam,
                      trailing: Text(
                        profile['mulaiTanam'] ?? '-',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ================== PREFERENSI ==================
                ProfileSection(
                  title: AppStrings.preferensi,
                  cardColor: cardColor,
                  children: [
                    const _DarkModeItem(),
                  ],
                ),

                const SizedBox(height: 14),

                // ================== AKUN ==================
                ProfileSection(
                  title: "Akun",
                  cardColor: cardColor,
                  children: [
                    ProfileItem(
                      icon: Icons.edit_rounded,
                      label: "Edit Profile",
                      trailing:
                          const Icon(Icons.arrow_forward_ios, size: 14),
                    ),

                    // 🔥 LOGOUT FIX
                    ProfileItem(
                      icon: Icons.logout_rounded,
                      label: "Logout",
                      trailing:
                          const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Yakin ingin keluar?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("Logout"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final auth =
                              context.read<AppAuthProvider>();
                          await auth.logout();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ================== ABOUT ==================
                _AboutCard(cardColor: cardColor),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ================== HEADER ==================
  SliverAppBar _buildProfileHeader(
      BuildContext context, Map<String, String> profile) {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      backgroundColor: AppColors.primaryDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPrimary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 3),
                      ),
                      child: const Center(
                        child:
                            Text('👨‍🌾', style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  profile['nama'] ?? AppStrings.namaUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      profile['lokasi'] ??
                          AppStrings.lokasiKebun,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatChip(
                        label: 'Scan',
                        value: profile['totalScan'] ?? '0'),
                    const SizedBox(width: 20),
                    _StatChip(
                        label: 'Artikel',
                        value:
                            profile['totalArtikel'] ?? '0'),
                    const SizedBox(width: 20),
                    _StatChip(
                        label: 'Hari Aktif',
                        value: profile['hariAktif'] ?? '0'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================== STAT ==================
class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ================== SECTION ==================
class ProfileSection extends StatelessWidget {
  final String title;
  final Color cardColor;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.cardColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

// ================== ITEM ==================
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ================== DARK MODE ==================
class _DarkModeItem extends StatelessWidget {
  const _DarkModeItem();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ProfileItem(
          icon: Icons.dark_mode_rounded,
          label: AppStrings.darkMode,
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleDarkMode,
            activeColor: AppColors.primary,
          ),
        );
      },
    );
  }
}

// ================== ABOUT ==================
class _AboutCard extends StatelessWidget {
  final Color cardColor;

  const _AboutCard({required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.appName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(AppStrings.appVersion),
        ],
      ),
    );
  }
}