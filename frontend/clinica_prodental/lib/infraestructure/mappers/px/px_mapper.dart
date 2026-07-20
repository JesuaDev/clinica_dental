import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class PxMapper {
  static PxEntity pxToEntity(PxModelResponse pxResponse) => PxEntity(
    idPx: pxResponse.idPx,
    fullNamePx: pxResponse.fullName,
    phone: pxResponse.phonePx,
    birthdatePx: pxResponse.birthdatePx,
    sexPx:
        pxResponse.sexPx != null &&
            pxResponse.sexPx.toString().isNotEmpty &&
            pxResponse.sexPx != ' '
        ? pxResponse.sexPx
        : 'Indefinido',
    directionPx:
        pxResponse.directionPx != null &&
            pxResponse.directionPx.toString().isNotEmpty &&
            pxResponse.directionPx != ' '
        ? pxResponse.directionPx
        : 'No hay dirección...',
    lastAppointmentDate: pxResponse.lastAppointmentDate,
  );
}
