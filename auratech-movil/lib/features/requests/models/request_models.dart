class PaginacionInfo {
  final int limit;
  final int offset;
  final int total;
  final bool hasMore;

  PaginacionInfo({
    required this.limit,
    required this.offset,
    required this.total,
    required this.hasMore,
  });

  factory PaginacionInfo.fromJson(Map<String, dynamic> json) {
    return PaginacionInfo(
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      total: json['total'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final PaginacionInfo paginacion;

  PaginatedResponse({required this.items, required this.paginacion});
}

class SolicitudResumen {
  final int idSolicitud;
  final String titulo;
  final String descripcion;
  final String modalidad;
  final String estado;
  final String urgencia;
  final String nombreCategoria;
  final String nombreTipoServicio;
  final String fechaCreacion;
  final String? ubigeoDistrito;
  final String? vista;

  SolicitudResumen({
    required this.idSolicitud,
    required this.titulo,
    required this.descripcion,
    required this.modalidad,
    required this.estado,
    required this.urgencia,
    required this.nombreCategoria,
    required this.nombreTipoServicio,
    required this.fechaCreacion,
    this.ubigeoDistrito,
    this.vista,
  });

  factory SolicitudResumen.fromJson(Map<String, dynamic> json) {
    return SolicitudResumen(
      idSolicitud: json['id_solicitud'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      modalidad: json['modalidad'] as String,
      estado: json['estado'] as String,
      urgencia: json['urgencia'] as String,
      nombreCategoria: json['nombre_categoria'] as String,
      nombreTipoServicio: json['nombre_tipo_servicio'] as String,
      fechaCreacion: json['fecha_creacion'] as String,
      ubigeoDistrito: json['ubigeo_distrito'] as String?,
      vista: json['vista'] as String?,
    );
  }
}

class SolicitudDetalle {
  final int idSolicitud;
  final String titulo;
  final String descripcion;
  final String modalidad;
  final String estado;
  final String urgencia;
  final String nombreCategoria;
  final String nombreTipoServicio;
  final String fechaCreacion;
  final String? ubigeoDistrito;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final String? clienteTelefono;
  final List<Evidencia> evidencias;
  final CotizacionGanadora? cotizacionGanadora;
  final ResumenPago resumenPago;
  final Permisos permisos;
  final dynamic calificacion;
  final String? motivoCancelacion;
  final String? observacionFinal;
  final String vista;

  SolicitudDetalle({
    required this.idSolicitud,
    required this.titulo,
    required this.descripcion,
    required this.modalidad,
    required this.estado,
    required this.urgencia,
    required this.nombreCategoria,
    required this.nombreTipoServicio,
    required this.fechaCreacion,
    this.ubigeoDistrito,
    this.direccion,
    this.latitud,
    this.longitud,
    this.clienteTelefono,
    this.evidencias = const [],
    this.cotizacionGanadora,
    required this.resumenPago,
    required this.permisos,
    this.calificacion,
    this.motivoCancelacion,
    this.observacionFinal,
    required this.vista,
  });

  factory SolicitudDetalle.fromJson(Map<String, dynamic> json) {
    final solicitud =
        json['solicitud'] as Map<String, dynamic>? ?? json;
    return SolicitudDetalle(
      idSolicitud: solicitud['id_solicitud'] as int,
      titulo: solicitud['titulo'] as String,
      descripcion: solicitud['descripcion'] as String,
      modalidad: solicitud['modalidad'] as String,
      estado: solicitud['estado'] as String,
      urgencia: solicitud['urgencia'] as String,
      nombreCategoria: solicitud['nombre_categoria'] as String,
      nombreTipoServicio:
          solicitud['nombre_tipo_servicio'] as String,
      fechaCreacion: solicitud['fecha_creacion'] as String,
      ubigeoDistrito: solicitud['ubigeo_distrito'] as String?,
      direccion: solicitud['direccion'] as String?,
      latitud: (solicitud['latitud'] as num?)?.toDouble(),
      longitud: (solicitud['longitud'] as num?)?.toDouble(),
      clienteTelefono: solicitud['cliente_telefono'] as String?,
      evidencias: (solicitud['evidencias'] as List<dynamic>?)
              ?.map((e) =>
                  Evidencia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cotizacionGanadora:
          solicitud['cotizacion_ganadora'] != null
              ? CotizacionGanadora.fromJson(
                  solicitud['cotizacion_ganadora']
                      as Map<String, dynamic>)
              : null,
      resumenPago: ResumenPago.fromJson(
          solicitud['resumen_pago'] as Map<String, dynamic>),
      permisos: Permisos.fromJson(
          solicitud['permisos'] as Map<String, dynamic>),
      calificacion: solicitud['calificacion'],
      motivoCancelacion:
          solicitud['motivo_cancelacion'] as String?,
      observacionFinal:
          solicitud['observacion_final'] as String?,
      vista: json['vista'] as String? ?? 'PREVIA',
    );
  }

  bool get isPrivateView => vista == 'PRIVADA';
  bool get isTerminal =>
      estado == 'FINALIZADO' || estado == 'CANCELADO';
}

class ResumenPago {
  final String? totalAcordado;
  final String totalPagado;
  final String? saldoPendiente;
  final String estadoPago;
  final bool permiteRegistrarPago;

  ResumenPago({
    this.totalAcordado,
    required this.totalPagado,
    this.saldoPendiente,
    required this.estadoPago,
    required this.permiteRegistrarPago,
  });

  factory ResumenPago.fromJson(Map<String, dynamic> json) {
    return ResumenPago(
      totalAcordado: json['total_acordado'] as String?,
      totalPagado: json['total_pagado'] as String? ?? '0.00',
      saldoPendiente: json['saldo_pendiente'] as String?,
      estadoPago: json['estado_pago'] as String? ??
          'SIN_COTIZACION_ACEPTADA',
      permiteRegistrarPago:
          json['permite_registrar_pago'] as bool? ?? false,
    );
  }
}

class Permisos {
  final bool verDatosPrivados;
  final bool puedeCotizar;
  final bool puedeCancelar;
  final bool puedeIniciarTrabajo;
  final bool puedeFinalizar;

  Permisos({
    this.verDatosPrivados = false,
    this.puedeCotizar = false,
    this.puedeCancelar = false,
    this.puedeIniciarTrabajo = false,
    this.puedeFinalizar = false,
  });

  factory Permisos.fromJson(Map<String, dynamic> json) {
    return Permisos(
      verDatosPrivados:
          json['ver_datos_privados'] as bool? ?? false,
      puedeCotizar: json['puede_cotizar'] as bool? ?? false,
      puedeCancelar: json['puede_cancelar'] as bool? ?? false,
      puedeIniciarTrabajo:
          json['puede_iniciar_trabajo'] as bool? ?? false,
      puedeFinalizar: json['puede_finalizar'] as bool? ?? false,
    );
  }
}

class Evidencia {
  final int idEvidencia;
  final String? urlTemporal;
  final String? descripcion;
  final String fechaSubida;

  Evidencia({
    required this.idEvidencia,
    this.urlTemporal,
    this.descripcion,
    required this.fechaSubida,
  });

  factory Evidencia.fromJson(Map<String, dynamic> json) {
    return Evidencia(
      idEvidencia: json['id_evidencia'] as int,
      urlTemporal: json['url_temporal'] as String?,
      descripcion: json['descripcion'] as String?,
      fechaSubida: json['fecha_subida'] as String,
    );
  }
}

class CotizacionGanadora {
  final int idCotizacion;
  final String monto;
  final String tiempoEstimado;
  final String nombreTecnico;
  final String? fotoTecnico;

  CotizacionGanadora({
    required this.idCotizacion,
    required this.monto,
    required this.tiempoEstimado,
    this.nombreTecnico = '',
    this.fotoTecnico,
  });

  factory CotizacionGanadora.fromJson(Map<String, dynamic> json) {
    return CotizacionGanadora(
      idCotizacion: json['id_cotizacion'] as int,
      monto: json['monto'] as String,
      tiempoEstimado: json['tiempo_estimado'] as String,
      nombreTecnico: json['nombre_tecnico'] as String? ?? '',
      fotoTecnico: json['foto_tecnico'] as String?,
    );
  }
}

class CreateSolicitudRequest {
  final String titulo;
  final String descripcion;
  final int idTipoServicio;
  final String modalidad;
  final String urgencia;
  final String? direccion;
  final String? ubigeoDistrito;
  final double? latitud;
  final double? longitud;

  CreateSolicitudRequest({
    required this.titulo,
    required this.descripcion,
    required this.idTipoServicio,
    required this.modalidad,
    required this.urgencia,
    this.direccion,
    this.ubigeoDistrito,
    this.latitud,
    this.longitud,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'titulo': titulo,
      'descripcion': descripcion,
      'id_tipo_servicio': idTipoServicio,
      'modalidad': modalidad,
      'urgencia': urgencia,
    };
    if (direccion != null) map['direccion'] = direccion;
    if (ubigeoDistrito != null) {
      map['ubigeo_distrito'] = ubigeoDistrito;
    }
    if (latitud != null) map['latitud'] = latitud;
    if (longitud != null) map['longitud'] = longitud;
    return map;
  }
}
