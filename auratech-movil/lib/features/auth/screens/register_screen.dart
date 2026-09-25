import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../models/auth_models.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedRole = 'CLIENTE';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      RegisterRequest(
        email: _emailController.text.trim(),
        contrasena: _passwordController.text,
        nombreCompleto: _nameController.text.trim(),
        rol: _selectedRole,
      ),
    );

    if (mounted) {
      if (success) {
        AuraSnackbar.showSuccess(
          context,
          message: 'Cuenta creada exitosamente. Inicia sesión.',
        );
        Navigator.pop(context);
      } else {
        AuraSnackbar.showError(
          context,
          message:
              authProvider.errorMessage ?? 'Error al crear la cuenta',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Crear Cuenta',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AuraColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Completa tus datos para registrarte',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AuraColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),

              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AuraColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AuraColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AuraColors.shadowLight,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role Selector
                      Text(
                        'Tipo de cuenta',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AuraColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              icon: LucideIcons.user,
                              label: 'Cliente',
                              subtitle: 'Solicita servicios',
                              isSelected:
                                  _selectedRole == 'CLIENTE',
                              onTap: () => setState(
                                  () => _selectedRole = 'CLIENTE'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _RoleCard(
                              icon: LucideIcons.wrench,
                              label: 'Técnico',
                              subtitle: 'Ofrece servicios',
                              isSelected:
                                  _selectedRole == 'TECNICO',
                              onTap: () => setState(
                                  () => _selectedRole = 'TECNICO'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name
                      AuraTextField(
                        label: 'Nombre completo',
                        hint: 'Tu nombre y apellidos',
                        controller: _nameController,
                        prefixIcon: const Icon(LucideIcons.user,
                            size: 16,
                            color: AuraColors.textMuted),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Ingrese su nombre completo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      AuraTextField(
                        label: 'Correo electrónico',
                        hint: 'correo@ejemplo.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(LucideIcons.mail,
                            size: 16,
                            color: AuraColors.textMuted),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
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
                      const SizedBox(height: 16),

                      // Password
                      AuraTextField(
                        label: 'Contraseña',
                        hint: 'Mínimo 8 caracteres',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(LucideIcons.lock,
                            size: 16,
                            color: AuraColors.textMuted),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 16,
                            color: AuraColors.textMuted,
                          ),
                          onPressed: () => setState(() =>
                              _obscurePassword =
                                  !_obscurePassword),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese una contraseña';
                          }
                          if (value.length < 8) {
                            return 'La contraseña debe tener al menos 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      AuraTextField(
                        label: 'Confirmar contraseña',
                        hint: 'Repite tu contraseña',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        prefixIcon: const Icon(LucideIcons.lock,
                            size: 16,
                            color: AuraColors.textMuted),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 16,
                            color: AuraColors.textMuted,
                          ),
                          onPressed: () => setState(() =>
                              _obscureConfirm =
                                  !_obscureConfirm),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Register button
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AuraButton(
                            label: 'Crear Cuenta',
                            onPressed: _handleRegister,
                            isLoading: auth.isLoading,
                            isExpanded: true,
                            icon: LucideIcons.userPlus,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AuraColors.textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Inicia Sesión',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AuraColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AuraColors.primaryLight
              : AuraColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AuraColors.primary
                : AuraColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 22,
                color: isSelected
                    ? AuraColors.primary
                    : AuraColors.textMuted),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AuraColors.primary
                    : AuraColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AuraColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
