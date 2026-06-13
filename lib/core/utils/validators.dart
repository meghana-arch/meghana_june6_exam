class Validators {
  Validators._();

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Name too short';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != original) return 'Passwords do not match';
    return null;
  }
}