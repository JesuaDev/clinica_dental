import 'package:flutter/material.dart';

class DtosDateAppoitment {
  final int idPx;
  final int? idDentist;
  final String reasonAppoitment;
  final DateTime fechaAppoitment;
  final String hourDate;
  final double price;
  final String? diagnosis;
  final String? observation;

  DtosDateAppoitment({
    required this.reasonAppoitment,
    required this.fechaAppoitment,
    required this.hourDate,
    required this.price,
    this.diagnosis,
    this.observation,
    required this.idPx,
    this.idDentist,
  });

  Map<String, dynamic> toJson() {
    debugPrint(price.toString());
    return {
      "id_px": idPx,
      "id_dentist": idDentist,
      "reason_appoitment": reasonAppoitment,
      "fecha_appoitment": fechaAppoitment.toIso8601String(),
      "hour_date": hourDate,
      "price": price,
      "diagnosis": diagnosis,
      "observation": observation,
    };
  }
}

//1C2B4A7D8C
