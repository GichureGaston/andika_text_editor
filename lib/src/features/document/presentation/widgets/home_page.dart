import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../document/data/remote/document_remote_repository.dart';
import 'blocs/document_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentBloc(documentRepo: DocumentRemoteRepo()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<DocumentBloc>().add(
        LoadAllDocuments(userId: authState.user.id),
      );
    }
  }

  void _createAndNavigate(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<DocumentBloc>().add(
      CreateDocument(documentId: newId, owner: authState.user.id),
    );
    context.go('/document/$newId');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is! AuthAuthenticated && current is AuthAuthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<DocumentBloc>().add(
            LoadAllDocuments(userId: state.user.id),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F5F0),
          elevation: 0,
          titleSpacing: 20,
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1714),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFFF0E6C8),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Andika',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1714),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout_rounded, color: Color(0xFF1A1714)),
              onPressed: () =>
                  context.read<AuthBloc>().add(const SignOutEvent()),
            ),
            const SizedBox(width: 8),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: Color(0xFFE0D8C8)),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createAndNavigate(context),
          backgroundColor: const Color(0xFF1A1714),
          foregroundColor: const Color(0xFFF0E6C8),
          icon: const Icon(Icons.add),
          label: const Text(
            'New document',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: BlocConsumer<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is DocumentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFB04040),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DocumentLoading || state is DocumentInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1A1714),
                  strokeWidth: 2,
                ),
              );
            }

            if (state is DocumentListLoaded) {
              if (state.documents.isEmpty) {
                return const _EmptyState();
              }
              return _DocumentList(documents: state.documents);
            }

            if (state is DocumentError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFFB04040),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(color: Color(0xFF6B5E52)),
                    ),
                  ],
                ),
              );
            }

            return const _EmptyState();
          },
        ),
      ),
    );
  }
}

class _DocumentList extends StatelessWidget {
  const _DocumentList({required this.documents});

  final List documents;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
      itemCount: documents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _DocumentTile(document: doc);
      },
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  final dynamic document;

  String _getPreview() {
    try {
      if (document.content.isNotEmpty) {
        final quillDoc = Document.fromDelta(document.content);
        final text = quillDoc.toPlainText().trim();
        return text.isEmpty ? 'Empty document' : text;
      }
    } catch (_) {}
    return 'Empty document';
  }

  @override
  Widget build(BuildContext context) {
    final title = (document.title == null || document.title!.isEmpty)
        ? 'Untitled document'
        : document.title!;
    final preview = _getPreview();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.go('/document/${document.id}'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0D8C8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E6C8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(
                    Icons.description_outlined,
                    color: Color(0xFF1A1714),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1714),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      preview,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9C8E78),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFB0A898),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E6C8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.description_outlined,
                size: 36,
                color: Color(0xFF1A1714),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No documents yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1714),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap the button below to create your first document.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9C8E78)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
