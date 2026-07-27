class PxEntity {
  final int idPx;
  final String fullNamePx;
  final String? birthdatePx;
  final String? sexPx;
  final String? phone;
  final String? directionPx;

  final DateTime? lastAppointmentDate;

  const PxEntity({
    required this.idPx,
    required this.fullNamePx,
    this.birthdatePx,
    this.sexPx,
    this.phone,
    this.directionPx,
    this.lastAppointmentDate,
  });
}
