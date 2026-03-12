part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent extends Equatable {
  const DocumentEvent();
  @override
  List<Object?> get props => [];
}

class CreateDocument extends DocumentEvent {
  final String documentId;
  final String owner;

  const CreateDocument({required this.documentId, required this.owner});

  @override
  List<Object?> get props => [documentId, owner];
}

class LoadDocument extends DocumentEvent {
  final String documentId;

  const LoadDocument({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}

class LoadAllDocuments extends DocumentEvent {
  final String userId;

  const LoadAllDocuments({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateDocument extends DocumentEvent {
  final String documentId;
  final DocumentPageDataModel documentPage;

  const UpdateDocument({required this.documentId, required this.documentPage});

  @override
  List<Object?> get props => [documentId, documentPage];
}

class UpdateDocumentDelta extends DocumentEvent {
  final String pageId;
  final DeltaData deltaData;

class SaveDocument extends DocumentEvent {}

  @override
  List<Object?> get props => [pageId, deltaData];
}

class SubscribeToDocument extends DocumentEvent {
  final String pageId;

  const SubscribeToDocument({required this.pageId});

  @override
  List<Object?> get props => [pageId];
}
