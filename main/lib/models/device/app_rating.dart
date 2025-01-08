class AppRating {
  final String comment;
  final double rating;

  AppRating({
    required this.comment,
    required this.rating
  });

  factory AppRating.fromJson(Map<String, dynamic> json) {
    return AppRating(
      comment: json["comment"] ?? "",
      rating: json["rating"] ?? ""
    );
  }

  factory AppRating.common() {
    return AppRating(
      comment: "",
      rating: 0.0
    );
  }

  AppRating copyWith({
    String? comment,
    double? rating
  }) {
    return AppRating(
      comment: comment ?? this.comment,
      rating: rating ?? this.rating
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
      "rating": rating
    };
  }
}