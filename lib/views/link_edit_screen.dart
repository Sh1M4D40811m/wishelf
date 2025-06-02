import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/services/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/viewmodels/link_edit_view_model.dart';
import 'package:wishelf/widgets/link_edit/folder_dropdown.dart';
import 'package:wishelf/widgets/link_edit/link_preview_card.dart';
import 'package:wishelf/widgets/link_edit/title_text_field.dart';
import 'package:wishelf/widgets/link_edit/url_text_field.dart';

final class LinkEditScreen extends StatefulWidget {
  final LinkItem? initialItem;
  final Folder folder;

  const LinkEditScreen({
    super.key,
    required this.initialItem,
    required this.folder,
  });

  @override
  State<LinkEditScreen> createState() => _LinkEditScreenState();
}

final class _LinkEditScreenState extends State<LinkEditScreen> {
  late TextEditingController _urlController;
  late TextEditingController _titleController;
  late FocusNode _urlFocusNode;
  late FocusNode _titleFocusNode;

  bool _isButtonEnabled = false;
  String? _selectedFolderId;
  List<Folder> _folders = [];
  Metadata? _fetchedMetadata;
  bool _isFetchingMetadata = false;
  String? _urlErrorText;
  String? _titleErrorText;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialItem?.url ?? '');
    _titleController = TextEditingController(
      text: widget.initialItem?.title ?? '',
    );
    _urlFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
    _isButtonEnabled = _urlController.text.trim().isNotEmpty;

    _titleFocusNode.addListener(_handleTitleFocusChange);
    _urlController.addListener(_onTextChanged);
    _titleController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _urlFocusNode.requestFocus();
    });

    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await StorageService().loadFolders();
    if (!mounted) return;
    setState(() {
      _folders = folders;
      if (_folders.isNotEmpty) {
        if (widget.folder.id.isNotEmpty &&
            _folders.any((f) => f.id == widget.folder.id)) {
          _selectedFolderId = widget.folder.id;
        } else if (_folders.isNotEmpty) {
          _selectedFolderId = _folders.first.id;
        }
      }
    });
  }

  @override
  void dispose() {
    _urlController.removeListener(_onTextChanged);
    _titleController.removeListener(_onTextChanged);
    _urlController.dispose();
    _urlFocusNode.dispose();
    _titleController.dispose();
    _titleFocusNode.removeListener(_handleTitleFocusChange);
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _handleTitleFocusChange() {
    if (!_titleFocusNode.hasFocus &&
        _titleController.text.trim().isEmpty &&
        _fetchedMetadata != null &&
        _fetchedMetadata!.title != null &&
        _fetchedMetadata!.title!.isNotEmpty) {
      setState(() {
        _titleController.text = _fetchedMetadata!.title!;
      });
    }
    _updateButtonState();
    if (mounted) {
      setState(() {});
    }
  }

  void _onTextChanged() {
    if (FocusManager.instance.primaryFocus == _urlFocusNode) {
      _fetchMetadata(_urlController.text);
    } else {
      _updateButtonState();
    }
  }

  void _updateButtonState() {
    if (!mounted) return;
    setState(() {
      final urlValid =
          _urlController.text.trim().isNotEmpty && _urlErrorText == null;
      final titleValid = _titleController.text.trim().isNotEmpty;
      _isButtonEnabled = urlValid && titleValid;
    });
  }

  Future<void> _fetchMetadata(String url) async {
    final trimmedUrl = url.trim();

    if (trimmedUrl.isEmpty) {
      setState(() {
        _urlErrorText = 'URLを入力してください。';
        _titleController.clear();
        _fetchedMetadata = null;
      });
      _updateButtonState();
      return;
    }

    if (mounted) {
      setState(() {
        _isFetchingMetadata = true;
        _fetchedMetadata = null;
      });
    }

    try {
      final data = await MetadataFetch.extract(trimmedUrl);
      if (!mounted) return;

      if (data != null) {
        setState(() {
          _fetchedMetadata = data;
          if (data.title != null && data.title!.isNotEmpty) {
            if (_titleController.text.trim().isEmpty) {
              _titleController.text = data.title!;
            }
          } else {
            _titleController.clear();
          }
          _urlErrorText = null;
        });
      } else {
        setState(() {
          _fetchedMetadata = null;
          _titleController.clear();
          _urlErrorText = 'URLが存在しないか、アクセスできない可能性があります。';
        });
      }
    } catch (e) {
      if (!mounted) return;
      String errorMessage = 'メタデータの取得中にエラーが発生しました。';
      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('handshakeexception')) {
        errorMessage = 'ネットワークエラー。URLが正しいか、接続を確認してください。';
      } else if (e.toString().toLowerCase().contains('http status error') ||
          e.toString().contains('404')) {
        errorMessage = 'URLが見つかりません (404)。';
      }
      setState(() {
        _fetchedMetadata = null;
        _titleController.clear();
        _urlErrorText = errorMessage;
      });
    } finally {
      setState(() {
        _isFetchingMetadata = false;
      });
      _updateButtonState();
    }
  }

  Future<void> _submitLink() async {
    if (!_isButtonEnabled ||
        _urlController.text.trim().isEmpty ||
        _urlErrorText != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_urlErrorText ?? 'URLを入力し、内容を確認してください。')),
      );
      _urlFocusNode.requestFocus();
      return;
    }

    final vm = Provider.of<LinkEditViewModel>(context, listen: false);
    final link = LinkItem(
      id:
          widget.initialItem?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      url: _urlController.text.trim(),
      title: _titleController.text.trim(),
      imageUrl: _fetchedMetadata?.image,
      description: _fetchedMetadata?.description,
    );

    await vm.saveLink(
      link: link,
      targetFolderId: _selectedFolderId!,
      originalFolderId: widget.initialItem != null ? widget.folder.id : null,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.initialItem != null ? 'リンクの編集' : 'リンクの追加'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FolderDropdown(
              folders: _folders,
              selectedFolderId: _selectedFolderId,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _selectedFolderId = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            UrlTextField(
              controller: _urlController,
              focusNode: _urlFocusNode,
              errorText: _urlErrorText,
              onChanged: (value) {
                _fetchMetadata(value);
              },
              onClear: () {
                _urlController.clear();
                _fetchMetadata('');
              },
              onPaste: () async {
                final data = await Clipboard.getData(Clipboard.kTextPlain);
                if (data != null && data.text != null) {
                  _urlController.text = data.text!;
                  _fetchMetadata(_urlController.text.trim());
                }
              },
            ),
            SizedBox(height: 24),
            TitleTextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              errorText: _titleErrorText,
              onClear: () {
                _titleController.clear();
                _updateButtonState();
              },
            ),
            SizedBox(height: 24),
            if (_isFetchingMetadata) ...[
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 8),
              Center(
                child: Text("データ取得中...", style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 16),
            ],
            if (_fetchedMetadata != null)
              LinkPreviewCard(
                item: LinkItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title:
                      _titleController.text.isNotEmpty
                          ? _titleController.text
                          : _fetchedMetadata!.title ?? '',
                  description: _fetchedMetadata?.description,
                  imageUrl: _fetchedMetadata?.image,
                  url: _urlController.text.trim(),
                ),
              ),
            SizedBox(height: 80), // FABのためのスペース
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isButtonEnabled ? _submitLink : null,
        icon: Icon(widget.initialItem != null ? Icons.save : Icons.add),
        label: Text(
          widget.initialItem != null ? '更新' : '追加',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            _isButtonEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
        foregroundColor:
            _isButtonEnabled
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
