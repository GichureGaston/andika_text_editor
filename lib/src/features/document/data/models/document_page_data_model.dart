import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_page_data_model.g.dart';

@JsonSerializable()
class DocumentPageDataModel extends Equatable {
  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(defaultValue: '')
  final String? title;

  @JsonKey(fromJson: _deltaFromJson, toJson: _deltaToJson)
  final Delta content;

  const DocumentPageDataModel({
    required this.id,
    this.title,
    required this.content,
  });

  factory DocumentPageDataModel.fromMap(Map<String, dynamic> map) =>
      _$DocumentPageDataModelFromJson(map);

  Map<String, dynamic> toMap() => _$DocumentPageDataModelToJson(this);

  String toJson() => json.encode(toMap());

  factory DocumentPageDataModel.fromJson(String source) =>
      DocumentPageDataModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [title, content];

  DocumentPageDataModel copyWith({String? id, String? title, Delta? content}) {
    return DocumentPageDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

Delta _deltaFromJson(dynamic value) {
  if (value == null) return Delta()..insert('\n');
  try {
    final contentJson = jsonDecode(value as String);
    return Delta.fromJson(contentJson);
  } catch (_) {
    return Delta()..insert('\n');
  }
}

String _deltaToJson(Delta delta) => jsonEncode(delta.toJson());
