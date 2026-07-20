import 'package:clinica_prodental/domain/entities/px/additionals_px/diseases_entity.dart';
import 'package:clinica_prodental/infraestructure/models/px/details/diseases_model.dart';

class DiseasesMapper {
  static DiseasesEntity diseasesToEntity(
    DiseaseModelResponse diseaseResponse,
  ) => DiseasesEntity(
    idDiaseases: diseaseResponse.idDiseases,
    nameDiseases:
        diseaseResponse.nameDiseases.isNotEmpty &&
            diseaseResponse.nameDiseases != " "
        ? diseaseResponse.nameDiseases
        : "Enfermedad desconocida.",

    descriptionDiseases:
        diseaseResponse.descriptionDiseases != null &&
            diseaseResponse.descriptionDiseases!.isNotEmpty &&
            diseaseResponse.descriptionDiseases != " "
        ? diseaseResponse.descriptionDiseases
        : "No hay descripción para esta enfermedad.",

    observationDiseases:
        diseaseResponse.observationDiseases != null &&
            diseaseResponse.observationDiseases!.isNotEmpty &&
            diseaseResponse.observationDiseases != " "
        ? diseaseResponse.observationDiseases
        : "No hay una observación para esta enfermedad",
  );
}
