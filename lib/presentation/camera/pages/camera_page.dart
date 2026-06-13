import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/camera_bloc.dart';
import '../../../core/theme/app_theme.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  late final AnimationController _pulseCtrl;
  File? _preview;
  ImageSource? _pickedSource;

  String? _uploadedImageUrl;
  double? _uploadedLat;
  double? _uploadedLng;
  String? _uploadedLocation;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraBloc, CameraState>(
      listener: (ctx, state) {
        if (state is CameraUploadSuccess) {
          setState(() {
            _preview = null;
            _uploadedImageUrl = state.photo.watermarkedUrl;
            _uploadedLat = state.photo.latitude;
            _uploadedLng = state.photo.longitude;
            _uploadedLocation = state.photo.address;
          });
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 18),
              SizedBox(width: 10),
              Text('Photo uploaded successfully!',
                  style: TextStyle(color: Colors.black87)),
            ]),
            backgroundColor: Colors.white, // ✅
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.all(16),
          ));
        }
        if (state is CameraError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.error_rounded,
                  color: AppColors.error, size: 18),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.black87))),
            ]),
            backgroundColor: Colors.white, // ✅
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.all(16),
          ));
        }
      },
      child: BlocBuilder<CameraBloc, CameraState>(
        builder: (ctx, state) {
          final isUploading = state is CameraUploading;
          return Scaffold(
            backgroundColor: Colors.white, // ✅ white background
            body: CustomScrollView(
              slivers: [
                // ✅ white app bar
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 16),
                    title: const Text(
                      'Capture Photo',
                      style: TextStyle(
                        color: Colors.black, // ✅ dark title
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    background: Container(
                      color: Colors.white,
                      child: Stack(children: [
                        Positioned(
                          right: 20,
                          top: 20,
                          child: Opacity(
                            opacity: 0.06,
                            child: Icon(Icons.location_on_rounded,
                                size: 100, color: AppColors.primary),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.5),
                    child: Divider(
                        height: 0.5, color: Colors.grey.shade200),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_preview != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.file(_preview!,
                                    width: double.infinity,
                                    height: 260,
                                    fit: BoxFit.cover),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _preview = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 18),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Row(children: [
                                      Icon(
                                        _pickedSource == ImageSource.camera
                                            ? Icons.camera_alt_rounded
                                            : Icons.photo_library_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _pickedSource == ImageSource.camera
                                            ? 'Camera'
                                            : 'Gallery',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _buildUploadCard(ctx, isUploading),
                        const SizedBox(height: 24),
                        _buildInfoBanner(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadCard(BuildContext ctx, bool isUploading) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ white card
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary
                        .withOpacity(0.1 + _pulseCtrl.value * 0.1),
                    AppColors.primary.withOpacity(0.03),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary
                      .withOpacity(0.2 + _pulseCtrl.value * 0.2),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.add_a_photo_rounded,
                  color: AppColors.primary, size: 36),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Take or Pick a Photo',
            style: TextStyle(
              color: Colors.black87, // ✅
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Camera: no watermark  •  Gallery: watermark applied',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600, // ✅
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (isUploading) ...[
            _buildProgressSection(),
          ] else ...[
            Row(
              children: [
                Expanded(
                    child: _PickButton(
                  label: 'Camera',
                  icon: Icons.camera_alt_rounded,
                  onTap: () => _pick(ctx, ImageSource.camera),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _PickButton(
                  label: 'Gallery',
                  icon: Icons.photo_library_rounded,
                  outline: true,
                  onTap: () => _pick(ctx, ImageSource.gallery),
                )),
              ],
            ),
            if (_preview != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _upload(ctx),
                  icon: const Icon(Icons.cloud_upload_rounded,
                      size: 20, color: Colors.white),
                  label: Text(
                    _pickedSource == ImageSource.gallery
                        ? 'Upload with Watermark'
                        : 'Upload Photo',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Text(
              _pickedSource == ImageSource.gallery
                  ? 'Applying watermark & uploading...'
                  : 'Getting GPS & uploading...',
              style: const TextStyle(
                color: Colors.black87, // ✅
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade200, // ✅
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    if (_uploadedImageUrl == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50, // ✅ light green tint on white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 16),
              SizedBox(width: 8),
              Text(
                'Upload Successful',
                style: TextStyle(
                  color: Colors.black87, // ✅
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _uploadedImageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      height: 200,
                      color: Colors.grey.shade100, // ✅
                      child: const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      ),
                    ),
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey.shade100, // ✅
                child: Center(
                  child: Icon(Icons.broken_image_rounded,
                      color: Colors.grey.shade400, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'GPS Details',
            style: TextStyle(
              color: Colors.black87, // ✅
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          if (_uploadedLat != null && _uploadedLng != null) ...[
            _GpsRow(
                icon: Icons.my_location_rounded,
                label: 'Latitude',
                value: _uploadedLat!.toStringAsFixed(6)),
            const SizedBox(height: 6),
            _GpsRow(
                icon: Icons.explore_rounded,
                label: 'Longitude',
                value: _uploadedLng!.toStringAsFixed(6)),
          ],
          if (_uploadedLocation != null &&
              _uploadedLocation!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _GpsRow(
                icon: Icons.location_on_rounded,
                label: 'Location',
                value: _uploadedLocation!),
          ],
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext ctx, ImageSource source) async {
    setState(() {
      _uploadedImageUrl = null;
      _uploadedLat = null;
      _uploadedLng = null;
      _uploadedLocation = null;
      _pickedSource = source;
      _preview = null;
    });

    final picked = await _picker.pickImage(
        source: source, imageQuality: 92, maxWidth: 1920);
    if (picked != null) {
      setState(() => _preview = File(picked.path));
    }
  }

  void _upload(BuildContext ctx) {
    if (_preview != null && _pickedSource != null) {
      ctx.read<CameraBloc>().add(
            CameraUploadRequested(_preview!, _pickedSource!),
          );
    }
  }
}

class _GpsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _GpsRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: AppColors.primary, size: 15),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey.shade600, // ✅
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87, // ✅
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

class _PickButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool outline;
  final VoidCallback onTap;

  const _PickButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: outline ? Colors.grey.shade300 : Colors.transparent, // ✅
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: outline ? Colors.grey.shade600 : Colors.white, // ✅
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: outline ? Colors.grey.shade600 : Colors.white, // ✅
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}