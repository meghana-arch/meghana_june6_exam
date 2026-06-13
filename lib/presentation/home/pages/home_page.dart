import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/core/di/injectors.dart';
import 'package:meghana_exam6_june/presentation/auth/pages/login_page.dart';
import 'package:meghana_exam6_june/presentation/camera/bloc/camera_bloc.dart';
import 'package:meghana_exam6_june/presentation/posts/bloc/post_bloc.dart';
import 'package:meghana_exam6_june/presentation/camera/pages/camera_page.dart';
import 'package:meghana_exam6_june/presentation/posts/pages/post_page.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_bloc.dart';
import 'package:meghana_exam6_june/presentation/users/pages/users_page.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;

  static const _navItems = [
    _NavItem(icon: Icons.camera_enhance_rounded, label: 'Capture'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Users'),
    _NavItem(icon: Icons.article_rounded, label: 'Posts'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CameraBloc>()),
        BlocProvider(create: (_) => sl<UsersBloc>()),
        BlocProvider(create: (_) => sl<PostBloc>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white, 
        body: IndexedStack(
          index: _idx,
          children: const [
            CameraPage(),
            UsersPage(),
            PostsPage(),
          ],
        ),
        bottomNavigationBar: _buildNav(context),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        border: const Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              ...List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final selected = _idx == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _idx = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: selected
                                ? AppColors.primary
                                : Colors.grey.shade400,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              Expanded(
                child: GestureDetector(
                  onTap: () => _signOut(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (_, state) {
                            final name = state is AuthAuthenticated
                                ? state.user.displayName
                                : 'User';
                            return CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.15),
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Account',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, 
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AccountSheet(
        user: context.read<AuthBloc>().state is AuthAuthenticated
            ? (context.read<AuthBloc>().state as AuthAuthenticated).user
            : null,
        onSignOut: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          context.read<AuthBloc>().add(AuthSignOutRequested());
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _AccountSheet extends StatelessWidget {
  final dynamic user;
  final VoidCallback onSignOut;
  const _AccountSheet({required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Text(
              user != null && user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            user?.displayName ?? 'User',
            style: const TextStyle(
              color: Colors.black,       
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            user?.email ?? '',
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 28),

          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded,
                  size: 20, color: Colors.white),
              label: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600, 
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}