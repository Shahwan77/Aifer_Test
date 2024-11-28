class UnsplashPhoto {
  final String id;
  final String description;
  final String altDescription;
  final String imageUrl;
  final String FullimageUrl;
  final String downloadUrl;

  UnsplashPhoto({
    required this.id,
    required this.description,
    required this.altDescription,
    required this.imageUrl,
    required this.FullimageUrl,
    required this.downloadUrl,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'],
      description: json['description'] ?? '',
      altDescription: json['alt_description'] ?? '',
      imageUrl: json['urls']['regular'],
      FullimageUrl: json['urls']['full'],
      downloadUrl: json['links']['download'],
    );
  }
}