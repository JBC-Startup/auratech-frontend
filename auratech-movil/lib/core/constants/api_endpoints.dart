class ApiEndpoints {
  // Auth (AUTH-01 a AUTH-08)
  static const String register = '/auth/registro';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String myPhoto = '/auth/me/foto';
  static const String refreshToken = '/auth/refresh';
  static const String recoverPassword = '/auth/recuperar-password/solicitar';
  static const String resetPassword = '/auth/recuperar-password/restablecer';
  static const String changePassword = '/auth/cambiar-contrasena';
  static const String logout = '/auth/logout';

  // Technicians (TEC-01 a TEC-08)
  static String technicianProfile(int id) => '/tecnicos/$id';
  static const String myTechnicianProfile = '/tecnicos/perfil';
  static const String updateTechnicianProfile = '/tecnicos/perfil';
  static const String technicianSpecialties = '/tecnicos/especialidades';
  static const String technicianDocuments = '/tecnicos/documentos';
  static const String uploadDocument = '/tecnicos/documentos';
  static String deleteDocument(int id) => '/tecnicos/documentos/$id';
  static const String technicianAvailability = '/tecnicos/perfil';
  static const String technicianStats = '/tecnicos/perfil';

  // Catalog (CAT-01 a CAT-04)
  static const String categories = '/catalogo/categorias';
  static String categoryTypes(int categoryId) =>
      '/catalogo/tipos-servicio?id_categoria=$categoryId';
  static const String serviceTypes = '/catalogo/tipos-servicio';
  static const String suggestions = '/catalogo/tipos-servicio/sugerir';
  static const String mySuggestions = '/catalogo/mis-sugerencias';

  // Requests (SOL-01 a SOL-11)
  static const String createRequest = '/solicitudes';
  static const String availableRequests = '/solicitudes/disponibles';
  static const String myRequests = '/solicitudes/mis-solicitudes';
  static const String myAssignedJobs = '/solicitudes/mis-trabajos';
  static String requestDetail(int id) => '/solicitudes/$id';
  static String requestEvidence(int id) => '/solicitudes/$id/evidencias';
  static String startWork(int id) => '/solicitudes/$id/iniciar';
  static String cancelRequest(int id) => '/solicitudes/$id/cancelar';
  static String finishRequest(int id) => '/solicitudes/$id/finalizar';
  static String requestQuotes(int id) => '/cotizaciones/solicitud/$id';

  // Quotes (COT-01 a COT-06)
  static const String createQuote = '/cotizaciones';
  static String quoteDetail(int id) => '/cotizaciones/$id';
  static String acceptQuote(int id) => '/cotizaciones/$id/aceptar';
  static String withdrawQuote(int id) => '/cotizaciones/$id/retirar';
  static const String myQuotes = '/cotizaciones/mis-propuestas';

  // Chat (CHAT-01 a CHAT-04)
  static String chatMessages(int quoteId) =>
      '/chat/cotizacion/$quoteId/mensajes';
  static String sendMessage(int quoteId) =>
      '/chat/cotizacion/$quoteId/mensajes';
  static String chatMessageRead(int messageId) =>
      '/chat/mensajes/$messageId/leido';

  // Payments (PAG-01 a PAG-05)
  static String requestPayments(int requestId) =>
      '/pagos/solicitud/$requestId';
  static const String registerPayment = '/pagos';
  static String paymentDetail(int paymentId) => '/pagos/$paymentId';
  static String confirmPayment(int paymentId) =>
      '/pagos/$paymentId/confirmar';
  static String rejectPayment(int paymentId) =>
      '/pagos/$paymentId/rechazar';

  // Reviews (CAL-01 a CAL-02)
  static const String createReview = '/calificaciones';
  static String technicianReputation(int idTecnico) =>
      '/calificaciones/tecnico/$idTecnico';

  // Notifications (NOT-01 a NOT-02)
  static const String notifications = '/notificaciones';
  static String markNotificationRead(int id) => '/notificaciones/$id/leer';
}
