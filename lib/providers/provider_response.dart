class ProviderResponse {
  bool success;
  String message;
  final data;

  ProviderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
    };
}
