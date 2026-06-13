import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/presentation/auth/pages/login_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Row(children: [
                const Icon(Icons.error_rounded, color: AppColors.error, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(state.message)),
              ]),
              backgroundColor: AppColors.card,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.all(16),
            ));
          }


          if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: const Row(children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Account created! Please sign in.'),
                ]),
                backgroundColor: Colors.green.shade800,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.all(16),
              ),
            );

            Navigator.pushAndRemoveUntil(
              ctx,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Colors.white],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                          const SizedBox(width: 4),
                          const Text('Create Account', style: TextStyle(
                            color: Colors.black, fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthTextField(
                                    controller: _nameCtrl,
                                    label: 'Full Name',
                                    hint: 'John Doe',
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.name,
                                  ),
                                  const SizedBox(height: 16),
                                  AuthTextField(
                                    controller: _emailCtrl,
                                    label: 'Email',
                                    hint: 'you@example.com',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.email,
                                  ),
                                  const SizedBox(height: 16),
                                  AuthTextField(
                                    controller: _passCtrl,
                                    label: 'Password',
                                    hint: 'Min 6 characters',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.password,
                                  ),
                                  const SizedBox(height: 16),
                                  AuthTextField(
                                    controller: _confirmCtrl,
                                    label: 'Confirm Password',
                                    hint: 'Repeat your password',
                                    prefixIcon: Icons.lock_reset_rounded,
                                    isPassword: true,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () => _submit(ctx),
                                    validator: (v) =>
                                        Validators.confirmPassword(v, _passCtrl.text),
                                  ),
                                  const SizedBox(height: 36),
                                  SizedBox(
                                    width: double.infinity, height: 56,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : () => _submit(ctx),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        disabledBackgroundColor:
                                            AppColors.primary.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 24, height: 24,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2.5, color: Colors.white))
                                          : const Text('Create Account',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(ctx).unfocus();
      ctx.read<AuthBloc>().add(AuthSignUpRequested(
          _emailCtrl.text.trim(),
          _passCtrl.text,
          _nameCtrl.text.trim()));
    }
  }
}