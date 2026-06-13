import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/data/models/user_model.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_bloc.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_event.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_state.dart';
import '../../../core/theme/app_theme.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.shade200, width: 0.5), 
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_rounded,
                      color: AppColors.primary, size: 26),
                  const SizedBox(width: 10),
                  const Text(
                    'Users',
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  // user count badge
                  BlocBuilder<UsersBloc, UsersState>(
                    builder: (context, state) {
                      final count =
                          state is UsersLoaded ? state.users.length : 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count users',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),


            Expanded(
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is UsersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }

                  if (state is UsersError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AppColors.error, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context
                                .read<UsersBloc>()
                                .add(LoadUsers()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is UsersLoaded) {
                    if (state.users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline_rounded,
                                size: 72,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text(
                              'No users found',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Firebase collection is empty',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: state.users.length,
                      itemBuilder: (context, i) =>
                          _UserCard(user: state.users[i]),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = user.displayName.trim().isNotEmpty
        ? user.displayName
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'U';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.grey.shade200, width: 1), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: const TextStyle(
                    color: Colors.black87, 
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email_outlined,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}