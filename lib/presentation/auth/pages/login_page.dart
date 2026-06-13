import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/presentation/home/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late final AnimationController _animCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushAndRemoveUntil(
              ctx,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          }

          if (state is AuthFailureState) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: AppColors.card,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (ctx, state) {
          return Stack(
            children: [
              _buildBg(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: _buildContent(ctx, state),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBg() => Container(
    decoration:  BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: -120,
          right: -120,
          child: _glow(AppColors.primary.withOpacity(0.12), 280),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          child: _glow(AppColors.accent.withOpacity(0.08), 240),
        ),
      ],
    ),
  );

  Widget _glow(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent]),
    ),
  );

  Widget _buildContent(BuildContext ctx, AuthState state) {
    final isLoading = state is AuthLoading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryLight, AppColors.primary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.camera_enhance_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue to your account' ,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 44),
        Form(
          key: _formKey,
          child: Column(
            children: [
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
                hint: 'Your password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _submit(ctx),
                validator: Validators.password,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _submit(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(color: AppColors.textHint, fontSize: 13),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(ctx).unfocus();
      ctx.read<AuthBloc>().add(
        AuthSignInRequested(_emailCtrl.text.trim(), _passCtrl.text),
      );
    }
  }
}
