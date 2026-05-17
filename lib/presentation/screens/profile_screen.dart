import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ==============================
  // PICK DATE
  // ==============================
  Future<void> pickDate(
    BuildContext context,
    String uid,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(pickedDate);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'mulaiTanam': formattedDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final cardColor =
        isDark ? AppColors.darkCard : Colors.white;

    final bgColor =
        isDark
            ? AppColors.darkBackground
            : AppColors.background;

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bgColor,

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child:
                  Text("Data tidak ditemukan"),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>?;

          final nama =
              data?['nama'] ??
                  "Petani Cabai";

          final alamat =
              data?['alamatKebun'] ??
                  "Belum diisi";

          final photoUrl =
              data?['photoUrl'] ?? "";

          final mulaiTanam =
              data?['mulaiTanam'] ?? "";

          return CustomScrollView(
            slivers: [
              _buildProfileHeader(
                context,
                nama,
                alamat,
                photoUrl,
              ),

              SliverPadding(
                padding:
                    const EdgeInsets.all(16),

                sliver: SliverList(
                  delegate:
                      SliverChildListDelegate([
                    // ================== INFO KEBUN ==================
                    ProfileSection(
                      title:
                          AppStrings.infoKebun,

                      cardColor: cardColor,

                      children: [
                        ProfileItem(
                          icon:
                              Icons.eco_rounded,

                          label:
                              "Mulai Tanam",

                          onTap: () =>
                              pickDate(
                                context,
                                user.uid,
                              ),

                          trailing: Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              Flexible(
                                child: Text(
                                  mulaiTanam
                                          .isEmpty
                                      ? "Pilih tanggal"
                                      : mulaiTanam,

                                  textAlign:
                                      TextAlign
                                          .end,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    color:
                                        mulaiTanam
                                                .isEmpty
                                            ? Colors
                                                .grey
                                            : AppColors
                                                .primary,

                                    fontStyle:
                                        mulaiTanam
                                                .isEmpty
                                            ? FontStyle
                                                .italic
                                            : FontStyle
                                                .normal,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 8),

                              const Icon(
                                Icons
                                    .calendar_month,
                                size: 18,
                                color: AppColors
                                    .primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 14),

                    // ================== PREFERENSI ==================
                    ProfileSection(
                      title:
                          AppStrings.preferensi,

                      cardColor: cardColor,

                      children: const [
                        _DarkModeItem(),
                      ],
                    ),

                    const SizedBox(
                        height: 14),

                    // ================== AKUN ==================
                    ProfileSection(
                      title: "Akun",

                      cardColor: cardColor,

                      children: [
                        ProfileItem(
                          icon:
                              Icons.edit_rounded,

                          label:
                              "Edit Profile",

                          trailing:
                              const Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 14,
                          ),

                          onTap: () async {
                            await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProfileScreen(
                                  currentNama:
                                      nama,

                                  currentAlamat:
                                      alamat,

                                  currentPhotoUrl:
                                      photoUrl,

                                  currentMulaiTanam:
                                      mulaiTanam,
                                ),
                              ),
                            );
                          },
                        ),

                        ProfileItem(
                          icon:
                              Icons.logout_rounded,

                          label: "Logout",

                          trailing:
                              const Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 14,
                          ),

                          onTap: () async {
                            final confirm =
                                await showDialog(
                              context:
                                  context,

                              builder:
                                  (_) =>
                                      AlertDialog(
                                title:
                                    const Text(
                                        "Logout"),

                                content:
                                    const Text(
                                  "Yakin ingin keluar?",
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                      context,
                                      false,
                                    ),

                                    child:
                                        const Text(
                                      "Batal",
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                      context,
                                      true,
                                    ),

                                    child:
                                        const Text(
                                      "Logout",
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm ==
                                true) {
                              final auth =
                                  context.read<
                                      AppAuthProvider>();

                              await auth
                                  .logout();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 14),

                    // ================== ABOUT ==================
                    _AboutCard(
                      cardColor: cardColor,
                    ),

                    const SizedBox(
                        height: 24),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================== HEADER ==================
  SliverAppBar _buildProfileHeader(
    BuildContext context,
    String nama,
    String alamat,
    String photoUrl,
  ) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,

      backgroundColor:
          AppColors.primaryDark,

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:
                  AppColors.gradientPrimary,

              begin: Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
            ),
          ),

          child: SafeArea(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                const SizedBox(height: 20),

                // ================= FOTO =================
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color: Colors.white
                            .withOpacity(0.2),

                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.5),

                          width: 3,
                        ),
                      ),

                      child: ClipOval(
                        child:
                            photoUrl.isNotEmpty
                                ? Image.network(
                                    photoUrl,
                                    fit: BoxFit
                                        .cover,
                                  )
                                : const Center(
                                    child: Text(
                                      '👨‍🌾',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            46,
                                      ),
                                    ),
                                  ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,

                      child: Container(
                        width: 30,
                        height: 30,

                        decoration:
                            const BoxDecoration(
                          color:
                              AppColors.warning,

                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ================= NAMA =================
                Text(
                  nama,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                // ================= ALAMAT =================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    const Icon(
                      Icons
                          .location_on_rounded,

                      color: Colors.white70,
                      size: 14,
                    ),

                    const SizedBox(width: 4),

                    Flexible(
                      child: Text(
                        alamat,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style: TextStyle(
                          color: Colors.white
                              .withOpacity(0.8),

                          fontSize: 12,
                        ),
                      ),
                    ),
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

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              8,
            ),

            child: Text(
              title.toUpperCase(),

              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,

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
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(label),
            ),

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
      builder:
          (context, themeProvider, _) {
        return ProfileItem(
          icon: Icons.dark_mode_rounded,

          label: AppStrings.darkMode,

          trailing: Switch(
            value:
                themeProvider.isDarkMode,

            onChanged:
                themeProvider.toggleDarkMode,

            activeColor:
                AppColors.primary,
          ),
        );
      },
    );
  }
}

// ================== ABOUT ==================
class _AboutCard extends StatelessWidget {
  final Color cardColor;

  const _AboutCard({
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        children: const [
          Text(
            AppStrings.appName,

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 4),

          Text(AppStrings.appVersion),
        ],
      ),
    );
  }
}