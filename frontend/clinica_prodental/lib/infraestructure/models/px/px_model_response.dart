class PxModelResponse {
  final int idPx;
  final String fullName;
  final String? phonePx;
  final String? sexPx;
  final String? directionPx;
  final String? birthdatePx;
  final DateTime? lastAppointmentDate;

  PxModelResponse({
    required this.idPx,
    required this.fullName,
    this.phonePx,
    this.sexPx,
    this.directionPx,
    this.birthdatePx,
    this.lastAppointmentDate,
  });

  factory PxModelResponse.fromJson(Map<String, dynamic> json) =>
      PxModelResponse(
        idPx: json["id_px"] ?? 0,
        fullName: json["full_name"] ?? ' ',
        phonePx: json["phone_px"] ?? ' ',
        sexPx: json["sex_px"] as String?,
        directionPx: json["direction_px"] as String?,
        birthdatePx: json["birthdate_px"] ?? ' ',
        lastAppointmentDate: json["fecha_cita"] != null
            ? DateTime.parse(json["fecha_cita"].toString()).toLocal()
            : DateTime.now(),
      );

  factory PxModelResponse.empty() {
    return PxModelResponse(idPx: 0, fullName: '', phonePx: '');
  }

  Map<String, dynamic> toJson() => {
    "id_px": idPx,
    "full_name": fullName,
    "phone_px": phonePx,
  };
}
