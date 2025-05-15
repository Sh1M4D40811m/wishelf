// FIXME: 仮実装。imageurlは使わずにurlからサムネイル取得できるか検証する
class Link {
  String title;
  String url;
  String imageUrl;

  Link({
    required this.title,
    required this.url,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'imageUrl': imageUrl,
  };

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    title: json['title'],
    url: json['url'],
    imageUrl: json['imageUrl'] ?? '',
  );
}