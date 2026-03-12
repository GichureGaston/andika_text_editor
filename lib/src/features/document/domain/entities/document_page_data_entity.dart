import 'package:equatable/equatable.dart';
import 'package:flutter_quill/quill_delta.dart';

class DocumentPageDataEntity extends Equatable {
  const DocumentPageDataEntity({
    required this.id,
    required this.title,
    required this.content,
  });
  final String id;
  final String title;
  final Delta content;
  @override
  // TODO: implement props
  List<Object?> get props => [id, title, content];
  DocumentPageDataEntity copyWith({String? id, String? title, Delta? content}) {
    return DocumentPageDataEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
