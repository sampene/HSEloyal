class ApiExceptionModel {
  ApiExceptionModel({
    this.error,
  });

  String error;

  factory ApiExceptionModel.fromJson(Map<String, dynamic> json) => ApiExceptionModel(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}
