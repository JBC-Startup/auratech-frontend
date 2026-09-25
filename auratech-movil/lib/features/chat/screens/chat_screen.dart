import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/inputs/aura_text_field.dart';
import '../models/chat_models.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final int quoteId;
  final String title;

  const ChatScreen({
    super.key,
    required this.quoteId,
    required this.title,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchMessages(widget.quoteId);
    });
    // Iniciar sondeo periódico cada 5s según especificación 5.5
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        context.read<ChatProvider>().pollNewMessages(widget.quoteId);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    _msgController.clear();
    final ok = await context.read<ChatProvider>().sendMessage(widget.quoteId, text);
    if (ok && _scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              'Negociación de cotización #${widget.quoteId}',
              style: GoogleFonts.inter(fontSize: 11, color: AuraColors.textMuted),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AuraColors.primary));
                }

                if (provider.messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.messageSquare, size: 36, color: AuraColors.border),
                          const SizedBox(height: 12),
                          Text(
                            'Inicia la conversación',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AuraColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Puedes acordar detalles técnicos antes de adjudicar el servicio.',
                            style: GoogleFonts.inter(fontSize: 12, color: AuraColors.textMuted),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Lo más reciente abajo
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    return _ChatBubble(mensaje: msg);
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AuraColors.surface,
        border: Border(top: BorderSide(color: AuraColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AuraTextField(
                controller: _msgController,
                hint: 'Escribe un mensaje...',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: AuraColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final MensajeChat mensaje;

  const _ChatBubble({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final isMe = mensaje.esMio;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AuraColors.primary : AuraColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isMe ? null : Border.all(color: AuraColors.border),
          boxShadow: [
            BoxShadow(
              color: AuraColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe && mensaje.nombreRemitente.isNotEmpty) ...[
              Text(
                mensaje.nombreRemitente,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AuraColors.primaryText,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              mensaje.contenido,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isMe ? Colors.white : AuraColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mensaje.fechaEnvio,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isMe ? Colors.white.withOpacity(0.7) : AuraColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
