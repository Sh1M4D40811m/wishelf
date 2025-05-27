import 'package:flutter/material.dart';
import 'package:wishelf/models/link.dart';

enum LinkCardStatus { normal, selected, preview }

final class LinkCard extends StatelessWidget {
  final LinkItem item;
  final LinkCardStatus status;
  const LinkCard({super.key, required this.item, required this.status});

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
            onTap: () {},
            child: _buildCardContents(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContents(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
          _buildThubmnail(context, item.imageUrl!),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: status == LinkCardStatus.normal ? 0 : 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (status == LinkCardStatus.normal) ...[_buildMoreMenu(context)],
      ],
    );
  }

  Widget _buildThubmnail(BuildContext context, String imageUrl) {
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
          return Container(
            height: 150,
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey[500],
                size: 48,
              ),
            ),
          );
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
          // TODO: add edit action
        } else if (value == 'delete') {
          // TODO: add delete action
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 8),
                  Text('削除'),
                ],
              ),
            ),
          ],
    );
  }
}
