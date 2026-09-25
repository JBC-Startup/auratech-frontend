import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/chat_models.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<MensajeChat> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  List<MensajeChat> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  int? get latestMessageId => _messages.isNotEmpty ? _messages.first.idMensaje : null;

  Future<void> fetchMessages(int quoteId, {int? antesDe, int? despuesDe}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final query = <String, dynamic>{};
      if (antesDe != null) query['antes_de'] = antesDe;
      if (despuesDe != null) query['despues_de'] = despuesDe;

      final response = await _api.get(
        ApiEndpoints.chatMessages(quoteId),
        queryParams: query.isNotEmpty ? query : null,
      );

      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) => MensajeChat.fromJson(e as Map<String, dynamic>))
          .toList();

      if (despuesDe != null) {
        _messages.insertAll(0, items);
      } else if (antesDe != null) {
        _messages.addAll(items);
      } else {
        _messages = items;
      }
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar mensajes del chat';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendMessage(int quoteId, String content) async {
    if (content.trim().isEmpty) return false;

    _isSending = true;
    notifyListeners();

    try {
      final response = await _api.post(
        ApiEndpoints.sendMessage(quoteId),
        data: SendMessageRequest(contenido: content.trim()).toJson(),
      );

      final nuevo = MensajeChat.fromJson(response.data as Map<String, dynamic>);
      _messages.insert(0, nuevo);
      _isSending = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
      _isSending = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error al enviar mensaje';
      _isSending = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> pollNewMessages(int quoteId) async {
    if (_messages.isEmpty) return;
    try {
      final mayorId = _messages.first.idMensaje;
      final response = await _api.get(
        ApiEndpoints.chatMessages(quoteId),
        queryParams: {'despues_de': mayorId},
      );
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) => MensajeChat.fromJson(e as Map<String, dynamic>))
          .toList();

      if (items.isNotEmpty) {
        _messages.insertAll(0, items);
        notifyListeners();
      }
    } catch (_) {}
  }
}
