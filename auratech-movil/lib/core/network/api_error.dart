class ApiResponseError {
  final String detail;
  final String? codigoError;
  final List<ApiFieldError> errores;
  final int? statusCode;

  ApiResponseError({
    required this.detail,
    this.codigoError,
    this.errores = const [],
    this.statusCode,
  });

  factory ApiResponseError.fromJson(Map<String, dynamic> json,
      {int? statusCode}) {
    String parsedDetail = 'Error desconocido';
    if (json['detail'] is String) {
      parsedDetail = json['detail'] as String;
    } else if (json['detail'] is List) {
      final list = json['detail'] as List;
      parsedDetail = list
          .map((item) => item is Map ? (item['msg'] ?? item.toString()) : item.toString())
          .join('\n');
    } else if (json['detail'] != null) {
      parsedDetail = json['detail'].toString();
    }

    return ApiResponseError(
      detail: parsedDetail,
      codigoError: json['codigo_error'] as String?,
      errores: (json['errores'] as List<dynamic>?)
              ?.map((e) => ApiFieldError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statusCode: statusCode,
    );
  }

  String get displayMessage {
    if (errores.isNotEmpty) {
      return errores.map((e) => e.mensaje).join('\n');
    }
    return detail;
  }

  bool get isConflict => statusCode == 409;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
}

class ApiFieldError {
  final String campo;
  final String mensaje;

  ApiFieldError({required this.campo, required this.mensaje});

  factory ApiFieldError.fromJson(Map<String, dynamic> json) {
    return ApiFieldError(
      campo: json['campo'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
    );
  }
}
