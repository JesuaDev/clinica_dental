class DtosMedicalRecord {
  final String name;
  final String? description;
  final DateTime dateComplete;
  final bool isComplete;

  DtosMedicalRecord({
    required this.name,
    this.description,
    required this.dateComplete,
    required this.isComplete,
  });

  Map<String, dynamic> toJson() {
    return {
      "medical_record": name,
      "description_record": description,
      "date_complete": dateComplete,
      "complete": isComplete,
    };
  }
}
