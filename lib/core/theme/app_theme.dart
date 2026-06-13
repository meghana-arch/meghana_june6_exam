import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();
  static const Color bg = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color card = Color(0xFF1C1C26);
  static const Color cardHover = Color(0xFF22222E);
  static const Color border = Color(0xFF2A2A38);
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B85FF);
  static const Color primaryDark = Color(0xFF4A43CC);
  static const Color accent = Color(0xFFFF6584);
  static const Color accentGreen = Color(0xFF43E97B);
  static const Color accentOrange = Color(0xFFFF9A56);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textHint = Color(0xFF444460);
  static const Color success = Color(0xFF43E97B);
  static const Color error = Color(0xFFFF5F6D);
  static const Color warning = Color(0xFFFFB347);
}

// class AppTheme {
//   AppTheme._();

//   static ThemeData get dark => ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: AppColors.bg,
//         colorScheme: const ColorScheme.dark(
//           primary: AppColors.primary,
//           secondary: AppColors.accent,
//           surface: AppColors.surface,
//           error: AppColors.error,
//           onPrimary: Colors.white,
//           onSurface: AppColors.textPrimary,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.surface,
//           foregroundColor: AppColors.textPrimary,
//           elevation: 0,
//           centerTitle: true,
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.light,
//           ),
//           titleTextStyle: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.3,
//           ),
//         ),
//         cardTheme: CardThemeData(
//           color: AppColors.card,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: AppColors.border, width: 0.5),
//           ),
//           margin: EdgeInsets.zero,
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: AppColors.card,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: AppColors.border, width: 0.8),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: AppColors.border, width: 0.8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: AppColors.error),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: AppColors.error, width: 1.5),
//           ),
//           labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
//           hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
//           prefixIconColor: AppColors.textSecondary,
//           suffixIconColor: AppColors.textSecondary,
//           errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             elevation: 0,
//             minimumSize: const Size(double.infinity, 56),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             textStyle: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             foregroundColor: AppColors.primary,
//             textStyle: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         dividerTheme: const DividerThemeData(
//           color: AppColors.border,
//           thickness: 0.5,
//         ),
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 36,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -1),
//           displayMedium: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 28,
//               fontWeight: FontWeight.w700),
//           titleLarge: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 20,
//               fontWeight: FontWeight.w700),
//           titleMedium: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 16,
//               fontWeight: FontWeight.w600),
//           bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16, height: 1.6),
//           bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
//           bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 12),
//           labelLarge: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 16,
//               fontWeight: FontWeight.w700),
//         ),
//         snackBarTheme: SnackBarThemeData(
//           backgroundColor: AppColors.card,
//           contentTextStyle: const TextStyle(color: AppColors.textPrimary),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           behavior: SnackBarBehavior.floating,
//         ),
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: AppColors.surface,
//           selectedItemColor: AppColors.primary,
//           unselectedItemColor: AppColors.textHint,
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//           unselectedLabelStyle: TextStyle(fontSize: 11),
//         ),
//       );
// }