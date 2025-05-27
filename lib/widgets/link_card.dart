import 'package:flutter/material.dart';
import 'package:wishelf/models/link.dart';
import 'package:url_launcher/url_launcher.dart';

enum LinkCardStatus { normal, selected, preview }

enum LinkCardMenuType { edit, delete }

class LinkCard extends StatefulWidget {
  final LinkItem item;
  final LinkCardStatus status;
  final void Function(LinkCardMenuType type)? onTapMenu;
  const LinkCard({
    super.key,
    required this.item,
    required this.status,
    this.onTapMenu,
  });

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  bool _hasImageError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 120,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final url = Uri.tryParse(widget.item.url);
              print("Parsed URL: $url");
              print("URL Scheme: ${url?.scheme}");
              if (url != null && await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('リンクを開けませんでした')));
              }
            },
            child: _buildCardContents(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContents(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.item.imageUrl != null &&
            widget.item.imageUrl!.isNotEmpty &&
            !_hasImageError)
          _buildThumbnail(context, widget.item.imageUrl!),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left:
                  widget.item.imageUrl != null &&
                          widget.item.imageUrl!.isNotEmpty &&
                          !_hasImageError
                      ? 8
                      : 16,
              right: widget.status == LinkCardStatus.normal ? 0 : 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.item.description != null &&
                    widget.item.description!.isNotEmpty)
                  Text(
                    widget.item.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
        if (widget.status == LinkCardStatus.normal) _buildMoreMenu(context),
      ],
    );
  }

  Widget _buildThumbnail(BuildContext context, String imageUrl) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _hasImageError = true;
              });
            }
          });
          return const SizedBox.shrink(); // 空のWidget（表示しない）
        },
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          widget.onTapMenu?.call(LinkCardMenuType.edit);
        } else if (value == 'delete') {
          widget.onTapMenu?.call(LinkCardMenuType.delete);
        }
      },
      itemBuilder:
          (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 8),
                  Text('リンクを編集'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '削除',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
