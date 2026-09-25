import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../models/payment_models.dart';

class PaymentsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<PagoResumen> _payments = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<PagoResumen> get payments => _payments;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPayments(int idSolicitud) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.get(
        ApiEndpoints.requestPayments(idSolicitud),
      );
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) =>
              PagoResumen.fromJson(e as Map<String, dynamic>))
          .toList();
      _payments = items;
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar pagos';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<ApiResponseError?> registerPayment(
      int idSolicitud, CreatePagoRequest request) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.registerPayment(idSolicitud),
        data: request.toJson(),
      );
      _isSubmitting = false;
      await fetchPayments(idSolicitud);
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  Future<ApiResponseError?> confirmPayment(
      int idSolicitud, int idPago) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.confirmPayment(idSolicitud, idPago),
      );
      _isSubmitting = false;
      await fetchPayments(idSolicitud);
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  Future<ApiResponseError?> rejectPayment(
      int idSolicitud, int idPago) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.rejectPayment(idSolicitud, idPago),
      );
      _isSubmitting = false;
      await fetchPayments(idSolicitud);
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
