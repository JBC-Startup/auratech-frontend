import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../models/request_models.dart';

class RequestsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  // Available requests
  List<SolicitudResumen> _availableRequests = [];
  PaginacionInfo? _availablePaginacion;
  bool _isLoadingAvailable = false;

  // My requests
  List<SolicitudResumen> _myRequests = [];
  PaginacionInfo? _myPaginacion;
  bool _isLoadingMy = false;

  // Detail
  SolicitudDetalle? _currentDetail;
  bool _isLoadingDetail = false;

  // General
  String? _errorMessage;
  bool _isSubmitting = false;

  // Getters
  List<SolicitudResumen> get availableRequests => _availableRequests;
  PaginacionInfo? get availablePaginacion => _availablePaginacion;
  bool get isLoadingAvailable => _isLoadingAvailable;

  List<SolicitudResumen> get myRequests => _myRequests;
  PaginacionInfo? get myPaginacion => _myPaginacion;
  bool get isLoadingMy => _isLoadingMy;

  SolicitudDetalle? get currentDetail => _currentDetail;
  bool get isLoadingDetail => _isLoadingDetail;

  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;

  Future<void> fetchAvailableRequests({
    int limit = 20,
    int offset = 0,
    bool refresh = false,
  }) async {
    if (refresh) {
      _availableRequests = [];
      offset = 0;
    }
    _isLoadingAvailable = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.get(
        ApiEndpoints.availableRequests,
        queryParams: {'limit': limit, 'offset': offset},
      );
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) =>
              SolicitudResumen.fromJson(e as Map<String, dynamic>))
          .toList();

      _availablePaginacion = PaginacionInfo.fromJson(
          data['paginacion'] as Map<String, dynamic>);

      if (refresh || offset == 0) {
        _availableRequests = items;
      } else {
        _availableRequests.addAll(items);
      }
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar solicitudes disponibles';
    }

    _isLoadingAvailable = false;
    notifyListeners();
  }

  Future<void> fetchMyRequests({
    int limit = 20,
    int offset = 0,
    bool refresh = false,
  }) async {
    if (refresh) {
      _myRequests = [];
      offset = 0;
    }
    _isLoadingMy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.get(
        ApiEndpoints.myRequests,
        queryParams: {'limit': limit, 'offset': offset},
      );
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) =>
              SolicitudResumen.fromJson(e as Map<String, dynamic>))
          .toList();

      _myPaginacion = PaginacionInfo.fromJson(
          data['paginacion'] as Map<String, dynamic>);

      if (refresh || offset == 0) {
        _myRequests = items;
      } else {
        _myRequests.addAll(items);
      }
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar mis solicitudes';
    }

    _isLoadingMy = false;
    notifyListeners();
  }

  Future<void> fetchDetail(int idSolicitud) async {
    _isLoadingDetail = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.get(
        ApiEndpoints.requestDetail(idSolicitud),
      );
      _currentDetail = SolicitudDetalle.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar detalle de solicitud';
    }

    _isLoadingDetail = false;
    notifyListeners();
  }

  Future<ApiResponseError?> createRequest(
      CreateSolicitudRequest request) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.createRequest,
        data: request.toJson(),
      );
      _isSubmitting = false;
      notifyListeners();
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiResponseError(detail: 'Error inesperado');
    }
  }

  Future<ApiResponseError?> cancelRequest(
      int idSolicitud, String motivo) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.cancelRequest(idSolicitud),
        data: {'motivo_cancelacion': motivo},
      );
      _isSubmitting = false;
      await fetchDetail(idSolicitud);
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  Future<ApiResponseError?> startWork(int idSolicitud) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(ApiEndpoints.startWork(idSolicitud));
      _isSubmitting = false;
      await fetchDetail(idSolicitud);
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  Future<ApiResponseError?> finishWork(
      int idSolicitud, String observacion) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.finishRequest(idSolicitud),
        data: {'observacion_final': observacion},
      );
      _isSubmitting = false;
      await fetchDetail(idSolicitud);
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
