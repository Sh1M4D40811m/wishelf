import 'package:flutter/material.dart';

enum PopupMenuItemWithIconType { normal, destructive }

extension PopupMenuItemWithIconStyle on PopupMenuItemWithIconType {
  Color color(BuildContext context) {
    final theme = Theme.of(context);
    return switch (this) {
      PopupMenuItemWithIconType.normal => theme.colorScheme.onSurface,
      PopupMenuItemWithIconType.destructive => theme.colorScheme.error,
    };
  }
}

final class PopupMenuItemWithIcon extends PopupMenuItem<String> {
  PopupMenuItemWithIcon({
    required String super.value,
    required IconData icon,
    required String text,
    PopupMenuItemWithIconType type = PopupMenuItemWithIconType.normal,
    super.key,
  }) : super(
         child: Builder(
           builder: (context) {
             final color = type.color(context);
             return Row(
               children: [
                 Icon(icon, color: color),
                 const SizedBox(width: 8),
                 Text(text, style: TextStyle(color: color)),
               ],
             );
           },
         ),
       );
}
