class PaginationLinksModel {
  final String first;
  final String last;
  final String? next;
  final String? prev;

  PaginationLinksModel({
    required this.first,
    required this.last,
    this.next,
    this.prev,
  });

  factory PaginationLinksModel.fromJson(Map<String, dynamic> json) {
    return PaginationLinksModel(
      first: json['first'],
      last: json['last'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}

class PaginationMetaModel {
  final int currentPage;
  final int from;
  final int lastPage;

  PaginationMetaModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
    );
  }
}