import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/aura_button.dart';
import '../models/request_models.dart';
import '../providers/requests_provider.dart';
import '../widgets/request_card.dart';
import 'create_request_screen.dart';
import 'request_detail_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestsProvider>().fetchMyRequests(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<RequestsProvider>().fetchMyRequests(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Text(
          'Mis Solicitudes',
          style: GoogleFonts.inter(
            color: AuraColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AuraButton(
              label: 'Nueva',
              icon: LucideIcons.plus,
              variant: AuraButtonVariant.outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
                );
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AuraColors.primary,
          unselectedLabelColor: AuraColors.textSecondary,
          indicatorColor: AuraColors.primary,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Pendientes'),
            Tab(text: 'En Proceso'),
            Tab(text: 'Finalizados'),
          ],
        ),
      ),
      body: Consumer<RequestsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingMy && provider.myRequests.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AuraColors.primary));
          }

          if (provider.errorMessage != null && provider.myRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle, size: 40, color: AuraColors.redText),
                  const SizedBox(height: 12),
                  Text(
                    provider.errorMessage!,
                    style: GoogleFonts.inter(color: AuraColors.textPrimary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AuraButton(
                    label: 'Reintentar',
                    onPressed: _onRefresh,
                  ),
                ],
              ),
            );
          }

          final allRequests = provider.myRequests;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRequestList(allRequests),
              _buildRequestList(allRequests.where((r) => r.estado == 'PENDIENTE').toList()),
              _buildRequestList(allRequests.where((r) => r.estado == 'EN_PROCESO' || r.estado == 'ACEPTADO').toList()),
              _buildRequestList(allRequests.where((r) => r.estado == 'FINALIZADO' || r.estado == 'CANCELADO').toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequestList(List<SolicitudResumen> requests) {
    if (requests.isEmpty) {
      return RefreshIndicator(
        color: AuraColors.primary,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.inbox, size: 48, color: AuraColors.border),
                const SizedBox(height: 12),
                Text(
                  'No hay solicitudes en esta sección',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AuraColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AuraColors.primary,
      onRefresh: _onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final request = requests[index];
          return RequestCard(
            solicitud: request,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RequestDetailScreen(idSolicitud: request.idSolicitud),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
