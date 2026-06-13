import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/domain/entities/post_entities.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/post_bloc.dart';
import '../../../core/theme/app_theme.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});
  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostLoadRequested());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.black,       
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
              height: 0.5, color: Colors.grey.shade200), 
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (ctx, state) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ctx.read<PostBloc>().add(PostRefreshRequested()),
            child: CustomScrollView(
              slivers: [
                if (state is PostLoading) _buildShimmer(),
                if (state is PostLoaded) _buildList(ctx, state),
                if (state is PostError) _buildError(ctx, state.message),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade100, 
              highlightColor: Colors.grey.shade50,
              child: Container(
                height: 110,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            childCount: 8,
          ),
        ),
      );

  Widget _buildList(BuildContext ctx, PostLoaded state) {
    if (state.filtered.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No posts found',
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _PostCard(post: state.filtered[i], onTap: () {}),
          childCount: state.filtered.length, 
        ),
      ),
    );
  }

  Widget _buildError(BuildContext ctx, String msg) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () =>
                    ctx.read<PostBloc>().add(PostRefreshRequested()),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text('Retry',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
}

class _PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;
  const _PostCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.accentGreen,
      AppColors.accentOrange,
      const Color(0xFF56CCF2),
    ];
    final color = colors[post.id % colors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,         
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: color.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: color.withOpacity(0.25), width: 0.8),
                  ),
                  child: Center(
                    child: Text(
                      '${post.id}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,  
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600, 
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _Tag({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}