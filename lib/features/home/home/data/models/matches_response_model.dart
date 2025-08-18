import 'package:elsadeken/features/home/home/data/models/match_user_model.dart';
import 'package:elsadeken/features/home/home/data/models/pagination_model.dart';
import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';

class MatchesResponseModel {
  final List<MatchUserModel> data;
  final PaginationLinksModel links;
  final PaginationMetaModel meta;
  final String message;
  final int code;
  final String type;

  MatchesResponseModel({
    required this.data,
    required this.links,
    required this.meta,
    required this.message,
    required this.code,
    required this.type,
  });

  factory MatchesResponseModel.fromJson(Map<String, dynamic> json) {
    return MatchesResponseModel(
      data: (json['data'] as List)
          .map((i) => MatchUserModel.fromJson(i))
          .toList(),
      links: PaginationLinksModel.fromJson(json['links']),
      meta: PaginationMetaModel.fromJson(json['meta']),
      message: json['message'],
      code: json['code'],
      type: json['type'],
    );
  }

  // Add this method to convert to entity
  List<MatchUserEntity> toEntities() {
    return data.map((model) => model.toEntity()).toList();
  }
}