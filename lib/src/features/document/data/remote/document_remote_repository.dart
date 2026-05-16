import 'dart:async';

import 'package:andika/src/core/errors/repository_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/envied/env.dart';
import '../models/delta_data_model.dart';
import '../models/document_page_data_model.dart';

abstract class DocumentRepo {
  Future<void> createNewPage({
    required String documentId,
    required String owner,
  });

  Future<DocumentPageDataModel> getPage({required String documentId});

  Future<List<DocumentPageDataModel>> getAllPages(String userId);

  Future<void> updatePage({
    required String documentId,
    required DocumentPageDataModel documentPage,
  });

  Future<void> updateDelta({
    required String pageId,
    required DeltaData deltaData,
  });

  Stream<DocumentSnapshot> subscribeToPage({required String pageId});
}

class DocumentRemoteRepo implements DocumentRepo {
  DocumentRemoteRepo({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> createNewPage({
    required String documentId,
    required String owner,
  }) {
    return repoExceptionHandler(
      _createPageAndDelta(documentId: documentId, owner: owner),
    );
  }

  Future<void> _createPageAndDelta({
    required String documentId,
    required String owner,
  }) async {
    await Future.wait([
      _firestore.collection(CollectionNames.pages).doc(documentId).set({
        'owner': owner,
        'title': null,
        'content': null,
      }),
      _firestore.collection(CollectionNames.delta).doc(documentId).set({
        'delta': null,
        'user': null,
        'deviceId': null,
      }),
    ]);
  }

  @override
  Future<DocumentPageDataModel> getPage({required String documentId}) {
    return repoExceptionHandler(_getPage(documentId));
  }

  Future<DocumentPageDataModel> _getPage(String documentId) async {
    final doc = await _firestore
        .collection(CollectionNames.pages)
        .doc(documentId)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw RepositoryException(message: 'Page not found');
    }

    return DocumentPageDataModel.fromMap({'\$id': doc.id, ...doc.data()!});
  }

  @override
  Future<List<DocumentPageDataModel>> getAllPages(String userId) {
    return repoExceptionHandler(_getAllPages(userId));
  }

  Future<List<DocumentPageDataModel>> _getAllPages(String userId) async {
    final result = await _firestore
        .collection(CollectionNames.pages)
        .where('owner', isEqualTo: userId)
        .get();

    return result.docs.map((doc) {
      return DocumentPageDataModel.fromMap({'\$id': doc.id, ...doc.data()});
    }).toList();
  }

  @override
  Future<void> updatePage({
    required String documentId,
    required DocumentPageDataModel documentPage,
  }) {
    return repoExceptionHandler(
      _firestore
          .collection(CollectionNames.pages)
          .doc(documentId)
          .update(documentPage.toMap()),
    );
  }

  @override
  Future<void> updateDelta({
    required String pageId,
    required DeltaData deltaData,
  }) {
    return repoExceptionHandler(
      _firestore
          .collection(CollectionNames.delta)
          .doc(pageId)
          .update(deltaData.toMap()),
    );
  }

  @override
  Stream<DocumentSnapshot> subscribeToPage({required String pageId}) {
    try {
      return _firestore
          .collection(CollectionNames.delta)
          .doc(pageId)
          .snapshots();
    } on FirebaseException catch (e) {
      throw RepositoryException(message: e.message ?? 'Firebase error');
    } on Exception catch (e, st) {
      throw RepositoryException(
        message: 'Error subscribing to page changes',
        exception: e,
        stackTrace: st,
      );
    }
  }
}
