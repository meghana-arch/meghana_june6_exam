import 'package:flutter/material.dart';
import 'package:meghana_exam6_june/domain/entities/post_entities.dart';
import '../../../core/theme/app_theme.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary, AppColors.accent, AppColors.accentGreen,
      AppColors.accentOrange, const Color(0xFF56CCF2),
    ];
    final color = colors[post.id % colors.length];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Post #${post.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.25), width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Post #${post.id}', style: TextStyle(
                          color: color, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('User ${post.userId}', style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Container(width: 36, height: 3,
                      decoration: BoxDecoration(color: color,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 12),
                  Text(post.title, style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 20,
                    fontWeight: FontWeight.w700, height: 1.4,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.article_outlined, color: color, size: 18),
                    const SizedBox(width: 8),
                    const Text('Content', style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ]),
                  const SizedBox(height: 14),
                  Text(post.body, style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15,
                    height: 1.75, letterSpacing: 0.1,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(children: [
                const Icon(Icons.cloud_outlined, color: AppColors.textHint, size: 16),
                const SizedBox(width: 8),
                const Text('Source: ', style: TextStyle(
                    color: AppColors.textHint, fontSize: 12)),
                const Text('jsonplaceholder.typicode.com', style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12,
                    fontWeight: FontWeight.w500)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}