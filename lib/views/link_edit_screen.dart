import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/services/storage_service.dart';
import 'package:wishelf/widgets/folder_colors.dart';
import 'package:wishelf/widgets/link_card.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/viewmodels/link_edit_view_model.dart';

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
          if (data.title != null &&
              data.title!.isNotEmpty &&
              _titleController.text.trim().isEmpty) {
            _titleController.text = data.title!;
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

  void _submitLink() {
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: _urlController.text.trim(),
      title: _titleController.text.trim(),
      imageUrl: _fetchedMetadata?.image,
      description: _fetchedMetadata?.description,
    );
    if (widget.initialItem != null) {
      link.id = widget.initialItem!.id;
      vm.updateLinkInFolder(_selectedFolderId!, link);
    } else {
      vm.addLinkToFolder(_selectedFolderId!, link);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.initialItem != null ? 'リンクを編集' : 'リンクを追加'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFolderDropdown(),
            SizedBox(height: 24),
            _buildURLTextField(),
            SizedBox(height: 24),
            _buildTitleTextField(),
            SizedBox(height: 24),
            if (_isFetchingMetadata) ...[
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 8),
              Center(
                child: Text("データ取得中...", style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 16),
            ],
            if (_fetchedMetadata != null) ...[
              LinkCard(
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
                status: LinkCardStatus.preview,
              ),
            ],
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

  Widget _buildFolderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: '保存先フォルダ'),
      value: _selectedFolderId,
      items:
          _folders.map((folder) {
            return DropdownMenuItem<String>(
              value: folder.id,
              child: Row(
                children: [
                  DecoratedIcon(
                    icon: Icon(
                      Icons.folder,
                      color: FolderColor.fromHex(folder.colorHex).color,
                    ),
                    decoration: IconDecoration(
                      border: IconBorder(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(folder.title),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (mounted) {
          setState(() {
            _selectedFolderId = value;
          });
        }
      },
    );
  }

  Widget _buildURLTextField() {
    return TextField(
      controller: _urlController,
      focusNode: _urlFocusNode,
      decoration: InputDecoration(
        labelText: 'リンクを貼り付け',
        hintText: 'https://example.com',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        errorText: _urlErrorText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.paste_outlined),
              onPressed: () async {
                final data = await Clipboard.getData(Clipboard.kTextPlain);
                if (data != null && data.text != null) {
                  _urlController.text = data.text!;
                  _fetchMetadata(_urlController.text.trim());
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel_outlined),
              onPressed: () {
                _urlController.clear();
                _fetchMetadata('');
              },
            ),
          ],
        ),
      ),
      keyboardType: TextInputType.url,
      onChanged: (value) {
        _fetchMetadata(value);
      },
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _titleController,
      focusNode: _titleFocusNode,
      decoration: InputDecoration(
        labelText: 'タイトルを編集',
        hintText: 'リンクから自動入力されます',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        suffixIcon:
            _titleFocusNode.hasFocus
                ? IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    _titleController.clear();
                    _updateButtonState();
                  },
                )
                : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          _titleErrorText = '必須項目です。';
        } else {
          _titleErrorText = null;
        }
        return _titleErrorText;
      },
    );
  }
}
