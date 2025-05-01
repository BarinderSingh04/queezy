class CreateQuiz {
  String? difficulty;
  int? categoryId;
  String? categoryName;
  String? type;
  String? description;

  CreateQuiz({this.difficulty, this.categoryId, this.categoryName, this.type, this.description});

  CreateQuiz copyWith({
    String? difficulty,
    int? categoryId,
    String? categoryName,
    String? type,
    String? description,
  }) {
    return CreateQuiz(
      difficulty: difficulty ?? this.difficulty,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}
