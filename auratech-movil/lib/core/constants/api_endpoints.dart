class ApiEndpoints {
  // Auth (AUTH-01 a AUTH-08)
  static const String register = '/auth/registro';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refreshToken = '/auth/refresh';
  static const String recoverPassword = '/auth/recuperar-contrasena';
  static const String resetPassword = '/auth/restablecer-contrasena';
  static const String changePassword = '/auth/cambiar-contrasena';
  static const String logout = '/auth/logout';

  // Technicians (TEC-01 a TEC-08)
  static String technicianProfile(int id) => '/tecnicos/$id';
  static const String myTechnicianProfile = '/tecnicos/mi-perfil';
  static const String updateTechnicianProfile = '/tecnicos/mi-perfil';
  static const String technicianSpecialties =
      '/tecnicos/mi-perfil/especialidades';
  static String technicianDocuments(int id) => '/tecnicos/$id/documentos';
  static const String uploadDocument = '/tecnicos/mi-perfil/documentos';
  static const String technicianAvailability =
      '/tecnicos/mi-perfil/disponibilidad';
  static const String technicianStats = '/tecnicos/mi-perfil/estadisticas';

  // Catalog (CAT-01 a CAT-04)
  static const String categories = '/catalogo/categorias';
  static String categoryTypes(int categoryId) =>
      '/catalogo/categorias/$categoryId/tipos';
  static const String serviceTypes = '/catalogo/tipos-servicio';
  static const String suggestions = '/catalogo/sugerencias';

  // Requests (SOL-01 a SOL-11)
  static const String createRequest = '/solicitudes';
  static const String availableRequests = '/solicitudes/disponibles';
  static const String myRequests = '/solicitudes/mis-solicitudes';
  static String requestDetail(int id) => '/solicitudes/$id';
  static String requestEvidence(int id) => '/solicitudes/$id/evidencias';
  static String acceptRequest(int id) => '/solicitudes/$id/aceptar';
  static String startWork(int id) => '/solicitudes/$id/iniciar-trabajo';
  static String cancelRequest(int id) => '/solicitudes/$id/cancelar';
  static String finishRequest(int id) => '/solicitudes/$id/finalizar';
  static String requestQuotes(int id) => '/solicitudes/$id/cotizaciones';

  // Quotes (COT-01 a COT-06)
  static const String createQuote = '/cotizaciones';
  static String quoteDetail(int id) => '/cotizaciones/$id';
  static String acceptQuote(int id) => '/cotizaciones/$id/aceptar';
  static String rejectQuote(int id) => '/cotizaciones/$id/rechazar';
  static String withdrawQuote(int id) => '/cotizaciones/$id/retirar';
  static const String myQuotes = '/cotizaciones/mis-cotizaciones';

  // Chat (CHAT-01 a CHAT-04)
  static String chatMessages(int quoteId) =>
      '/cotizaciones/$quoteId/mensajes';
  static String sendMessage(int quoteId) =>
      '/cotizaciones/$quoteId/mensajes';
  static String chatMessage(int quoteId, int messageId) =>
      '/cotizaciones/$quoteId/mensajes/$messageId';

  // Payments (PAG-01 a PAG-05)
  static String requestPayments(int requestId) =>
      '/solicitudes/$requestId/pagos';
  static String registerPayment(int requestId) =>
      '/solicitudes/$requestId/pagos';
  static String paymentDetail(int requestId, int paymentId) =>
      '/solicitudes/$requestId/pagos/$paymentId';
  static String confirmPayment(int requestId, int paymentId) =>
      '/solicitudes/$requestId/pagos/$paymentId/confirmar';
  static String rejectPayment(int requestId, int paymentId) =>
      '/solicitudes/$requestId/pagos/$paymentId/rechazar';

  // Reviews (CAL-01 a CAL-02)
  static const String createReview = '/calificaciones';
  static String reviewDetail(int id) => '/calificaciones/$id';

  // Notifications (NOT-01 a NOT-02)
  static const String notifications = '/notificaciones';
  static String markNotificationRead(int id) => '/notificaciones/$id/leer';
}
