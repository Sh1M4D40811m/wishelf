import 'link.dart';

final class Folder {
  final String id;
  String title;
  String colorHex;
  List<LinkItem> links;

  Folder({
    required this.id,
    required this.title,
    required this.colorHex,
    List<LinkItem>? links,
  }) : links = links ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'colorHex': colorHex,
    'links': links.map((e) => e.toJson()).toList(),
  };

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
    id: json['id'],
    title: json['title'],
    colorHex: json['colorHex'],
    links: (json['links'] as List).map((e) => LinkItem.fromJson(e)).toList(),
  );
}
