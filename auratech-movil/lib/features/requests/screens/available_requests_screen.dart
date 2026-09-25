import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/inputs/aura_search_bar.dart';
import '../providers/requests_provider.dart';
import '../widgets/request_card.dart';
import 'request_detail_screen.dart';

class AvailableRequestsScreen extends StatefulWidget {
  const AvailableRequestsScreen({super.key});

  @override
  State<AvailableRequestsScreen> createState() =>
      _AvailableRequestsScreenState();
}

class _AvailableRequestsScreenState
    extends State<AvailableRequestsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RequestsProvider>()
          .fetchAvailableRequests(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<RequestsProvider>();
      if (!provider.isLoadingAvailable &&
          (provider.availablePaginacion?.hasMore ?? false)) {
        provider.fetchAvailableRequests(
          offset: provider.availableRequests.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text('Servicios Disponibles',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: AuraSearchBar(
              hint: 'Buscar servicios...',
              controller: _searchController,
              onChanged: (value) {
                // TODO: Implement search filter
              },
            ),
          ),

          // List
          Expanded(
            child: Consumer<RequestsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingAvailable &&
                    provider.availableRequests.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AuraColors.primary,
                    ),
                  );
                }

                if (provider.availableRequests.isEmpty) {
                  return _EmptyState();
                }

                return RefreshIndicator(
                  color: AuraColors.primary,
                  onRefresh: () => provider
                      .fetchAvailableRequests(refresh: true),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                        16, 0, 16, 16),
                    itemCount:
                        provider.availableRequests.length +
                            (provider.isLoadingAvailable ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index >=
                          provider.availableRequests.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AuraColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final solicitud =
                          provider.availableRequests[index];
                      return RequestCard(
                        solicitud: solicitud,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RequestDetailScreen(
                                idSolicitud:
                                    solicitud.idSolicitud,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AuraColors.backgroundAlt,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.inbox,
                  size: 40, color: AuraColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay servicios disponibles',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AuraColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Los nuevos servicios aparecerán aquí cuando estén disponibles.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AuraColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
