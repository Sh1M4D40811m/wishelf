import 'link.dart';

class Folder {
  String id;
  String title;
  String colorHex;
  List<Link> links;

  Folder({
    required this.id,
    required this.title,
    required this.colorHex,
    this.links = const [],
  });

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
    links: (json['links'] as List).map((e) => Link.fromJson(e)).toList(),
  );
}
