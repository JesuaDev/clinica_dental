import 'package:clinica_prodental/domain/entities/entities.dart';
import 'package:clinica_prodental/infraestructure/mappers/mappers.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class CitaMapper {
  static CitaEntity citaToEntity(CitaModelResponse citaResponse) => CitaEntity(
    idCita: citaResponse.idCita,
    reasonDate: citaResponse.reasonDate,
    dateCita: citaResponse.fechaCita,
    hourCita: citaResponse.hourCita,
    priceCita: citaResponse.priceCita ?? 0.0,
    diagnosis:
        citaResponse.diagnosis != null &&
            citaResponse.diagnosis.toString().isNotEmpty &&
            citaResponse.diagnosis != ' '
        ? citaResponse.diagnosis
        : 'No hay Diagnostico...',
    observation:
        citaResponse.observation != null &&
            citaResponse.diagnosis.toString().isNotEmpty &&
            citaResponse.diagnosis != ' '
        ? citaResponse.observation
        : 'No hay observación...',
    px: PxMapper.pxToEntity(citaResponse.px!),
    status:
        citaResponse.status != null &&
            citaResponse.status.toString().isNotEmpty &&
            citaResponse.status != ' '
        ? citaResponse.status
        : "No existe estado en está cita."
        
  );
}
