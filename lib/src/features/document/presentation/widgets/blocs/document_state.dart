part of 'document_bloc.dart';

@immutable
sealed class DocumentState {}

final class DocumentInitial extends DocumentState {}

final class DocumentLoading extends DocumentState {}

final class DocumentLoadingSuccess extends DocumentState {}

final class DocumentSavedSuccess extends DocumentState {}

final class DocumentError extends DocumentState {}
