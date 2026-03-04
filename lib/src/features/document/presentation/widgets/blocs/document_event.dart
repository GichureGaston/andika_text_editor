part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent extends Equatable {
  const DocumentEvent();
  @override
  List<Object> get props => [];
}

class CreateDocument extends DocumentEvent {}

class SaveDocument extends DocumentEvent {}

class CheckDocumentForError extends DocumentEvent {}

class EditDocument extends DocumentEvent {}
