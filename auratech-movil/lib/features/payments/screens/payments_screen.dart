import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/badges/aura_badge.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/cards/aura_card.dart';
import '../../../core/widgets/overlays/aura_confirmation_modal.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../models/payment_models.dart';
import '../providers/payments_provider.dart';
import 'register_payment_modal.dart';

class PaymentsScreen extends StatefulWidget {
  final int idSolicitud;
  final bool permiteRegistrar;

  const PaymentsScreen({
    super.key,
    required this.idSolicitud,
    this.permiteRegistrar = false,
  });

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PaymentsProvider>()
          .fetchPayments(widget.idSolicitud);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text('Pagos',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PaymentsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AuraColors.primary),
            );
          }

          return RefreshIndicator(
            color: AuraColors.primary,
            onRefresh: () =>
                provider.fetchPayments(widget.idSolicitud),
            child: provider.payments.isEmpty
                ? _EmptyPayments()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.payments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final pago = provider.payments[index];
                      return _PaymentCard(
                        pago: pago,
                        idSolicitud: widget.idSolicitud,
                      );
                    },
                  ),
          );
        },
      ),
      bottomNavigationBar:
          widget.permiteRegistrar ? _RegisterPaymentBar(idSolicitud: widget.idSolicitud) : null,
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PagoResumen pago;
  final int idSolicitud;

  const _PaymentCard({
    required this.pago,
    required this.idSolicitud,
  });

  @override
  Widget build(BuildContext context) {
    return AuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'S/ ${pago.monto}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AuraColors.textPrimary,
                ),
              ),
              const Spacer(),
              AuraBadge.fromStatus(pago.estado),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(
              label: 'Método',
              value:
                  MetodosPago.displayName(pago.metodoPago)),
          _InfoRow(
              label: 'Registrado por',
              value: pago.registradoPor),
          _InfoRow(
            label: 'Cliente confirmó',
            value: pago.confirmadoCliente ? 'Sí' : 'No',
          ),
          _InfoRow(
            label: 'Técnico confirmó',
            value: pago.confirmadoTecnico ? 'Sí' : 'No',
          ),
          if (pago.isPending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AuraButton(
                  label: 'Rechazar',
                  variant: AuraButtonVariant.outline,
                  onPressed: () =>
                      _handleReject(context),
                  fontSize: 12,
                ),
                const SizedBox(width: 8),
                AuraButton(
                  label: 'Confirmar',
                  onPressed: () =>
                      _handleConfirm(context),
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handleConfirm(BuildContext context) {
    AuraConfirmationModal.show(
      context: context,
      title: 'Confirmar pago',
      description:
          '¿Confirmas que recibiste este pago de S/ ${pago.monto}?',
      confirmText: 'Confirmar pago',
      onConfirm: () async {
        final provider =
            Provider.of<PaymentsProvider>(context,
                listen: false);
        final error = await provider.confirmPayment(
            idSolicitud, pago.idPago);
        if (context.mounted) {
          if (error != null) {
            AuraSnackbar.showError(context,
                message: error.displayMessage,
                errorCode: error.codigoError);
          } else {
            AuraSnackbar.showSuccess(context,
                message: 'Pago confirmado');
          }
        }
      },
    );
  }

  void _handleReject(BuildContext context) {
    AuraConfirmationModal.show(
      context: context,
      title: 'Rechazar pago',
      description:
          '¿Estás seguro de rechazar este pago de S/ ${pago.monto}?',
      confirmText: 'Rechazar',
      variant: AuraModalVariant.destructive,
      onConfirm: () async {
        final provider =
            Provider.of<PaymentsProvider>(context,
                listen: false);
        final error = await provider.rejectPayment(
            idSolicitud, pago.idPago);
        if (context.mounted) {
          if (error != null) {
            AuraSnackbar.showError(context,
                message: error.displayMessage,
                errorCode: error.codigoError);
          } else {
            AuraSnackbar.showSuccess(context,
                message: 'Pago rechazado');
          }
        }
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AuraColors.textMuted,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AuraColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterPaymentBar extends StatelessWidget {
  final int idSolicitud;

  const _RegisterPaymentBar({required this.idSolicitud});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AuraColors.surface,
        border: Border(
          top: BorderSide(color: AuraColors.border, width: 1),
        ),
      ),
      child: AuraButton(
        label: 'Registrar Pago',
        icon: LucideIcons.plus,
        isExpanded: true,
        onPressed: () {
          RegisterPaymentModal.show(context, idSolicitud: idSolicitud);
        },
      ),
    );
  }
}

class _EmptyPayments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.wallet,
              size: 40, color: AuraColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'No hay pagos registrados',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AuraColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Los pagos aparecerán aquí una vez registrados.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AuraColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
