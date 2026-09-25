import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRecover() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.recoverPassword(
      _emailController.text.trim(),
    );

    if (mounted) {
      if (success) {
        AuraSnackbar.showSuccess(
          context,
          message:
              'Se envió un enlace de recuperación a tu correo.',
        );
        Navigator.pop(context);
      } else {
        AuraSnackbar.showError(
          context,
          message: authProvider.errorMessage ??
              'Error al enviar recuperación',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft,
              color: AuraColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AuraColors.amberBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.keyRound,
                    color: AuraColors.amberText, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'Recuperar Contraseña',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AuraColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AuraColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: AuraTextField(
                  label: 'Correo electrónico',
                  hint: 'correo@ejemplo.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(LucideIcons.mail,
                      size: 16, color: AuraColors.textMuted),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese su correo electrónico';
                    }
                    if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return AuraButton(
                    label: 'Enviar enlace de recuperación',
                    onPressed: _handleRecover,
                    isLoading: auth.isLoading,
                    isExpanded: true,
                    icon: LucideIcons.send,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
