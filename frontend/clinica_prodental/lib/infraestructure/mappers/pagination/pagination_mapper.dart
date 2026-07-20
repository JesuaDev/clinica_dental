import 'package:clinica_prodental/domain/entities/pagination/pagination_entity.dart';
import 'package:clinica_prodental/infraestructure/models/models.dart';

class PaginationMapper {
  static PaginationEntity paginationToEntity(PaginationModel pagination) =>
      PaginationEntity(
        page: pagination.page,
        limit: pagination.limit,
        total: pagination.total,
        totalPages: pagination.totalPages,
        hasNext: pagination.hasNext,
        hasPrevius: pagination.hasPrevius,
      );
}
