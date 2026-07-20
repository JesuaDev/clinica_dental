import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class AllergyMapper {
  static AllergyEntity allergyToEntity(AllergyResponse allergyResponse) =>
      AllergyEntity(
        idAllergy: allergyResponse.idAllergy,
        nameAllergy:
            allergyResponse.nameAllergy.isNotEmpty &&
                allergyResponse.nameAllergy != " "
            ? allergyResponse.nameAllergy
            : "Alergia desconocida.",
        descriptionAllergy:
            allergyResponse.descriptionAllergy != null &&
                allergyResponse.descriptionAllergy!.isNotEmpty &&
                allergyResponse.descriptionAllergy != " "
            ? allergyResponse.descriptionAllergy
            : "No existe descripción de esta alergia",
      );
}
