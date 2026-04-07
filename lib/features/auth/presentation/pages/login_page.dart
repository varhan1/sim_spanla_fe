import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nipController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  String? _nipError;
  String? _passwordError;

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      // Validate NIP
      if (_nipController.text.trim().isEmpty) {
        _nipError = 'NIP wajib diisi';
        isValid = false;
      } else if (_nipController.text.trim().length < 10) {
        _nipError = 'NIP tidak valid';
        isValid = false;
      } else {
        _nipError = null;
      }

      // Validate Password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password wajib diisi';
        isValid = false;
      } else {
        _passwordError = null;
      }
    });
    return isValid;
  }

  void _handleLogin() {
    if (_validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          nip: _nipController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background Atmospheric Shapes
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.surface.withOpacity(0),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.tertiary.withOpacity(0.1),
                      AppColors.surface.withOpacity(0),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacing6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo Section
                        Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusLg,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowPrimary,
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacing4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SIM ',
                                  style: AppTextStyles.displayLarge.copyWith(
                                    fontSize: 30,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Panla',
                                  style: AppTextStyles.displayLarge.copyWith(
                                    fontSize: 30,
                                    letterSpacing: -0.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacing1),
                            Text(
                              'Digital Academy Ecosystem',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing12),
                        // Login Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXl,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowTinted,
                                blurRadius: 40,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(AppDimensions.spacing8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: AppTextStyles.headlineLarge,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.spacing1,
                                  ),
                                  Text(
                                    'Please enter your credentials to access your dashboard.',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.spacing6),
                              // NIP Field
                              AppNipField(
                                controller: _nipController,
                                label: 'NIP (Nomor Induk Pegawai)',
                                hint: 'e.g. 198106202009041003',
                                errorText: _nipError,
                                onChanged: (_) {
                                  if (_nipError != null) {
                                    setState(() => _nipError = null);
                                  }
                                },
                              ),
                              const SizedBox(height: AppDimensions.spacing5),
                              // Password Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'PASSWORD',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: AppColors.onSurfaceVariant,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Hubungi admin untuk reset password',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimensions.radiusMd,
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.spacing2,
                                  ),
                                  AppPasswordField(
                                    controller: _passwordController,
                                    hint: '••••••••',
                                    errorText: _passwordError,
                                    onChanged: (_) {
                                      if (_passwordError != null) {
                                        setState(() => _passwordError = null);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.spacing5),
                              // Remember Me
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusSm,
                                        ),
                                      ),
                                      activeColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.outlineVariant,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimensions.spacing3),
                                  Text(
                                    'Keep me logged in',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.spacing5),
                              // Login Button
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading =
                                      state is AuthLoginInProgress;
                                  return AppButton(
                                    text: 'Masuk',
                                    onPressed: isLoading ? null : _handleLogin,
                                    isLoading: isLoading,
                                    icon: Icons.arrow_forward,
                                    variant: AppButtonVariant.primary,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing12),
                        // Footer
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Need help? ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Contact Admin',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
