import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SnackUtil {
  SnackUtil._();

  static void success(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(color: AppColors.textPrimary))),
      ]),
      backgroundColor: AppColors.card,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  static void error(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_rounded, color: AppColors.error, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(color: AppColors.textPrimary))),
      ]),
      backgroundColor: AppColors.card,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }
}