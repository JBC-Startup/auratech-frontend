import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/badges/aura_badge.dart';
import '../../../core/widgets/cards/aura_card.dart';
import '../../chat/screens/chat_screen.dart';
import '../providers/quotes_provider.dart';

class MyQuotesScreen extends StatefulWidget {
  const MyQuotesScreen({super.key});

  @override
  State<MyQuotesScreen> createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuotesProvider>().fetchMyQuotes(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text('Mis Cotizaciones',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: Consumer<QuotesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.myQuotes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AuraColors.primary),
            );
          }

          if (provider.myQuotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.fileText, size: 40, color: AuraColors.textMuted),
                  const SizedBox(height: 12),
                  Text('No hay cotizaciones',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AuraColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Tus cotizaciones aparecerán aquí.',
                      style: GoogleFonts.inter(fontSize: 13, color: AuraColors.textMuted)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AuraColors.primary,
            onRefresh: () => provider.fetchMyQuotes(refresh: true),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.myQuotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final quote = provider.myQuotes[index];
                return AuraCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          quoteId: quote.idCotizacion,
                          title: quote.tituloSolicitud ?? 'Solicitud #${quote.idSolicitud}',
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(quote.tituloSolicitud ?? 'Solicitud #${quote.idSolicitud}',
                                style: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w600, color: AuraColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          AuraBadge.fromStatus(quote.estado),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(LucideIcons.banknote, size: 14, color: AuraColors.greenText),
                          const SizedBox(width: 4),
                          Text('S/ ${quote.monto}',
                              style: GoogleFonts.inter(
                                  fontSize: 15, fontWeight: FontWeight.w700, color: AuraColors.greenText)),
                          const Spacer(),
                          Icon(LucideIcons.clock, size: 12, color: AuraColors.textMuted),
                          const SizedBox(width: 4),
                          Text(quote.tiempoEstimado,
                              style: GoogleFonts.inter(fontSize: 12, color: AuraColors.textMuted)),
                        ],
                      ),
                      if (quote.descripcionTrabajo.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(quote.descripcionTrabajo,
                            style: GoogleFonts.inter(fontSize: 12, color: AuraColors.textMuted, height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
