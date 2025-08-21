class ApiResponse<T> {
  final List<T> data;
  final Links links;
  final Meta meta;
  final String message;
  final int code;
  final String type;

  ApiResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.message,
    required this.code,
    required this.type,
  });

  factory ApiResponse.fromJson(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    if (raw is! Map<String, dynamic>) {
      // non-JSON or unexpected HTML/text
      return ApiResponse<T>(
        data: const [],
        links: Links.fromJson(const {}),
        meta: Meta.fromJson(const {}),
        message: 'استجابة غير متوقعة من الخادم',
        code: 0,
        type: 'error',
      );
    }
    final json = raw;
    final list = (json['data'] as List? ?? []);
    return ApiResponse<T>(
      data: list.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      links: Links.fromJson(json['links'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
      message: json['message']?.toString() ?? '',
      code: json['code'] is int ? json['code'] : 0,
      type: json['type']?.toString() ?? '',
    );
  }
}

class Links {
  final String? first, last, next, prev;
  Links({this.first, this.last, this.next, this.prev});
  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json['first'], last: json['last'],
    next: json['next'],  prev: json['prev'],
  );
}

class Meta {
  final int currentPage, lastPage;
  final int? from;
  Meta({required this.currentPage, required this.lastPage, this.from});
  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: (json['current_page'] ?? 1) as int,
    lastPage: (json['last_page'] ?? 1) as int,
    from: json['from'] is int ? json['from'] : null,
  );
}
