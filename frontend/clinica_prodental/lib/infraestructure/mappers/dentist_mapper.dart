import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class DentistMapper {
  static DentistEntity dentistToEntity(DentistModelResponse dentistResponse) =>
      DentistEntity(
        idDentist: dentistResponse.idDentist,
        nameDentist: dentistResponse.nameDentist,
        lastNameDentist:
            dentistResponse.lastNameDentist != null &&
                dentistResponse.lastNameDentist.toString().isNotEmpty &&
                dentistResponse.lastNameDentist != ' '
            ? dentistResponse.lastNameDentist
            : 'Uknow',
        available: dentistResponse.available,
        phone:
            dentistResponse.phone != null &&
                dentistResponse.phone.toString().isNotEmpty &&
                dentistResponse.phone != ' '
            ? dentistResponse.phone
            : 'Sin número de teléfono',
        age: dentistResponse.age,
        specialty:
            dentistResponse.specialty != null &&
                dentistResponse.specialty.toString().isNotEmpty &&
                dentistResponse.specialty != ' '
            ? dentistResponse.specialty
            : 'Sin especialidades.',

        email:
            dentistResponse.email != null &&
                dentistResponse.email.toString().isNotEmpty &&
                dentistResponse.email != ' '
            ? dentistResponse.email
            : 'Sin correo electrónico.',

        birthdate: dentistResponse.birthdate,
      );
}
