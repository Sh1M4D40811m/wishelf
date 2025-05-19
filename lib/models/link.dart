import 'package:metadata_fetch/metadata_fetch.dart';

final class LinkItem {
  String id;
  String url;
  String title;
  String? description;
  String? imageUrl;

  LinkItem({
    required this.id,
    required this.url,
    required this.title,
    this.description,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
  };

  factory LinkItem.fromMetadata(String url, Metadata data) {
    return LinkItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      title: data.title ?? '無題',
      description: data.description,
      imageUrl: data.image,
    );
  }

  factory LinkItem.fromJson(Map<String, dynamic> json) => LinkItem(
    id: json['id'],
    url: json['url'],
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'] ?? '',
  );
}