// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_page_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentPageDataModel _$DocumentPageDataModelFromJson(
  Map<String, dynamic> json,
) => DocumentPageDataModel(
  id: json[r'$id'] as String,
  title: json['title'] as String? ?? '',
  content: _deltaFromJson(json['content']),
);

Map<String, dynamic> _$DocumentPageDataModelToJson(
  DocumentPageDataModel instance,
) => <String, dynamic>{
  r'$id': instance.id,
  'title': instance.title,
  'content': _deltaToJson(instance.content),
};
