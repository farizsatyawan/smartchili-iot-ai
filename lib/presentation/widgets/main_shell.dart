import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

import '../screens/dashboard_screen.dart';
import '../screens/edukasi_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/profile_screen.dart';

class MainShell extends StatefulWidget {

  // 🔥 TAMBAHAN
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() =>
      _MainShellState();
}

class _MainShellState
    extends State<MainShell> {

  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    // 🔥 AMBIL INITIAL INDEX
    _currentIndex =
        widget.initialIndex;
  }

  final List<Widget> _screens =
      const [
    DashboardScreen(),
    EdukasiScreen(),
    ScanScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      // 🔥 INDEXED STACK
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // 🔥 BOTTOM NAV
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        isDark: isDark,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// =====================================================
// BOTTOM NAV
// =====================================================
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkCard
                : Colors.white,

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.08,
            ),

            blurRadius: 20,

            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      ),

      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 8,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,

            children: [

              // DASHBOARD
              _NavItem(
                icon:
                    Icons.dashboard_rounded,

                label:
                    AppStrings.navDashboard,

                isActive:
                    currentIndex == 0,

                onTap: () => onTap(0),
              ),

              // EDUKASI
              _NavItem(
                icon:
                    Icons.menu_book_rounded,

                label:
                    AppStrings.navEdukasi,

                isActive:
                    currentIndex == 1,

                onTap: () => onTap(1),
              ),

              // SCAN
              _NavItemCenter(
                icon:
                    Icons.qr_code_scanner_rounded,

                label:
                    AppStrings.navScan,

                isActive:
                    currentIndex == 2,

                onTap: () => onTap(2),
              ),

              // PROFILE
              _NavItem(
                icon:
                    Icons.person_rounded,

                label:
                    AppStrings.navProfil,

                isActive:
                    currentIndex == 3,

                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// NAV ITEM
// =====================================================
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),

        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.primary
                      .withOpacity(0.1)
                  : Colors.transparent,

          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Icon(
              icon,

              color:
                  isActive
                      ? AppColors.primary
                      : Colors.grey,

              size: 24,
            ),

            const SizedBox(height: 2),

            Text(
              label,

              style: TextStyle(
                fontSize: 11,

                fontWeight:
                    isActive
                        ? FontWeight.w600
                        : FontWeight.w400,

                color:
                    isActive
                        ? AppColors.primary
                        : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CENTER NAV ITEM
// =====================================================
class _NavItemCenter
    extends StatelessWidget {

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemCenter({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Container(
            width: 52,
            height: 52,

            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                colors:
                    AppColors
                        .gradientPrimary,

                begin:
                    Alignment.topLeft,

                end:
                    Alignment
                        .bottomRight,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.primary
                          .withOpacity(
                    0.4,
                  ),

                  blurRadius: 12,

                  offset:
                      const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: TextStyle(
              fontSize: 11,

              fontWeight:
                  FontWeight.w600,

              color:
                  isActive
                      ? AppColors.primary
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}