import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import '../../../core/theme/app_theme.dart';

class PhotoDetailPage extends StatefulWidget {
  final PhotoEntity photo;
  const PhotoDetailPage({super.key, required this.photo});
  @override State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  bool _showWatermarked = true;

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            DateFormat('MMM d, yyyy').format(photo.createdAt),
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () => setState(() => _showWatermarked = !_showWatermarked),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: CachedNetworkImage(
                      key: ValueKey(_showWatermarked),
                      imageUrl: _showWatermarked
                          ? photo.watermarkedUrl
                          : photo.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _showWatermarked ? 'Watermarked' : 'Original',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(children: [
                        Icon(Icons.touch_app_rounded, color: Colors.white54, size: 14),
                        SizedBox(width: 4),
                        Text('Tap to toggle', style: TextStyle(
                            color: Colors.white54, fontSize: 11)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.surface,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Photo Info', style: TextStyle(
                        color: AppColors.textPrimary, fontSize: 18,
                        fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.accent,
                      label: 'Latitude',
                      value: photo.latitude.toStringAsFixed(6),
                    ),
                    _InfoRow(
                      icon: Icons.location_searching_rounded,
                      iconColor: AppColors.accent,
                      label: 'Longitude',
                      value: photo.longitude.toStringAsFixed(6),
                    ),
                    _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppColors.primary,
                      label: 'Captured',
                      value: DateFormat('MMMM d, yyyy  HH:mm').format(photo.createdAt),
                    ),
                    _InfoRow(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.accentGreen,
                      label: 'Photo ID',
                      value: photo.id,
                    ),
                    _InfoRow(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.accentOrange,
                      label: 'Watermark',
                      value: 'Applied — tap image to toggle',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(children: [
                        const Icon(Icons.map_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${photo.latitude.toStringAsFixed(5)}, ${photo.longitude.toStringAsFixed(5)}',
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'monospace',
                                fontSize: 13),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon, required this.iconColor,
    required this.label, required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}