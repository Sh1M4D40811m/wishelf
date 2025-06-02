import 'package:flutter/material.dart';
import 'package:wishelf/widgets/card/link_card.dart';
import 'package:wishelf/models/link.dart';

final class LinkPreviewCard extends StatelessWidget {
  final LinkItem item;

  const LinkPreviewCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LinkCard(
      item: item,
      status: LinkCardStatus.preview,
    );
  }
}