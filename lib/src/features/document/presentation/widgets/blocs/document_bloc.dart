import 'dart:async';

import 'package:andika/src/features/document/data/models/delta_data_model.dart';
import 'package:andika/src/features/document/data/models/document_page_data_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/document_remote_repository.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc({required DocumentRepo documentRepo})
    : _documentRepo = documentRepo,
      super(const DocumentInitial()) {
    on<CreateDocument>(_onCreateDocument);
    on<LoadDocument>(_onLoadDocument);
    on<LoadAllDocuments>(_onLoadAllDocuments);
    on<UpdateDocument>(_onUpdateDocument);
    on<UpdateDocumentDelta>(_onUpdateDocumentDelta);
    on<SubscribeToDocument>(_onSubscribeToDocument);
  }

  final DocumentRepo _documentRepo;
  StreamSubscription<DocumentSnapshot>? _documentSubscription;

  Future<void> _onCreateDocument(
    CreateDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());
    try {
      await _documentRepo.createNewPage(
        documentId: event.documentId,
        owner: event.owner,
      );
      emit(const DocumentCreatedSuccess());
    } on Exception catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onLoadDocument(
    LoadDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());
    try {
      final document = await _documentRepo.getPage(
        documentId: event.documentId,
      );
      emit(DocumentLoaded(document: document));
    } on Exception catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onLoadAllDocuments(
    LoadAllDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(const DocumentLoading());
    try {
      final documents = await _documentRepo.getAllPages(event.userId);
      emit(DocumentListLoaded(documents: documents));
    } on Exception catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDocument(
    UpdateDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await _documentRepo.updatePage(
        documentId: event.documentId,
        documentPage: event.documentPage,
      );
      emit(const DocumentSavedSuccess());
    } on Exception catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDocumentDelta(
    UpdateDocumentDelta event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      await _documentRepo.updateDelta(
        pageId: event.pageId,
        deltaData: event.deltaData,
      );
    } on Exception catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onSubscribeToDocument(
    SubscribeToDocument event,
    Emitter<DocumentState> emit,
  ) async {
    await _documentSubscription?.cancel();

    await emit.onEach<DocumentSnapshot>(
      _documentRepo.subscribeToPage(pageId: event.pageId),
      onData: (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data() as Map<String, dynamic>;
          final document = DocumentPageDataModel.fromMap({
            '\$id': snapshot.id,
            ...data,
          });
          emit(DocumentLoaded(document: document));
        }
      },
      onError: (error, _) => emit(DocumentError(message: error.toString())),
    );
  }

  @override
  Future<void> close() {
    _documentSubscription?.cancel();
    return super.close();
  }
}
