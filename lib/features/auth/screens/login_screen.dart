import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../services/auth_service.dart';
import '../widgets/google_sign_in_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authService = AuthService();
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSub;
  bool _webGoogleReady = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initWebGoogleSignIn();
    }
  }

  Future<void> _initWebGoogleSignIn() async {
    try {
      await _authService.ensureGoogleInitialized();
      _googleAuthSub = GoogleSignIn.instance.authenticationEvents.listen(
        (event) async {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            setState(() {
              _loading = true;
              _error = null;
            });
            try {
              await _authService.loginWithGoogleAccount(event.user);
              widget.onLoginSuccess();
            } catch (e) {
              if (mounted) {
                setState(
                  () => _error = e.toString().replaceFirst('Exception: ', ''),
                );
              }
            } finally {
              if (mounted) setState(() => _loading = false);
            }
          }
        },
        onError: (Object error) {
          if (mounted) {
            setState(() => _error = 'Đăng nhập Google thất bại: $error');
          }
        },
      );
      if (mounted) setState(() => _webGoogleReady = true);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Không khởi tạo được Google Sign-In: $e');
      }
    }
  }

  @override
  void dispose() {
    _googleAuthSub?.cancel();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = _userCtrl.text.trim();
    final pass = _passCtrl.text;
    if (user.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đủ tài khoản và mật khẩu');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.login(user, pass);
      widget.onLoginSuccess();
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _authService.loginWithGoogle();
      widget.onLoginSuccess();
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/icons/app_icon.png',
                  width: 72,
                  height: 72,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Đăng nhập Aiot Duck',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.xl),
                TextField(
                  controller: _userCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tài khoản',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  onSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSizes.md),
                  Text(
                    _error!,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSizes.lg),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đăng nhập'),
                ),
                const SizedBox(height: AppSizes.sm),
                if (kIsWeb)
                  Center(
                    child: _webGoogleReady
                        ? buildWebGoogleSignInButton()
                        : const SizedBox.shrink(),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _submitGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Đăng nhập bằng Google'),
                  ),
                const SizedBox(height: AppSizes.sm),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Chưa có tài khoản? Đăng ký ngay'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
