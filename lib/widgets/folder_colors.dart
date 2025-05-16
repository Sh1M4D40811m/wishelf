import 'package:flutter/material.dart';

enum FolderColor {
  milk('ミルク', Color(0xFFFFFFFF)),
  cafeAuLait('カフェオレ', Color(0xFFECD4C2)),
  cocoa('ココア', Color(0xFFDCBCB6)),
  creamSoda('クリームソーダ', Color(0xFFF4FFEA)),
  ramune('ラムネ', Color(0xFFE2FBFC)),
  lemonade('レモネード', Color(0xFFFFFCC8));

  final String label;
  final Color color;

  const FolderColor(this.label, this.color);

  String get hex => color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();

  static fromHex(String hex) {
    return values.firstWhere(
      (color) => color.hex == hex,
      orElse: () => milk,
    );
  }
}
