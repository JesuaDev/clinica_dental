import 'package:clinica_prodental/helpers/format/date/combinate_date.dart';

class PxDentalRecordForm {
  final int index;
  final String name;
  final String? description;
  final DateTime? dateCita;
  final bool isComplete;

  PxDentalRecordForm({
    required this.index,
    required this.name,
    this.description,
    required this.dateCita,
    required this.isComplete,
  });

  Map<String, dynamic> toJson() {
    return {
      "dental_record": name,
      "description_record": description,
      "date_cita": dateCita != null
          ? DateFormater.parseDate(dateCita!)
          : DateFormater.parseDate(DateTime.now()),
      "complete": isComplete,
    };
  }
}
