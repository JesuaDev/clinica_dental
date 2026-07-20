import 'package:clinica_prodental/domain/entities/pagination/pagination_entity.dart';

class ResponseApi<T> {
  final int? statusCode;
  final String message;
  final T data;
  final PaginationEntity? paginations;

  const ResponseApi({
    required this.statusCode,
    required this.message,
    required this.data,
    this.paginations,
  });
}
