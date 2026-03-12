import 'dart:async';
import 'dart:convert';

import 'package:andika/src/features/document/data/models/delta_data_model.dart';
import 'package:andika/src/features/document/data/models/document_page_data_model.dart';
import 'package:andika/src/features/document/presentation/widgets/menu_bar.dart'
    as doc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import 'blocs/document_bloc.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key, required this.documentId});

  final String documentId;

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late final QuillController _quillController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  final _titleController = TextEditingController();
  Timer? _debounce;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    context.read<DocumentBloc>().add(
      LoadDocument(documentId: widget.documentId),
    );

    context.read<DocumentBloc>().add(
      SubscribeToDocument(pageId: widget.documentId),
    );

    _quillController.addListener(_onContentChanged);
    _titleController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    if (!_isLoaded) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _saveDocument);
  }

  void _saveDocument() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final updatedPage = DocumentPageDataModel(
      id: widget.documentId,
      title: _titleController.text,
      content: _quillController.document.toDelta(),
    );

    context.read<DocumentBloc>().add(
      UpdateDocument(documentId: widget.documentId, documentPage: updatedPage),
    );

    final deltaData = DeltaData(
      delta: jsonEncode(_quillController.document.toDelta().toJson()),
      user: authState.user.id,
      deviceId: authState.user.id,
    );

    context.read<DocumentBloc>().add(
      UpdateDocumentDelta(pageId: widget.documentId, deltaData: deltaData),
    );
  }

  void _loadDocumentIntoEditor(DocumentPageDataModel document) {
    if (_isLoaded) return;
    _isLoaded = true;

    _titleController.removeListener(_onContentChanged);
    _quillController.removeListener(_onContentChanged);

    _titleController.text = document.title ?? '';

    if (document.content.isNotEmpty) {
      _quillController.document = Document.fromDelta(document.content);
    }

    _titleController.addListener(_onContentChanged);
    _quillController.addListener(_onContentChanged);

    context.read<DocumentBloc>().add(
      SubscribeToDocument(pageId: widget.documentId),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _quillController.removeListener(_onContentChanged);
    _titleController.removeListener(_onContentChanged);
    _quillController.dispose();
    _titleController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentLoaded) {
          _loadDocumentIntoEditor(state.document);
        }
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
        return Scaffold(
          backgroundColor: const Color(0xFFF7F5F0),
          body: SafeArea(
            child: Column(
              children: [
                doc.MenuBar(
                  leading: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
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
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 240,
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1714),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Untitled document',
                          hintStyle: TextStyle(color: Color(0xFFB0A898)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                  trailing: [
                    if (state is DocumentLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF9C8E78),
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9C8E78),
                          ),
                        ),
                      ),
                  ],
                  newDocumentPressed: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      final newId = DateTime.now().millisecondsSinceEpoch
                          .toString();
                      context.read<DocumentBloc>().add(
                        CreateDocument(
                          documentId: newId,
                          owner: authState.user.id,
                        ),
                      );
                      context.go('/document/$newId');
                    }
                  },
                  openDocumentsPressed: () => context.go('/'),
                  signOutPressed: () =>
                      context.read<AuthBloc>().add(const SignOutEvent()),
                  undoPressed: () => _quillController.undo(),
                  redoPressed: () => _quillController.redo(),
                  copyPressed: () {
                    final selection = _quillController.getPlainText();
                    Clipboard.setData(ClipboardData(text: selection));
                  },
                  cutPressed: () {
                    final start = _quillController.selection.start;
                    final length = _quillController.selection.end - start;
                    final selection = _quillController.getPlainText();
                    Clipboard.setData(ClipboardData(text: selection));
                    _quillController.replaceText(
                      start,
                      length,
                      '',
                      TextSelection.collapsed(offset: start),
                    );
                  },
                ),
                QuillSimpleToolbar(
                  controller: _quillController,
                  config: const QuillSimpleToolbarConfig(
                    showDividers: true,
                    showFontFamily: false,
                    showFontSize: true,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: false,
                    showInlineCode: false,
                    showColorButton: true,
                    showBackgroundColorButton: false,
                    showClearFormat: true,
                    showAlignmentButtons: true,
                    showLeftAlignment: true,
                    showCenterAlignment: true,
                    showRightAlignment: true,
                    showJustifyAlignment: false,
                    showHeaderStyle: true,
                    showListNumbers: true,
                    showListBullets: true,
                    showListCheck: false,
                    showCodeBlock: false,
                    showQuote: true,
                    showIndent: true,
                    showLink: true,
                    showUndo: false,
                    showRedo: false,
                    showSearchButton: false,
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE0D8C8)),
                Expanded(
                  child: state is DocumentLoading && !_isLoaded
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1A1714),
                            strokeWidth: 2,
                          ),
                        )
                      : _EditorBody(
                          quillController: _quillController,
                          focusNode: _focusNode,
                          scrollController: _scrollController,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EditorBody extends StatelessWidget {
  const _EditorBody({
    required this.quillController,
    required this.focusNode,
    required this.scrollController,
  });

  final QuillController quillController;
  final FocusNode focusNode;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 816),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: QuillEditor(
            controller: quillController,
            focusNode: focusNode,
            scrollController: scrollController,
            config: const QuillEditorConfig(
              padding: EdgeInsets.all(40),
              autoFocus: false,
              expands: true,
              scrollable: true,
              placeholder: 'Start writing...',
            ),
          ),
        ),
      ),
    );
  }
}
