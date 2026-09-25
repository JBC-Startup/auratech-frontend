class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://auratech-backend-iehb.onrender.com/api/v1',
  );
  static const Duration timeout = Duration(seconds: 60);
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
