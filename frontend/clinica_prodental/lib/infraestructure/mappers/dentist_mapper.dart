import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class DentistMapper {
  static DentistEntity dentistToEntity(DentistModelResponse dentistResponse) =>
      DentistEntity(
        idDentist: dentistResponse.idDentist,
        nameDentist: dentistResponse.nameDentist,
        lastNameDentist:
            dentistResponse.lastName != null &&
                dentistResponse.lastName.toString().isNotEmpty &&
                dentistResponse.lastName != ' '
            ? dentistResponse.lastName
            : 'Uknow',
        available: dentistResponse.available,
      );
}
