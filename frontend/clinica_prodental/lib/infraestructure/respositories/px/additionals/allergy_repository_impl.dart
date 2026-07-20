import 'package:clinica_prodental/core/api/response_api.dart';
import 'package:clinica_prodental/domain/datasources/px/additionals_patient/allergy_datasource.dart';
import 'package:clinica_prodental/domain/entities/px/additionals_px/allergy_entity.dart';
import 'package:clinica_prodental/domain/repositories/px/additionals_px/allergy_repository.dart';
import 'package:clinica_prodental/infraestructure/dtos/px/allergy/dtos_allergy.dart';

class AllergyRepositoryImpl extends AllergyRepository {
  final AllergyDatasource datasourceImpl;

  AllergyRepositoryImpl({required this.datasourceImpl});

  @override
  Future<ResponseApi<List<AllergyEntity>>> getAllergys() {
    return datasourceImpl.getAllergys();
  }

  @override
  Future<ResponseApi<AllergyEntity>> postAllergy(DtosAllergy dtosAllergy) {
    return datasourceImpl.postAllergy(dtosAllergy);
  }
}
