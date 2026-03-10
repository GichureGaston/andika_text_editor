import 'package:andika/src/features/document/data/models/delta_data_model.dart';
import 'package:andika/src/features/document/domain/entities/document_page_data_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';

abstract class DocumentRepository {
  Future<Either<Failure, DocumentPageDataEntity>> getPage({String? documentId});
  Future<Either<Failure, List<DocumentPageDataEntity>?>> getAllPages(
    String? documentId,
  );

  Future<Either<Failure, void>> createNewPage({
    String? documentId,
    String? owner,
  });
  Future<Either<Failure, void>> updatePage(
    String? documentId,
    DocumentPageDataEntity? documentPageDataEntity,
  );
  Future<Either<Failure, void>> updateDelta(
    String? pageId,
    DeltaData? deltaData,
  );
}
