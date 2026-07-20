import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/allergy_entity.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/allergy/dtos_allergy.dart';

abstract class AllergyRepository {
  Future<ResponseApi<List<AllergyEntity>>> getAllergys();
  Future<ResponseApi<AllergyEntity>> postAllergy(DtosAllergy dtosAllergy);
}
