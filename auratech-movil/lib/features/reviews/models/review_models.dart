class ReviewModel {
  final int idCalificacion;
  final int idSolicitud;
  final int puntuacion;
  final String? comentario;
  final String fechaCreacion;

  ReviewModel({
    required this.idCalificacion,
    required this.idSolicitud,
    required this.puntuacion,
    this.comentario,
    required this.fechaCreacion,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      idCalificacion: json['id_calificacion'] as int,
      idSolicitud: json['id_solicitud'] as int,
      puntuacion: json['puntuacion'] as int,
      comentario: json['comentario'] as String?,
      fechaCreacion: json['fecha_calificacion'] as String? ??
          json['fecha_creacion'] as String? ??
          '',
    );
  }
}

class CreateReviewRequest {
  final int idSolicitud;
  final int puntuacion;
  final String? comentario;

  CreateReviewRequest({
    required this.idSolicitud,
    required this.puntuacion,
    this.comentario,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id_solicitud': idSolicitud,
      'puntuacion': puntuacion,
    };
    if (comentario != null) map['comentario'] = comentario;
    return map;
  }
}
