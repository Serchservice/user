/// Selected media type
enum MediaType {
  /// From camera video
  video("Video"),

  /// From camera photo
  photo("Photo");

  const MediaType(this.type);
  final String type;
}

extension StringToMediaType on String {
  /// Convert a string to a `MediaType` enum.
  MediaType toMediaType() {
    switch (this) {
      case "Video":
        return MediaType.video;
      case "Photo":
        return MediaType.photo;
      default:
        return MediaType.video;
    }
  }
}