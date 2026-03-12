import 'package:andika/src/features/document/data/models/document_page_data_model.dart';
import 'package:andika/src/features/document/domain/entities/document_page_data_entity.dart';

class DocumentMapper {
  static DocumentPageDataModel toModel(DocumentPageDataEntity entity) {
    return DocumentPageDataModel(
      id: entity.id,
      title: entity.title,
      content: entity!.content,
    );
  }

  static DocumentPageDataEntity toEntity(DocumentPageDataModel model) {
    return DocumentPageDataEntity(
      id: model.id,
      title: model.title ?? '',
      content: model.content,
    );
  }
}
