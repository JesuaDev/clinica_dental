class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevius;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevius,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      PaginationModel(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        totalPages: json["totalPages"],
        hasNext: json["hasNext"],
        hasPrevius: json["hasPrevius"],
      );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
    "hasNext": hasNext,
    "hasPrevius": hasPrevius,
  };
}
