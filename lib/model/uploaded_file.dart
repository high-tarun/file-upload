class UploadedFilesModel {
  String url;
  String category;
  String subCategory;
  String comments;

  UploadedFilesModel({
    required this.category,
    required this.comments,
    required this.subCategory,
    required this.url,
  });

  factory UploadedFilesModel.fromMap(Map<String, dynamic> map) {
    return UploadedFilesModel(
      category: map["category"] ?? "",
      comments: map["comment"] ?? "",
      subCategory: map["sub_category"] ?? "",
      url: map["url"] ?? "",
    );
  }

  UploadedFilesModel copyWith({
    String? category,
    String? comments,
    String? subCategory,
    String? url,
  }) {
    return UploadedFilesModel(
      category: category ?? this.category,
      comments: comments ?? this.comments,
      subCategory: subCategory ?? this.subCategory,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "comment": comments,
      "sub_category": subCategory,
      "category": category,
      "url": url,
    };
  }
}
