import 'dart:async';

import 'package:andika/src/core/errors/repository_exception.dart';

import '../models/delta_data_model.dart';
import '../models/document_page_data_model.dart';

abstract class DocumentRepo with RepositoryExceptionMixin {
  Future<void> createNewPage({
    required String documentId,
    required String owner,
  });
  Future<void> _createPageAndDelta({
    required String documentId,
    required String owner,
  });
  Future<DocumentPageDataModel> getPage({required String documentId});

  Future<DocumentPageDataModel> _getPage(String documentId);

  Future<List<DocumentPageDataModel>> getAllPages(String userId);

  Future<List<DocumentPageDataModel>> _getAllPages(String userId);

  Future<void> updatePage({
    required String documentID,
    required DocumentPageDataModel documentPage,
  });
  Future<void> updateDelta({
    required String pageId,
    required DeltaData deltaData,
  });
}

class DocumentRemoteRepo implements DocumentRepo {
  @override
  Future<void> _createPageAndDelta({
    required String documentId,
    required String owner,
  }) {
    // TODO: implement _createPageAndDelta
    throw UnimplementedError();
  }

  @override
  Future<List<DocumentPageDataModel>> _getAllPages(String userId) {
    // TODO: implement _getAllPages
    throw UnimplementedError();
  }

  @override
  Future<DocumentPageDataModel> _getPage(String documentId) {
    // TODO: implement _getPage
    throw UnimplementedError();
  }

  @override
  Future<void> createNewPage({
    required String documentId,
    required String owner,
  }) {
    // TODO: implement createNewPage
    throw UnimplementedError();
  }

  @override
  Future<T> exceptionHandler<T>(
    FutureOr<dynamic> computation, {
    String unkownMessage = 'Repository Exception',
  }) {
    // TODO: implement exceptionHandler
    throw UnimplementedError();
  }

  @override
  Future<List<DocumentPageDataModel>> getAllPages(String userId) {
    // TODO: implement getAllPages
    throw UnimplementedError();
  }

  @override
  Future<DocumentPageDataModel> getPage({required String documentId}) {
    // TODO: implement getPage
    throw UnimplementedError();
  }

  @override
  Future<void> updateDelta({
    required String pageId,
    required DeltaData deltaData,
  }) {
    // TODO: implement updateDelta
    throw UnimplementedError();
  }

  @override
  Future<void> updatePage({
    required String documentID,
    required DocumentPageDataModel documentPage,
  }) {
    // TODO: implement updatePage
    throw UnimplementedError();
  }
}
