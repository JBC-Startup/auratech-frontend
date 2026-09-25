import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../models/quote_models.dart';

class QuotesProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<CotizacionResumen> _myQuotes = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<CotizacionResumen> get myQuotes => _myQuotes;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyQuotes({int limit = 20, int offset = 0, bool refresh = false}) async {
    if (refresh) {
      _myQuotes = [];
      offset = 0;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.get(
        ApiEndpoints.myQuotes,
        queryParams: {'limit': limit, 'offset': offset},
      );
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((e) => CotizacionResumen.fromJson(e as Map<String, dynamic>))
          .toList();

      if (refresh || offset == 0) {
        _myQuotes = items;
      } else {
        _myQuotes.addAll(items);
      }
    } on DioException catch (e) {
      _errorMessage = ApiClient.parseError(e).displayMessage;
    } catch (e) {
      _errorMessage = 'Error al cargar cotizaciones';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<ApiResponseError?> createQuote(CreateCotizacionRequest request) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(ApiEndpoints.createQuote, data: request.toJson());
      _isSubmitting = false;
      notifyListeners();
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }

  Future<ApiResponseError?> withdrawQuote(int idCotizacion) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await _api.post(ApiEndpoints.withdrawQuote(idCotizacion));
      _isSubmitting = false;
      await fetchMyQuotes(refresh: true);
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
