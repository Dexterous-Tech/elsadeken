
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/terms_conditions.dart';
import 'package:flutter/foundation.dart';

class TermsModel extends TermsAndConditions {
  TermsModel({
    required super.id,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing TermsModel from JSON: $json');
    
    final id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    final description = json['description'] ?? '';
    final createdAt = json['created_at'] ?? json['createdAt'] ?? '';
    final updatedAt = json['updated_at'] ?? json['updatedAt'] ?? '';
    
    debugPrint('Parsed values - id: $id, description: $description, createdAt: $createdAt, updatedAt: $updatedAt');
    
    return TermsModel(
      id: id,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
