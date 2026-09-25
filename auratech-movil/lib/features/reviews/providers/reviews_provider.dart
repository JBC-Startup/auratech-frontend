import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error.dart';
import '../models/review_models.dart';

class ReviewsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<ApiResponseError?> createReview(
      CreateReviewRequest request) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.createReview,
        data: request.toJson(),
      );
      _isSubmitting = false;
      notifyListeners();
      return null;
    } on DioException catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return ApiClient.parseError(e);
    }
  }
}
