import 'package:flutter/material.dart';

final class FolderColor {
  final String name;
  final Color color;

  const FolderColor(this.name, this.color);

  String get hex =>
      color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
}

final class FolderColors {
  static const List<FolderColor> values = [
    FolderColor('ミルク', Color(0xFFFFFFFF)),
    FolderColor('カフェオレ', Color(0xFFECD4C2)),
    FolderColor('ココア', Color(0xFFDCBCB6)),
    FolderColor('クリームソーダ', Color(0xFFF4FFEA)),
    FolderColor('ラムネ', Color(0xFFE2FBFC)),
    FolderColor('レモネード', Color(0xFFFFFCC8)),
  ];
}
