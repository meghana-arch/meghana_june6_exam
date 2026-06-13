import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/gallery_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/photo_detail_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  @override State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    context.read<GalleryBloc>().add(GalleryLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (ctx, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: AppColors.surface,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => ctx.read<GalleryBloc>().add(GalleryLoadRequested()),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: BlocBuilder<GalleryBloc, GalleryState>(
                    builder: (_, s) {
                      final count = s is GalleryLoaded ? s.photos.length : 0;
                      return Text('My Gallery ($count)',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
                    },
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF0A1A0A), AppColors.surface],
                      ),
                    ),
                    child: const Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.photo_library_rounded, size: 120,
                          color: AppColors.accentGreen),
                    ),
                  ),
                ),
              ),
              if (state is GalleryLoading) _buildShimmer(),
              if (state is GalleryLoaded && state.photos.isEmpty) _buildEmpty(),
              if (state is GalleryLoaded && state.photos.isNotEmpty)
                _buildGrid(ctx, state.photos),
              if (state is GalleryError) _buildError(ctx, state.message),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmer() => SliverPadding(
    padding: const EdgeInsets.all(16),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => Shimmer.fromColors(
          baseColor: AppColors.card,
          highlightColor: AppColors.cardHover,
          child: Container(decoration: BoxDecoration(
            color: AppColors.card, borderRadius: BorderRadius.circular(20))),
        ),
        childCount: 6,
      ),
    ),
  );

  Widget _buildEmpty() => SliverFillRemaining(
    child: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.photo_library_outlined, size: 80,
            color: AppColors.textHint.withOpacity(0.5)),
        const SizedBox(height: 16),
        const Text('No photos yet', style: TextStyle(
            color: AppColors.textSecondary, fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('Capture your first photo\nfrom the Camera tab',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textHint, fontSize: 14, height: 1.5)),
      ]),
    ),
  );

  Widget _buildGrid(BuildContext ctx, List<PhotoEntity> photos) => SliverPadding(
    padding: const EdgeInsets.all(16),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, i) => _PhotoCard(
          photo: photos[i],
          onDelete: () => _confirmDelete(ctx, photos[i]),
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) => PhotoDetailPage(photo: photos[i]))),
        ),
        childCount: photos.length,
      ),
    ),
  );

  Widget _buildError(BuildContext ctx, String msg) => SliverFillRemaining(
    child: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off_rounded, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text(msg, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => ctx.read<GalleryBloc>().add(GalleryLoadRequested()),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
        ),
      ]),
    ),
  );

  void _confirmDelete(BuildContext ctx, PhotoEntity photo) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Photo?',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text(
            'This will permanently delete the photo from Firebase Storage and Firestore.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ctx.read<GalleryBloc>().add(GalleryDeleteRequested(photo));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final PhotoEntity photo;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _PhotoCard({required this.photo, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.card,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: photo.watermarkedUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: AppColors.card,
                highlightColor: AppColors.cardHover,
                child: Container(color: AppColors.card),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image_outlined,
                    color: AppColors.textHint, size: 36)),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 11),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${photo.latitude.toStringAsFixed(4)}, ${photo.longitude.toStringAsFixed(4)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('MMM d, yyyy').format(photo.createdAt),
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}