class APIResponse<T> {
  dynamic data;
  bool error;
  String message;

  APIResponse({this.data, this.error = false, this.message = ""});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      error: json['status'] != null ? (json['status'] == 200 ? false : true) : true,
      message: json['message'] ?? "",
      data: json['data'],
    );
  }
}
