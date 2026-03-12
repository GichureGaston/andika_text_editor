part of 'document_bloc.dart';

@immutable
sealed class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

final class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

final class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

final class DocumentLoaded extends DocumentState {
  final DocumentPageDataModel document;

  const DocumentLoaded({required this.document});

  @override
  List<Object?> get props => [document];
}

final class DocumentListLoaded extends DocumentState {
  final List<DocumentPageDataModel> documents;

  const DocumentListLoaded({required this.documents});

  @override
  List<Object?> get props => [documents];
}

final class DocumentSavedSuccess extends DocumentState {
  const DocumentSavedSuccess();
}

final class DocumentCreatedSuccess extends DocumentState {
  const DocumentCreatedSuccess();
}

final class DocumentError extends DocumentState {
  final String message;

  const DocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}
