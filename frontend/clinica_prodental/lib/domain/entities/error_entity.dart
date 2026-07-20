class ErrorEntity {
  final int? status;
  final String message;
  final String details;

  ErrorEntity({
    required this.status,
    required this.message,
    required this.details,
  });
}
