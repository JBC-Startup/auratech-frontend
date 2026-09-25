import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/badges/aura_badge.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../../../core/widgets/cards/aura_card.dart';
import '../../../core/widgets/overlays/aura_confirmation_modal.dart';
import '../../../core/widgets/overlays/aura_input_modal.dart';
import '../../../core/widgets/overlays/aura_snackbar.dart';
import '../../chat/screens/chat_screen.dart';
import '../../payments/screens/payments_screen.dart';
import '../../reviews/screens/create_review_screen.dart';
import '../models/request_models.dart';
import '../providers/requests_provider.dart';

class RequestDetailScreen extends StatefulWidget {
  final int idSolicitud;

  const RequestDetailScreen({super.key, required this.idSolicitud});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestsProvider>().fetchDetail(widget.idSolicitud);
    });
  }

  void _handleCancel(BuildContext context) {
    AuraInputModal.show(
      context: context,
      title: 'Cancelar Solicitud',
      subtitle: 'Ingresa el motivo de cancelación del servicio.',
      placeholder: 'Motivo de cancelación...',
      actionLabel: 'Cancelar Solicitud',
      isDestructive: true,
      onSubmit: (motivo) async {
        final provider = context.read<RequestsProvider>();
        final error = await provider.cancelRequest(widget.idSolicitud, motivo);
        if (context.mounted) {
          if (error != null) {
            AuraSnackbar.showError(
              context,
              message: error.displayMessage,
              errorCode: error.codigoError,
            );
          } else {
            AuraSnackbar.showSuccess(context, message: 'Solicitud cancelada');
          }
        }
      },
    );
  }

  void _handleStartWork(BuildContext context) {
    AuraConfirmationModal.show(
      context: context,
      title: 'Iniciar Trabajo',
      description: '¿Confirmas que comenzarás a ejecutar el servicio ahora?',
      confirmText: 'Iniciar Trabajo',
      onConfirm: () async {
        final provider = context.read<RequestsProvider>();
        final error = await provider.startWork(widget.idSolicitud);
        if (context.mounted) {
          if (error != null) {
            AuraSnackbar.showError(
              context,
              message: error.displayMessage,
              errorCode: error.codigoError,
            );
          } else {
            AuraSnackbar.showSuccess(context, message: 'Servicio iniciado');
          }
        }
      },
    );
  }

  void _handleFinishWork(BuildContext context) {
    AuraInputModal.show(
      context: context,
      title: 'Finalizar Trabajo',
      subtitle: 'Ingresa una observación detallada del trabajo realizado.',
      placeholder: 'Observación final...',
      actionLabel: 'Finalizar',
      minChars: 1,
      maxChars: 5000,
      onSubmit: (observacion) async {
        final provider = context.read<RequestsProvider>();
        final error = await provider.finishWork(widget.idSolicitud, observacion);
        if (context.mounted) {
          if (error != null) {
            AuraSnackbar.showError(
              context,
              message: error.displayMessage,
              errorCode: error.codigoError,
            );
          } else {
            AuraSnackbar.showSuccess(context, message: 'Servicio finalizado con éxito');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text(
          'Detalle de Solicitud',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<RequestsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDetail && provider.currentDetail == null) {
            return const Center(
              child: CircularProgressIndicator(color: AuraColors.primary),
            );
          }

          final detail = provider.currentDetail;
          if (detail == null) {
            return Center(
              child: Text(
                'No se pudo cargar el detalle.',
                style: GoogleFonts.inter(color: AuraColors.textMuted),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Section
                Text(
                  detail.titulo,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AuraColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    AuraBadge.fromStatus(detail.estado),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.calendar, size: 14, color: AuraColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      detail.fechaCreacion,
                      style: GoogleFonts.inter(color: AuraColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Cards
                AuraCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(LucideIcons.tag, 'Categoría', detail.nombreCategoria),
                      const Divider(height: 20),
                      _buildInfoRow(LucideIcons.layers, 'Tipo', detail.nombreTipoServicio),
                      const Divider(height: 20),
                      _buildInfoRow(
                        detail.modalidad == 'PRESENCIAL' ? LucideIcons.mapPin : LucideIcons.monitor,
                        'Modalidad',
                        detail.modalidad == 'PRESENCIAL' ? 'Presencial' : 'Remoto',
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(LucideIcons.alertTriangle, 'Urgencia', detail.urgencia),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                AuraCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descripción',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        detail.descripcion,
                        style: GoogleFonts.inter(color: AuraColors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Conditional Private Data (RNF09)
                if (detail.isPrivateView) ...[
                  AuraCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.shieldCheck, size: 16, color: AuraColors.greenText),
                            const SizedBox(width: 6),
                            Text(
                              'Datos de Contacto (Vista Privada)',
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(LucideIcons.map, 'Dirección', detail.direccion ?? 'No especificada'),
                        if (detail.ubigeoDistrito != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(LucideIcons.navigation, 'Ubigeo', detail.ubigeoDistrito!),
                        ],
                        if (detail.clienteTelefono != null) ...[
                          const SizedBox(height: 12),
                          AuraButton(
                            label: 'Llamar al Cliente (${detail.clienteTelefono})',
                            icon: LucideIcons.phone,
                            variant: AuraButtonVariant.outline,
                            isExpanded: true,
                            onPressed: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AuraColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AuraColors.primaryBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.info, color: AuraColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Ubicación exacta y datos de contacto reservados (Visibles al adjudicar propuesta).',
                            style: GoogleFonts.inter(color: AuraColors.primaryText, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Assigned Technician & Chat
                if (detail.cotizacionGanadora != null) ...[
                  AuraCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Técnico Asignado',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AuraColors.primaryLight,
                              child: const Icon(LucideIcons.user, size: 20, color: AuraColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.cotizacionGanadora!.nombreTecnico.isNotEmpty
                                        ? detail.cotizacionGanadora!.nombreTecnico
                                        : 'Técnico asignado',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  Text(
                                    'S/ ${detail.cotizacionGanadora!.monto} · ${detail.cotizacionGanadora!.tiempoEstimado}',
                                    style: GoogleFonts.inter(fontSize: 12, color: AuraColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.messageSquare, color: AuraColors.primary),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      quoteId: detail.cotizacionGanadora!.idCotizacion,
                                      title: detail.titulo,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Payment Summary Section
                AuraCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen Económico',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _buildPaymentRow(
                        'Total Acordado',
                        detail.resumenPago.totalAcordado != null
                            ? 'S/ ${detail.resumenPago.totalAcordado}'
                            : 'Sin cotización aceptada',
                        isBold: true,
                      ),
                      const SizedBox(height: 6),
                      _buildPaymentRow(
                        'Total Pagado',
                        'S/ ${detail.resumenPago.totalPagado}',
                      ),
                      const Divider(height: 20),
                      _buildPaymentRow(
                        'Saldo Pendiente',
                        detail.resumenPago.saldoPendiente != null
                            ? 'S/ ${detail.resumenPago.saldoPendiente}'
                            : 'S/ 0.00',
                        isBold: true,
                        color: AuraColors.amberText,
                      ),
                      const SizedBox(height: 16),
                      AuraButton(
                        label: 'Ver Historial de Pagos',
                        icon: LucideIcons.wallet,
                        variant: AuraButtonVariant.outline,
                        isExpanded: true,
                        fontSize: 13,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentsScreen(
                                idSolicitud: detail.idSolicitud,
                                permiteRegistrar: detail.resumenPago.permiteRegistrarPago,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Observation final if finalized
                if (detail.observacionFinal != null) ...[
                  AuraCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observación de Cierre',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AuraColors.greenText),
                        ),
                        const SizedBox(height: 6),
                        Text(detail.observacionFinal!, style: GoogleFonts.inter(color: AuraColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Motivo cancelacion if cancelled
                if (detail.estado == 'CANCELADO' && detail.motivoCancelacion != null) ...[
                  AuraCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Motivo de Cancelación',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AuraColors.redText),
                        ),
                        const SizedBox(height: 6),
                        Text(detail.motivoCancelacion!, style: GoogleFonts.inter(color: AuraColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                _buildActionButtons(detail),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(SolicitudDetalle detail) {
    if (detail.permisos.puedeCancelar && detail.estado == 'PENDIENTE') {
      return AuraButton(
        label: 'Cancelar Solicitud',
        variant: AuraButtonVariant.destructive,
        isExpanded: true,
        onPressed: () => _handleCancel(context),
      );
    }

    if (detail.permisos.puedeIniciarTrabajo && detail.estado == 'ACEPTADO') {
      return AuraButton(
        label: 'Iniciar Trabajo',
        variant: AuraButtonVariant.primary,
        isExpanded: true,
        onPressed: () => _handleStartWork(context),
      );
    }

    if (detail.permisos.puedeFinalizar && detail.estado == 'EN_PROCESO') {
      return AuraButton(
        label: 'Finalizar Trabajo',
        variant: AuraButtonVariant.primary,
        isExpanded: true,
        onPressed: () => _handleFinishWork(context),
      );
    }

    if (detail.estado == 'FINALIZADO' && detail.calificacion == null) {
      return AuraButton(
        label: 'Calificar Servicio',
        variant: AuraButtonVariant.primary,
        isExpanded: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateReviewScreen(idSolicitud: detail.idSolicitud),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AuraColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 13, color: AuraColors.textMuted)),
              Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AuraColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AuraColors.textMuted)),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: color ?? AuraColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
