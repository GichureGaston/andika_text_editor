import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_quill/quill_delta.dart';

class DocumentPageDataModel extends Equatable {
  final String id;
  final String title;
  final Delta content;

  const DocumentPageDataModel({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      '\$id': id,
      'title': title,
      'content': jsonEncode(content.toJson()),
    };
  }

  factory DocumentPageDataModel.fromMap(Map<String, dynamic> map) {
    final contentJson = (map['content'] == null)
        ? []
        : jsonDecode(map['content']);
    return DocumentPageDataModel(
      id: map['\$id'],
      title: map['title'] ?? '',
      content: Delta.fromJson(contentJson),
    );
  }

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
